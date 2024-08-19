IMPORT $.^;

ProcessAutomation.Mod_AutoSprayFiles($.I_JSONSpray).SprayFiles : WHEN(EVENT($.I_JSONSpray.NewFileEvent,'*'));  
ProcessAutomation.Mod_AutoSprayFiles($.I_JSONSpray).WaitForFile;  

