param (
     [string]$password,
     [string]$output
)
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$secureStringText = $secureStringPwd | ConvertFrom-SecureString
Set-Content $output $secureStringText
