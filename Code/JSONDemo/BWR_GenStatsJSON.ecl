IMPORT Std;

SalesTotals := 'RecordCount = ' + 
               COUNT($.Sales.File) + ',' +
               'TotalSales = ' + 
               SUM($.Sales.File.Sales,TotalAmt);

StoreTbl1 := 
   TABLE($.Sales.File,
         {StoreID,
          TotalSales := SUM(GROUP,
                            SUM(Sales,TotalAmt))},
         StoreID);
StoreTbl2 := 
   TABLE($.Sales.File,
         {StoreID,TransDate,
          TotalSales := SUM(GROUP,
                            SUM(Sales,TotalAmt))},
         StoreID,TransDate);

RptRec := RECORD
  STRING Totals;
  DATASET(RECORDOF(StoreTbl1)) SalesPerStore;
  DATASET(RECORDOF(StoreTbl2)) SalesPerStoreByDate;
END;

Report := DATASET([{SalesTotals,
                    SORT(StoreTbl1,StoreID),
                    SORT(StoreTbl2,
                         StoreID,
                         TransDate)}],
                  RptRec);

outfile := 'JSON_SalesReport_'+ 
           Std.Date.Today() + '_' + 
           Std.Date.CurrentTime(); 
OUTPUT(Report,,outfile)
    : WHEN(EVENT($.Mod_Events.Final,'*'));
    
    
