IMPORT STD;
EXPORT Mod_Utils := MODULE

EXPORT RawFilename(STRING filename) := FUNCTION
 Splits   := Std.Str.SplitWords(filename,'::');
 SplitCnt := COUNT(Splits);
 RETURN Splits[SplitCnt];
END;

EXPORT CapCaret(STRING filename) := FUNCTION
 SetU  := ['A','B','C','D','E','F','G','H','I','J','K','L','M',
          'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
 chars := LENGTH(filename);
 ds    := DATASET(chars,TRANSFORM({STRING char},
                                   s := filename[COUNTER];
                                   SELF.char := IF(s IN SetU,'^' + s, s)));
 Cfile := ROLLUP(ds,TRUE, TRANSFORM({STRING char},
                                     SELF.char := LEFT.char + RIGHT.char));
 RETURN Cfile[1].char;
END;

EXPORT Pause(secs) := BEGINC++
 sleep(secs);
ENDC++;

END;