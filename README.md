# pstools
Some Powershell tools for Monitors in Dynatrace, and other usage.

# eventlog2.ps1
powershell -file \<location of script\> -source \<source\> -eventid \<eventid\> -folder \<folder\> -log \<log\> -seed_depth \<max number of log entries\> -instanceid \<instance id\> -message \<message\>

## Mandatory:

-eventid

## Defaults:

-log "Application" (Application, System or something else)

-path "c:\scripts\xmllog"

-seed_depth 200

