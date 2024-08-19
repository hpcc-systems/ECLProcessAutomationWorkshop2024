IMPORT STD;
EXPORT I_AutoSprayFiles := INTERFACE

//LZ specs
EXPORT STRING IP             := '';
EXPORT STRING LZpath         := '';

//semaphore file specs
EXPORT STRING FlagFile       := '';
EXPORT STRING FlagFilePath   := TRIM(LZpath) + FlagFile;
EXPORT STRING FileToRead     := IF(FlagFilePath[1]='/', Std.Str.FindReplace(FlagFilePath[2..],'/', '::' ),
                                                        Std.Str.FindReplace(FlagFilePath,'/', '::' )); 
//spray target specs
EXPORT STRING SprayTargetDir := '';
EXPORT STRING TargetCluster  := IF(__CONTAINERIZED__,'data', Std.System.ThorLib.group());

//events
EXPORT STRING NewFileEvent   := '';
EXPORT STRING EventToPush    := ''; 
EXPORT STRING EventToLaunch  := '';

//file type of all files in batch
EXPORT UNSIGNED1 SprayType   := 0;

//CSV file spray options
EXPORT STRING FieldDelimiter := '\\,';
EXPORT STRING RecDelimiter   := '\\n,\\r\\n'; 
EXPORT STRING QuoteDelimiter := '"';
EXPORT STRING EscapeChar     := '\\';

//spray options for all file types 
EXPORT BOOLEAN OverwriteOK   := TRUE; 
EXPORT BOOLEAN Replicate     := TRUE; 
EXPORT BOOLEAN CompressData  := FALSE; 
EXPORT UNSIGNED1 PauseSecs   := 0;
END;                                                        
