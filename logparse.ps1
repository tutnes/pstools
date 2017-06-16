
#
#Logfile parser version 0.1 Tarjei Utnes 2017
#
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)][string]$filepath,    #Logfile is required \\<computername>\c$\<path to file>
  [Parameter(Mandatory=$True)][string]$dateformat, #dateformat for the dateparsing, is required
  [Parameter(Mandatory=$True)][string]$regularexpression, #regular expression for date filtering, is required
  [string]$minutes= "0",  #How far back do you want to check?
  [string]$hours= "0",    #How far back do you want to check?
  [string]$firstfilter="ende"
)

#
#$file = "C:\github\pslogparser\logtest.log" 
#$dateformat = "ddd MMM dd HH:mm:ss"
#$regularexpression = '(.+)\s:(.+)'
#$firstfilter = Error, to do a first filtering of the strings
#
$provider = New-Object System.Globalization.CultureInfo "en-US"

cat $filepath | select-string -simplematch $firstfilter | select -expand line |
#cat $filepath | select-string | select -expand line |
foreach {
              $_ -match $regularexpression | out-null
              if([datetime]::ParseExact($matches[1],$dateformat,$provider) -gt (Get-Date).AddHours($hours).AddMinutes($minutes)) {
                write-host $matches[0]
              }
           }
