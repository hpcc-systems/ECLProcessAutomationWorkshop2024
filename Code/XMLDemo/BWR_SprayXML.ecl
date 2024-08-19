IMPORT $.^;
ProcessAutomation.Mod_AutoSprayFiles($.I_XMLSpray).SprayFiles 
    : WHEN(EVENT($.I_XMLSpray.NewFileEvent,'*'));  
ProcessAutomation.Mod_AutoSprayFiles($.I_XMLSpray).WaitForFile;
