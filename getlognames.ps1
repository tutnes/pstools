[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)][string]$logtype,
  [Parameter(Mandatory=$True)][string]$computername
)
Get-EventLog -LogName $logtype -computername $computername |ForEach-Object {$LogName = $_.Log;Get-EventLog -LogName $LogName -ErrorAction SilentlyContinue |Select-Object @{Name= "Log Name";Expression = {$LogName}}, Source -Unique}
