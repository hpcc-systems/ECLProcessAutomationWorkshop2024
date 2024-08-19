EXPORT Mod_Events := MODULE,VIRTUAL
 EXPORT STRING Who     := 'x';
 EXPORT STRING Spray   := Who + '_Spray'; 
 EXPORT STRING Process := Who + '_Process'; 
 EXPORT STRING Launch  := Who + '_Launch'; 
 EXPORT STRING Final   := Who + '_Final';
END;
