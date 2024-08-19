# Workshop Agenda

This Workshop teaches the workunit scheduling and process automation aspects of the ECL programming language. These are tools that allow you to standardize and optimize when/how a given set of tasks can be most efficiently accomplished within your production environment.

We will start by introducing the job scheduling syntax in ECL which teaches you how to launch a workunit at a specific time or repetitively, based on time periods (such as, every hour, or every five minutes, or …).
 
We will also introduce the event-driven ECL syntax that allows you to launch workunits when a specific event occurs. It then applies these techniques to an extended real-world set of tools that automatically sprays files that appear on your Landing Zone and processes them to automatically add them to your existing production data. 

# Introduction

Automating standard processes that can run without anyone’s direct oversight is all about knowing “when” to launch the process. In ECL, that is handled by the WHEN() workflow service. 

The WHEN() workflow service is appended to any ECL Action (it must be an action, not a definition) that should delay its execution until the “appropriate time” that is either a specific time/day (using the CRON() function as its parameter), or whenever some specific named event occurs (using the EVENT() function as its parameter).

This workshop will show how to automate processes and schedule jobs in three stages:
 
1. CRON() Jobs - How to launch jobs that need to run periodically.
 
2. Triggering Events - How to launch jobs that need to run when something specific happens.
 
3. An Extensive Real-World Example - Production-ready code that uses these tools to monitor your Landing Zone for a specific file to show up, then automatically import and process new data files.

# Follow Along!

Simply download or clone this repo then add the root folder to your ECL Folders list on the Preferences page of your ECL IDE, or simply open it in your VSCode IDE.

