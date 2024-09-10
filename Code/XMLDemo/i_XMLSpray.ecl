IMPORT $.^;
EXPORT I_XMLSpray := MODULE(Code.I_AutoSprayFiles)                  
  EXPORT STRING IP     := IF(__CONTAINERIZED__,'localhost','192.168.56.101');
  // EXPORT STRING IP     := 'play.hpccsystems.com';
  EXPORT STRING LZpath := '/var/lib/HPCCSystems/mydropzone/';
  EXPORT STRING FlagFile       := 'XMLspray.csv';
  EXPORT STRING SprayTargetDir := '~WRKTEST::IN::';
  EXPORT STRING NewFileEvent := $.Mod_Events.Spray;   
  EXPORT STRING EventToPush  := $.Mod_Events.Process;
  EXPORT UNSIGNED1 SprayType := 3;  
  EXPORT UNSIGNED1 PauseSecs := 5;
END;
