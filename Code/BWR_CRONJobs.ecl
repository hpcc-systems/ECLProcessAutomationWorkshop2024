IMPORT Std;
//every two minutes: 
OUTPUT($.LogOut('2 minute run'),NAMED('TwoMinuteRun'),EXTEND)
: WHEN(CRON($.Every(2).Minutes));


//on the hour, every hour: 
OUTPUT($.LogOut('Hourly run'),NAMED('HourRun'),EXTEND)
: WHEN(CRON($.Every(1).Hours));


//daily at noon (UTC time) 
OUTPUT($.LogOut('Noon run'),NAMED('NoonRun'),EXTEND)
: WHEN(CRON($.Every(12).DayAt));
