IMPORT $;
//Run this after the auto-spray and process is complete
OUTPUT(COUNT($.Sales.File),NAMED('RecordCount'));
OUTPUT(SUM($.Sales.File.Sales,TotalAmt),NAMED('TotalSales'));

StoreTbl1 := TABLE($.Sales.File,{StoreID,TotalSales := SUM(GROUP,SUM(Sales,TotalAmt))},StoreID);
StoreTbl2 := TABLE($.Sales.File,{StoreID,TransDate,TotalSales := SUM(GROUP,SUM(Sales,TotalAmt))},StoreID,TransDate);
OUTPUT(SORT(StoreTbl1,StoreID),NAMED('TotalSalesPerStore'),ALL);
OUTPUT(SORT(StoreTbl2,StoreID,TransDate),NAMED('TotalSalesPerStoreByDate'),ALL);
