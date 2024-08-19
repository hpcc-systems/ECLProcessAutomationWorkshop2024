IMPORT $,Std;
EXPORT Mod_AutoSprayFiles($.I_AutoSprayFiles P) := MODULE

//semaphore file declarations: 
LZfileRec := RECORD
 STRING    fname; 
 UNSIGNED4 size; 
 STRING    tag;
END;

LZfname         := '~file::' + $.Mod_Utils.CapCaret(P.IP) + '::' + $.Mod_Utils.CapCaret(P.FileToRead);
SHARED LZds     := DATASET(LZfname,LZfileRec,CSV); 
SHARED FileCnt  := COUNT(LZds);
SHARED MaxFiles := 4;

//Create the target file name:
SHARED FullFile(STRING fil) := TRIM(P.SprayTargetDir) + fil;

//Log the file sprays:
SHARED SprayMsg(STRING str) := OUTPUT(DATASET([{str}],{STRING line}), NAMED('SprayProgress'),EXTEND);

//clean up after all files sprayed: 
SHARED DeleteSemaphore := Std.File.DeleteExternalFile(P.IP, P.FlagFilePath);

//TimeStamp:
SHARED TimeStamp := Std.Date.Today() + ' ' + Std.Date.CurrentTime();

//Log the events pushed:
SHARED EventMsg(STRING str) := Std.System.Log.addWorkunitInformation(str);

//*** Monitor Function ***************
 EXPORT WaitForFile := Std.File.MonitorFile(P.NewFileEvent, P.IP, P.FlagFilePath, TRUE,-1);

//*** Spray Functions ****************
 EXPORT VarSpray(STRING TheFile,UNSIGNED4 RecSize) := 
        Std.File.SprayDelimited(P.IP,TRIM(P.LZpath)+TheFile, IF(RecSize>0,RecSize,8192),
        P.FieldDelimiter, P.RecDelimiter, P.QuoteDelimiter, P.TargetCluster, 
        FullFile(TheFile),-1,,, P.OverwriteOK, P.Replicate, P.CompressData, P.EscapeChar); 

EXPORT FixSpray(STRING TheFile, UNSIGNED4 RecSize) := 
                Std.File.SprayFixed(P.IP,TRIM(P.LZpath) + TheFile,RecSize, 
                P.TargetCluster, FullFile(TheFile),-1,,, P.OverwriteOK, P.Replicate, P.CompressData);

EXPORT XmlSpray(STRING TheFile, UNSIGNED4 RecSize, STRING rowtag) := 
                Std.File.SprayXML(P.IP,TRIM(P.LZpath) + TheFile,
                IF(RecSize>0,RecSize,8192), rowtag,,P.TargetCluster, FullFile(TheFile),
                -1,,,P.OverwriteOK, P.Replicate, P.CompressData); 

EXPORT JsnSpray(STRING TheFile, UNSIGNED4 RecSize, STRING rowtag) := 
                Std.File.SprayJSON(P.IP,TRIM(P.LZpath) + TheFile, 
                IF(RecSize>0,RecSize,8192),rowtag,, P.TargetCluster, FullFile(TheFile),
                -1,,,P.OverwriteOK, P.Replicate, P.CompressData);

//*** Spray and Process Actions ******
//build EVENTEXTRA info to pass:
FileEx(STRING fil) := '<FileName>' + FullFile(Fil) + '</FileName>';
EventEx(STRING Ex) := '<Event>' + FileEx(Ex) + '</Event>'; 

//actions that process each file:
PushEvent(STRING TheFile) := ORDERED(NOTIFY(P.EventToPush,EventEx(TheFile)), 
                                     EventMsg(TimeStamp + ' Event ' + P.EventToPush + ' pushed for '+ TheFile));


//actions to trigger the post-spray final event:
PushFinalEvent(STRING TheFile) := ORDERED(OUTPUT(LZds,,FullFile(TheFile), CSV,OVERWRITE),NOTIFY(P.EventToLaunch,
                                          EventEx(TheFile)), EventMsg(TimeStamp + ' Event ' + P.EventToLaunch +
                                          ' pushed for ' + TheFile)); 
//actions to spray files in the semaphore file:
Msg1(n) := TimeStamp + ' - Spraying File: ' + LZds[n].fname; 
Msg2(n) := TimeStamp + ' NO SPRAY TYPE SPECIFIED-' + LZds[n].fname;
SprayOne(UNSIGNED1 num) := IF(num <= FileCnt AND TRIM(LZds[num].fname) <> '', 
                              ORDERED(SprayMsg(Msg1(num)),
                                      CASE(P.SprayType,1 =>  VarSpray(LZds[num].fname, LZds[num].size),
                                                       2 =>  FixSpray(LZds[num].fname, LZds[num].size),
                                                       3 =>  XmlSpray(TRIM(LZds[num].fname), LZds[num].size, LZds[num].tag),
                                                       4 =>  JsnSpray(LZds[num].fname, LZds[num].size, LZds[num].tag),
                                                       SprayMsg(Msg2(num))),
                                      IF(P.SprayType IN [1,2,3,4] AND P.EventToPush <> '', 
                                         ORDERED(PushEvent(LZds[num].fname),
                                         $.Mod_Utils.Pause(P.PauseSecs))
                              )));

//spray each file in the semaphore file:
#DECLARE(SprayString);
#DECLARE(Ndx);
#SET(Ndx, 1);
#LOOP
 #IF(%Ndx% = 1)
  #SET(SprayString,'ORDERED(SprayOne(1)');
 #ELSEIF(%Ndx% > MaxFiles)
  #BREAK
 #ELSE
  #APPEND(SprayString,',SprayOne(' + %'Ndx'% + ')');
 #END
#SET(Ndx, %Ndx% + 1)
#END
#APPEND(SprayString,')'); 
SprayAllFiles := %SprayString%;

//spray all files then complete:
SprayThem := ORDERED(SprayAllFiles, 
                     SprayMsg(TimeStamp + ' - After SprayAllFiles'),
                     IF(P.EventToLaunch <> '',PushFinalEvent(P.FlagFile)),
                     SprayMsg(TimeStamp + ' - Deleting Semaphore'),
                     DeleteSemaphore);

//decide to either spray or fail for too many: 
EXPORT SprayFiles :=
IF(FileCnt <= MaxFiles,
   SprayThem,
   ORDERED(EventMsg(TimeStamp +' ' + P.FlagFilePath + ' --' + ' TOO MANY FILES: ' + FileCnt + ' -- MAX FILES: ' + MaxFiles),
           DeleteSemaphore));
END;


 
