//************ RUN ON HTHOR! *************
IMPORT Std, $.^ ;
CapIt(STRING s) := ProcessAutomation.Mod_Utils.CapCaret(s);
	 
SoldRpt := PROJECT(ProcessAutomation.GenSalesRecs.Recs,$.Sales.Layout);
dates   := ProcessAutomation.GenSalesRecs.Date;

IP := $.I_JSONSpray.IP;
// LZpath := '~file::' + IP + '::var::lib::' + 'HPCCSystems::mydropzone::';
LZpath := '~file::' + IP + '::mnt::disk1::var::lib::' + 'HPCCSystems::dropzone' +'::ProcessAuto::';
LZfileName(STRING s,n) := s + '_Sales_' + dates[n]  + '.json';

file1(STRING s) := LZpath + LZfileName(s,1);
file2(STRING s) := LZpath + LZfileName(s,2);
file3(STRING s) := LZpath + LZfileName(s,3);

//these OUTPUTs emulate FTPing the data files 
FTPfiles := PARALLEL(
  OUTPUT(SoldRpt[1..100],,CapIt(file1('JSON')),JSON,OVERWRITE),
  OUTPUT(SoldRpt[101..200],,CapIt(file2('JSON')),JSON,OVERWRITE),
  OUTPUT(SoldRpt[201..300],,CapIt(file3('JSON')),JSON,OVERWRITE));

SemRec := {STRING s, STRING n, STRING t};
fname(STRING s) := ProcessAutomation.Mod_Utils.RawFilename(s);
JSONfiles := DATASET([
  {fname(file1('JSON')),'65535','Row/'},
  {fname(file2('JSON')),'65535','Row/'}, 
  {fname(file3('JSON')),'65535','Row/'}],SemRec);

//this OUTPUT emulates FTPing the semaphore file 
FTPsemaphore :=  OUTPUT(JSONfiles,,CapIt(LZpath + 'JSONspray.csv'),CSV,OVERWRITE);

SEQUENTIAL(FTPfiles,FTPsemaphore);
