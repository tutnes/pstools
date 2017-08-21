[CmdletBinding()]
Param(
  [string]$fullpath,
  [int]$days=0,
  [int]$hours=0,
  [int]$minutes=5
)
$lastWrite = (get-item $fullPath).LastWriteTime
$timespan = new-timespan -days $days -hours $hours -minutes $minutes

if (((get-date) - $lastWrite) -gt $timespan) {
    # older 
    write-host Older
} else {
    # newer
    write-host Younger
}