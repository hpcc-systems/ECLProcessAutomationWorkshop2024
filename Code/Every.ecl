EXPORT Every(UNSIGNED1 n) := MODULE
  EXPORT DayAt   := '0 ' + n + ' * * *';
  EXPORT Hours   := '0 0-23/' + n + ' * * *';
  EXPORT Minutes := '0-59/' + n + ' * * * *';
END;
