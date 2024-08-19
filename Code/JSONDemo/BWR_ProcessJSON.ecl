IMPORT $.^,Std,$.^.^.Scheduling;

//Prep work
filename := EVENTEXTRA('FileName');

//This process just adds the new file to a SuperFile
SFname := $.Sales.SFname; //'~RTTEST::IN::SF_JSONfiles';
isSF   := Std.File.SuperFileExists(SFname);
NewSF  := Std.File.CreateSuperFile(SFname);
AddSF  := Std.File.AddSuperFile(SFname,filename);

AddFile := NOTHOR(IF(isSF,AddSF,SEQUENTIAL(NewSF,AddSF))); 

//log the events 
LogText  := 'New Subfile Count: ' + 
            NOTHOR(Std.File.GetSuperFileSubCount(SFname));
LogEvent := OUTPUT(Scheduling.LogOut(LogText),
                   NAMED('NotifyRun'),EXTEND); 

SEQUENTIAL(AddFile,LogEvent)
    : WHEN(EVENT($.Mod_Events.Process,'*'));
