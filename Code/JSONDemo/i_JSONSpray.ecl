IMPORT STD, $.^;

//implements a concrete instance of the INTERFACE, only overriding defaults where necessary 
EXPORT I_JSONSpray := MODULE(ProcessAutomation.I_AutoSprayFiles)                  
  // EXPORT STRING IP := IF(__CONTAINERIZED__,'localhost','10.0.2.15'); //localhost only works on local Docker  
  EXPORT STRING IP            := 'training2.hpcc.risk.regn.net'; //Training Cluster
  EXPORT STRING LZpath        := '/mnt/disk1/var/lib/HPCCSystems/dropzone/ProcessAuto/'; //'/var/lib/HPCCSystems/mydropzone/';
  EXPORT STRING FlagFile      := 'JSONspray.csv';
  EXPORT STRING SprayTargetDir := '~RTTEST::IN::';
  EXPORT STRING NewFileEvent  := $.Mod_Events.Spray;    //override the file monitor event
  EXPORT STRING EventToPush   := $.Mod_Events.Process;  //override the event to launch processing
  EXPORT STRING EventToLaunch := $.Mod_Events.Final;							  
  EXPORT UNSIGNED1 SprayType  := 4;                     //1=Delimited, 2=Fixed, 3=XML, 4=JSON
  EXPORT UNSIGNED1 PauseSecs  := 5;
END;
