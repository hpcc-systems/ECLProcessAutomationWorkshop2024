IMPORT Std;
EXPORT LogOut(STRING s) := FUNCTION 
 LogRec := RECORD
  STRING50 Comment;
  UNSIGNED4 Date := Std.Date.Today(); 
  UNSIGNED3 Time := Std.Date.CurrentTime();
 END;
 ds := DATASET([{s}],LogRec);
 LogStr := TRIM(s) + ' ' +
 ds[1].Date + '-' + ds[1].Time; 
 AgtLog := Std.System.Log.dbglog(LogStr); 
 RETURN WHEN(ds,AgtLog);
END;
