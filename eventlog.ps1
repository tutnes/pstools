#*********************************************************************************************************************
# PROGRAM NAME     : EventLog
# VERSION          : 1.0.0
# DESCRIPTION      : Program read Newest 1 
#
#                    Program read the newest event and only 1 event.
#                    
#                    eventlog can be Application or System or Security ......
#                    EventID and Source and EntryType can be Critical, Error, Warning or Information
#                    
#                    RE-negative is regular expression text search. If not needed ->    n/a
#                    RE-positive is regular expression text search. If not needed ->    n/a 
#
#
# ARGUMENTS :server interval evenlog level source eventid RE-negative RE-postive
# CALLED BY        :
#---------------------------------------------------------------------------------------------------------------------
# CHANGE STATISTIC :
#
# Jan Inge L�nes      /16.03.2017/v01.00/EVRY/ Created
#
#*********************************************************************************************************************

# Program need minimum EventID or Level or Provider or eventData. 

$server      = $ARGS[0]
$interval    = $ARGS[1]         # Interval is interval monitor or scheduled to run.
$eventLog    = $ARGS[2]         # Application or System or Security 
$Level       = $ARGS[3]         # Critical, ERROR, Warning or Information
$Source      = $ARGS[4]         # Source 
$EventID     = $ARGS[5]         # EventID
$REnegative  = $ARGS[6]         # Regular expression negative to search for text in Message or use null (blank)
$REpositive  = $ARGS[7]         # Regular expression positive to search for text in Message or use null (blank)


  

  #-----------------------------------------------------------------------------
  # First step verify EventID, Source, EntryType 
  # Next  step verify RE-negative
  # Next  step verify RE-postive
  # Next  step Alert 
  #-----------------------------------------------------------------------------
  $alert = 0

  $ln = Get-EventLog -ComputerName $server -LogName $EventLog -Newest 1 -Source $source -EntryType $Level  -After  (Get-Date).AddMinutes(-$interval) | Where-Object {$_.EventID -eq $EventID}    
  
  if ($REnegative -ne $null -and $ln.Message -match $REnegative) {$alert = 1}

  if ($REpositive -ne $null -and $ln.Message -match $REpositive) {$alert = 0}
  
  write-host "JAN $alert"
  
  return $alert

  

  
  

From: Tarjei Utnes 
Sent: onsdag 7. juni 2017 12.17
To: Jan Inge L�nes <jan.inge.lones@evry.com>; Morten A. Steien <morten.steien@evry.com>; Ole Morten Johnsen <Ole.Johnsen@evry.com>
Cc: Michael Breen <Michael.Breen@evry.com>; Torsten Granli <Torsten.Granli@evry.com>; Roar Johnsen <Roar.Johnsen@evry.com>
Subject: Log monitorering

Dette scriptet her, kan monitorere eventlogger fra sentralisert plass.
Og holder ogs� oversikt over hvor i fila den sist leste

Den kan ogs� sende mail.
Vil tro det skal v�re ganske lett og modifisere dette til � kunne brukes for oss.

https://gallery.technet.microsoft.com/scriptcenter/ed188912-1a20-4be9-ae4f-8ac46cf2aae4




Kind regards
Tarjei Utnes   
Service Analytics 
Tarjei.utnes@evry.com
M +47 971 55 265

