#WORKUNIT('name','Job Launch'); 
IMPORT Std;

//job set up
Events  := ['LaunchEven','LaunchOdd']; //Event names
Time    := Std.Date.CurrentTime();
Minute  := Std.Date.Minute(Time);
MyEvent := Events[Minute % 2 + 1];   //even or odd

//do the work when the event triggers
Info  := ['EVEN','ODD'];
Extra := '<EvenOdd>' + Info[Minute % 2 + 1] +'</EvenOdd>';
EventEx := '<Event>' + Extra + '</Event>';
WorkTxt := EVENTEXTRA('EvenOdd') + ' was Triggered at: ' + Std.Date.Today() + '-' + Time; 
OUTPUT(WorkTxt) : WHEN(EVENT(Events[1],'*')); 
OUTPUT(WorkTxt) : WHEN(EVENT(Events[2],'*')); 

//trigger and log the events
LaunchJob := NOTIFY(MyEvent,EventEx);
LogText   := 'NOTIFY() Pushed Event: ' + MyEvent;
LogEvent  := OUTPUT($.LogOut(LogText), NAMED('NotifyRunExtra'),EXTEND);
ORDERED(LaunchJob,LogEvent) : WHEN(CRON($.Every(1).Minutes));

