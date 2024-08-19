/**
 * Finds the position of an element in a set.
 *
 * @param s           The SET of values to search. This must be a 
 *                    set of simple data types (STRING, INTEGER, REAL, etc.).
 * @param t           The element value to find.
 * 
 * @return            The ordinal position of the first matching 
 *                    element in the set. 
 */
EXPORT PosInSet(s, t) := FUNCTIONMACRO
  {INTEGER Num} XF(INTEGER C) := TRANSFORM
    SELF.Num := IF(s[C] = t,C,SKIP);
  END;
  _ds := DATASET(COUNT(s),XF(COUNTER));
  RETURN _ds[1].Num;												 
ENDMACRO;
