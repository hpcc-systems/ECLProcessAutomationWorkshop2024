EXPORT Sales := MODULE
  EXPORT SFname := '~RTTEST::IN::SF_JSONfiles';
	
  EXPORT SKUrec := RECORD
    STRING5     SKU;        //item sold
    UNSIGNED2   NumSold;    //number sold
    UDECIMAL8   TotalAmt;   //total revenue
  END;
  EXPORT Layout := RECORD
    UNSIGNED2   StoreID;   
    UNSIGNED4   TransDate; 
    DATASET(SKUrec) Sales{XPATH('sales/')};  
  END;
  EXPORT File := DATASET(SFname,Layout,
                         JSON('Row/'));
END;