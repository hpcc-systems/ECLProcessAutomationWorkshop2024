#WORKUNIT('name','Job Notify'); IMPORT Std;
//job set up
Events  := ['LaunchEven','LaunchOdd']; //Event names
Time    := Std.Date.CurrentTime();
Minute  := Std.Date.Minute(Time);
MyEvent := Events[Minute % 2 + 1];   //even or odd
WorkTxt := ' was Triggered on ' + Std.Date.Today() + ' at ' + Time;
//do the work when the event triggers
OUTPUT('EVEN ' + WorkTxt) : WHEN(EVENT(Events[1],'*'));
OUTPUT('ODD ' + WorkTxt) : WHEN(EVENT(Events[2],'*'));
//trigger and log the events 
LaunchJob := NOTIFY(MyEvent,'*'); 
LogText   := 'NOTIFY() Pushed Event: ' + MyEvent; 
LogEvent := OUTPUT($.LogOut(LogText), NAMED('NotifyRun'),EXTEND);
ORDERED(LaunchJob,LogEvent) : WHEN(CRON($.Every(1).Minutes));

