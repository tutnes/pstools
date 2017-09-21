param (
     [string]$pwfile,
     [string]$computername,
     [string[]]$displayname,
     [string]$username,
     [string[]]$name
)

#Decryption of password
#$password = get-content $pwfile | ConvertTo-SecureString
#$credentials = New-Object System.Net.NetworkCredential("TestUsername", $password, "TestDomain")

#Attaching to the computer via NetBios
#net use \\$computername /user:$username $credentials.password
#If using displayname execute using displayname
if ($displayname) {
 get-service -computername $computername -displayname $displayname
}
#otherwise execute using servicename
else {
 get-service -computername $computername -name $name
}