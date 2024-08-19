IMPORT $.^, Std;

filename := EVENTEXTRA('FileName');

SFname := $.Sales.SFname; 
isSF   := Std.File.SuperFileExists(SFname);
NewSF  := IF(~isSF,
             Std.File.CreateSuperFile(SFname));
AddSF  := Std.File.AddSuperFile(SFname,filename);

AddFile := NOTHOR(SEQUENTIAL(NewSF,AddSF)); 

LogText := 'New Subfile Count: ' + 
    NOTHOR(Std.File.GetSuperFileSubCount(SFname));
LogEvent := OUTPUT(ProcessAutomation.LogOut(LogText),
                   NAMED('NotifyRun'),EXTEND); 

SEQUENTIAL(AddFile,LogEvent)
    : WHEN(EVENT($.Mod_Events.Process,'*'));
