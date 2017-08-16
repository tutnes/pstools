# pstools
Some Powershell tools for Monitors in Dynatrace, and other usage.

# eventlog2.ps1
This script will check for events based on the parameters given below, it will write the last searched position into an xml file, and will continue from there on the next run.

powershell -file \<location of script\> -source \<source\> -eventid \<eventid\> -folder \<folder\> -log \<log\> -seed_depth \<max number of log entries\> -instanceid \<instance id\> -message \<message\>

### Example:
powershell -file "c:\scripts\eventlog2.ps1" -source Outlook -eventid 63 -folder c:\scripts\xmllog -log Application -seed_depth \<max number of log entries\> -instanceid \<instance id\> -message \<message\>

## Mandatory:

-eventid

## Defaults:

-log "Application" (Application, System or something else)

-path "c:\scripts\xmllog"

-seed_depth 200

