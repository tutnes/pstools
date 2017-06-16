
#
#Logfile parser version 0.1 Tarjei Utnes
#
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)][string]$file, #Logfile is required
  [Parameter(Mandatory=$True)][string]$dateformat, #dateformat for the dateparsing, is required
  [Parameter(Mandatory=$True)][string]$regularexpression, #regular expression for date filtering, is required
  [string]$minutes= "0",
  [string]$hours= "0",
  [string]$firstfilter="ende"
)

#
#$file = "C:\github\pslogparser\logtest.log" 
#$dateformat = "ddd MMM dd HH:mm:ss"
#$regularexpression = '(.+)\s:(.+)'
#$firstfilter = Error, to do a first filtering of the strings
$provider = New-Object System.Globalization.CultureInfo "en-US"

cat $file | select-string -simplematch $firstfilter | select -expand line |
foreach {
              $_ -match $regularexpression | out-null
              if([datetime]::ParseExact($matches[1],$dateformat,$provider) -gt (Get-Date).AddHours($hours).AddMinutes($minutes)) {
                write-host $matches[0]
              }
           }
