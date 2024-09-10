EXPORT Sales := MODULE
  EXPORT SFname := '~WRKSHP::IN::SF_XMLfiles';
  EXPORT SKUrec := RECORD
    STRING5     SKU{XPATH('sku')};  
    UNSIGNED2   NumSold{XPATH('numsold')};
    UDECIMAL8   TotalAmt{XPATH('totalamt')}; 
  END;
  EXPORT Layout := RECORD
    UNSIGNED2   StoreID{XPATH('storeid')};   
    UNSIGNED4   TransDate{XPATH('transdate')}; 
    DATASET(SKUrec) Sales{XPATH('/sales')};  
  END;
  EXPORT File := DATASET(SFname,Layout,XML('Dataset/Row'));
END;
