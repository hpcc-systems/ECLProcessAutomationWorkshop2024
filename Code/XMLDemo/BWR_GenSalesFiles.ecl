IMPORT Std, $.^;

CapIt(STRING s) := Code.Mod_Utils.CapCaret(s);
SoldRpt := PROJECT(Code.GenSalesRecs.Recs,$.Sales.Layout);
dates   := Code.GenSalesRecs.Date;

IP := $.I_XMLSpray.IP;
LZpath := '~file::' + IP + '::var::lib::' + 'HPCCSystems::mydropzone' +'::processauto::';
//LZpath := '~file::' + IP + '::mnt::disk1::var::lib::' + 'HPCCSystems::dropzone' +'::ProcessAuto::';

LZfileName(STRING s,n) := s + '_Sales_' + dates[n] + '.xml';
file1(STRING s) := LZpath + LZfileName(s,1);
file2(STRING s) := LZpath + LZfileName(s,2);
file3(STRING s) := LZpath + LZfileName(s,3);
//Test to verify that path and files are correctly formed
// OUTPUT(LZPath,NAMED('LZPath'));
// OUTPUT(CapIt(file1('XML')));

FTPfiles := PARALLEL(
  OUTPUT(SoldRpt[  1..100],,CapIt(file1('XML')),XML,OVERWRITE),
  OUTPUT(SoldRpt[101..200],,CapIt(file2('XML')),XML,OVERWRITE),
  OUTPUT(SoldRpt[201..300],,CapIt(file3('XML')),XML,OVERWRITE));

SemRec := {STRING s, STRING n, STRING t};
fname(STRING s) := Code.Mod_Utils.RawFilename(s);
XMLfiles := DATASET([
  {fname(file1('XML')),'65535','Row'},
  {fname(file2('XML')),'65535','Row'}, 
  {fname(file3('XML')),'65535','Row'}],SemRec);

FTPsemaphore := OUTPUT(XMLfiles,,CapIt(LZpath + 'XMLspray.csv'),CSV,OVERWRITE);
// FTPsemaphore; //Generate semaphore for testing only
SEQUENTIAL(FTPfiles,FTPsemaphore); //OUTPUT XML Files and semiphore to LZ
