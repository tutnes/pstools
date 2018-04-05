param (
    [string]$checkstring,
    [string]$show_content = 0,
    [string]$server,
    [string]$path
)

$postParams = @{User='<username>';Password='<passrowd>';} #Remember upper or lower case on parameters
$startUrl = "http://" + $server + $path


#$authUrl = "http://p-114-271-016.mistral.mistralnett.com:8091/jde/E1Menu.maf"

$headers = @{'User-Agent'='Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; Touch; rv:11.0) like Gecko'}

$loginPage = Invoke-WebRequest -Uri $startUrl -headers $headers -usebasicparsing -sessionvariable jdesession
$data = Invoke-WebRequest -Uri $startUrl -Method POST -headers $headers -usebasicparsing -WebSession $jdsession -ContentType "application/x-www-form-urlencoded" -body $postParams

$data.Content.contains($checkstring)

if ($show_content -eq 1) {
    $data.content
}




