## Powershell Log Monitor Script ## 
## Contributing authors - mck74,mjolinor, 
# Adapted from https://gallery.technet.microsoft.com/scriptcenter/ed188912-1a20-4be9-ae4f-8ac46cf2aae4
## Version 0.9.0 June 29 2017



[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)][string]$computername,    # computername is required
  [string]$source,
  [Parameter(Mandatory=$True)][string]$eventid,
  [string]$folder = "c:\scripts\xmllog",
  [string]$log = "Application",                         #Sets the logtype to Application by default, could be System or other
  [int]$seed_depth = 200,
  [string]$entrytype,                              # Max depth of search
  [string]$instanceid,
  [switch]$logoutput = $false,
  [string]$message
)
# Check for instanceid
$useinstanceid = $false
if ($instanceid) {
    $useinstanceid = $true
}

# Check for source
$usesource = $false
if ($source) {
    $usesource = $true
}
else {
    $source = "EmptySource"
}

# Check for message
$usemessage = $false
if ($message) {
  $usemessage = $true
}

# History is saved in a xml file with latest point in eventlog
$temp_hist_file = $computername + "_" + $log + "_" + $source + "_" + $eventid +  "_" + $message + "_loghist.xml" 

$invalidChars = [IO.Path]::GetInvalidFileNameChars() -join ''
$re = "[{0}]" -f [RegEx]::Escape($invalidChars)
$hist_file = $temp_hist_file -replace $re
$hist_file = $folder + "\" + $hist_file
 
#see if we have a history file to use, if not create an empty $histlog 
if (Test-Path $hist_file){
  Write-Host Found history in $hist_file
  $loghist = Import-Clixml $hist_file
} 
 else {
  Write-Host Found no historyfile
  $loghist = @{}
} 
 
 
function write_alerts { 
    Write-Host $alertbody 
} 
#START OF RUN PASS 
$run_pass = { 
 
    $alertbody = "Log monitor found monitored events. `n" 
    Write-Host "Started processing $($computername)" 
     
    #Get the index number of the last log entry 
    $index = (Get-EventLog -ComputerName $computername -LogName $log -newest 1).index 
     
    #if we have a history entry calculate number of events to retrieve 
    #   if we don't have an event history, use the $seed_depth to do initial seeding 
    if ($loghist[$computername]){
        $n = $index - $loghist[$computername]
    } 
    else {
        $n = $seed_depth
    } 
      
    if ($n -lt 0){ 
        Write-Host "Log index changed since last run. The log may have been cleared. Re-seeding index." 
        $events_found = $true 
        $alertbody += "`n Possible Log Reset $($_)`nEvent Index reset detected by Log Monitor`n" 
        $n = $seed_depth 
    } 
      
    Write-Host "Processing $($n) events." 
     
    #get the log entries 
     
    if ($useinstanceid){ 
        $log_hits = Get-EventLog -ComputerName $computername -LogName $log -Newest $n | 
        ? {($_.source -eq $source) -and ($_.instanceid -eq $instanceid) -and ($_.eventid -eq $eventid)} 
    } 
    
    if ($usesource){
        $log_hits = Get-EventLog -ComputerName $computername -LogName $log -Newest $n | 
        ? {($_.source -eq $source) -and ($_.eventid -eq $eventid)} 
    }
    else {
        $log_hits = Get-EventLog -ComputerName $computername -LogName $log -Newest $n | 
        ? {$_.eventid -eq $eventid}    
    }
    
    
    #Message evaluation
function printMessage {
    if ($usemessage) {
      Write-Host "Evaluating message" $message
      $log_hits | % {
        if ($_.message -like "$message") {
          write-host $_.message
        }
      }
    }
}
    
    
    #save the current index to $loghist for the next pass 
    Write-Host "Index is $($index)`n"
    $loghist[$computername] = $index 
     
    #report number of alert events found and how long it took to do it 
    if ($log_hits){ 
     $events_found = $true 
     $hits = $log_hits.count 
     $alertbody += "`n Alert Events on server $($_)`n" 
     $log_hits |%{ 
      
      $alertbody += $_ | select MachineName,EventID,Message 
        $alertbody += "`n"
     } 
     printMessage # Prints the messages, if there are any and they match the parameter
     }

     else {$hits = 0} 
    $duration = ($timer.elapsed).totalseconds 
    if ($hits -gt 0) {
        write-host "Found $($hits) alert events in $($duration) seconds for eventid $($eventid)" 
        "-"*60 
        " " 
    }
    else {
        write-host "Found no hits for alert with eventid $($eventid)" 
    }
    if ($ShowEvents){$log_hits | fl | Out-String |? {$_}} 

 
#save the history file to disk for next script run  
$loghist | export-clixml $hist_file 
 
    #Write to host if alerts are found 
    if ($events_found -and $logoutput){
        write_alerts
    } 
 
} 
#END OF RUN PASS 
 
Write-Host "Log monitor started at $(get-date)" 
 
#run the first pass 
$start_pass = Get-Date 
&$run_pass 
 

