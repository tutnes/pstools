param (
     [string]$pwfile,
     [string]$computername,
     [string]$username,
     [string]$counter,
     [int]$lessthan,
     [int]$morethan
     
)

#Decryption of password
$password = get-content $pwfile | ConvertTo-SecureString
$credentials = New-Object System.Net.NetworkCredential("TestUsername", $password, "TestDomain")

#Attaching to the computer via NetBios
net use \\$computername /user:$username $credentials.password
#If using displayname execute using displayname
$value = Get-Counter -ComputerName $computername -Counter $counter
if ($lessthan) {
    if ($value.CounterSamples.CookedValue -lt $lessthan) {
      Write-Host $counter is $value.CounterSamples.CookedValue and therefore less than $lessthan
    }
    else {
      Write-Host $counter is $value.CounterSamples.CookedValue and therefore more than $lessthan  
    }
}
if ($morethan) {
    if ($value.CounterSamples.CookedValue -gt $morethan) {
      Write-Host $counter is $value.CounterSamples.CookedValue and therefore more than $morethan
    }
    else {
      Write-Host $counter is $value.CounterSamples.CookedValue and therefore less than $morethan
    }
}
#