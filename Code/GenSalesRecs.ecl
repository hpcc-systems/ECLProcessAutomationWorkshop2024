IMPORT Std, $;

CapIt(STRING s) := $.Mod_Utils.CapCaret(s);

SKUrec := RECORD
  STRING5     SKU;        //item sold
  UNSIGNED2   NumSold;    //number sold
  UDECIMAL8   TotalAmt;   //total revenue
END;

rec := RECORD
  UNSIGNED2   StoreID;   
  UNSIGNED4   TransDate; 
  DATASET(SKUrec) Sales;  
END;

Ltrs   := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
Idx    := RANDOM() % 26 + 1;

GenSKU := Ltrs[Idx]+INTFORMAT(RANDOM()%1000,4,1);

SKUcnt := 500;  //number of items for "sale"
Stores := 100;
Days   := 3;
RecCnt := Stores * Days;  

SKUs := FUNCTION
  ds := DATASET(SKUcnt + 100,
                TRANSFORM({STRING5 SKU,UNSIGNED1 Price},
                          SELF.SKU   := GenSKU, 
                          SELF.Price := RANDOM() % 5 + 1));
  dds:= DEDUP(SORT(ds	,SKU),SKU)[..SKUcnt];
  RETURN dds;
END	   : INDEPENDENT;  //do this once, only

SKU_DCT := DICTIONARY(SKUs,{SKU => price});
SKUprice(STRING8 s) := SKU_DCT[s].price;

Sales := 
    DATASET(RecCnt * SKUcnt,
            TRANSFORM({UNSIGNED4 ID,UNSIGNED4 C}, 
                      SELF.ID := COUNTER,
                      SELF.C  := RANDOM() % SKUcnt))
            : INDEPENDENT; //do this once, only

SalesDCT := DICTIONARY(Sales,{ID => C});
SalesCnt(UNSIGNED4 i) := SalesDCT[i].C;			

SET OF UNSIGNED4 dates := FUNCTION
  GD      := Std.Date.Today();
  JD      := Std.Date.FromGregorianDate(GD);
  C2GD(C) := Std.Date.ToGregorianDate(JD-C);
  ds      := DATASET(Days-1,
                TRANSFORM({UNSIGNED4 d},
                          SELF.d :=C2GD(COUNTER)));
  RETURN SET(SORT(ds,d),d) + [GD];
END;

GenRecs := 
    DATASET(RecCnt,
            TRANSFORM(rec,
                      SELF.StoreID   := COUNTER % Stores + 1,
                      SELF.TransDate := dates[COUNTER % Days + 1],
                      SELF.Sales     := []));

GenSKUs(UNSIGNED2 ID, UNSIGNED1 dt) := 
    PROJECT(SKUs,
            TRANSFORM(SKUrec,
                      Start := FUNCTION //local function in TRANSFORM
                        Cnt    := COUNT(Dates)*SKUcnt;
                        Plus   := (dt*SKUcnt)-SKUcnt;
                        Prelim := (ID-1) * Cnt;
                        RETURN Prelim + Plus;
                      END;
                      SELF.SKU      := LEFT.SKU;
                      C             := SalesCnt(start+COUNTER);
                      SELF.NumSold  := C;
                      SELF.TotalAmt := SKUprice(LEFT.SKU)*C));
                         
SoldRpt := 
    PROJECT(SORT(GenRecs,TransDate,StoreID),
            TRANSFORM(rec,
                      dt         := $.PosInSet(dates,LEFT.TransDate);	
                      SELF.Sales := GenSKUs(LEFT.StoreID,dt);
                      SELF       := LEFT));

EXPORT GenSalesRecs := MODULE
  EXPORT Recs := SoldRpt;
  EXPORT Date := Dates; 
END;


