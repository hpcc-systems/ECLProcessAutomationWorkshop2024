IMPORT $.^;
EXPORT I_XMLSpray := 
     MODULE(ProcessAutomation.I_AutoSprayFiles)                  
  // EXPORT STRING IP     := IF(__CONTAINERIZED__,'localhost','10.0.2.15');
  EXPORT STRING IP     := 'training2.hpcc.risk.regn.net'; //'10.173.248.7'
  EXPORT STRING LZpath := '/mnt/disk1/var/lib/HPCCSystems/dropzone/ProcessAuto/';  //'/var/lib/HPCCSystems/mydropzone/';
  EXPORT STRING FlagFile       := 'XMLspray.csv';
  EXPORT STRING SprayTargetDir := '~RTTEST::IN::';
  EXPORT STRING NewFileEvent := $.Mod_Events.Spray;   
  EXPORT STRING EventToPush  := $.Mod_Events.Process;
  EXPORT UNSIGNED1 SprayType := 3;  
  EXPORT UNSIGNED1 PauseSecs := 5;
END;
