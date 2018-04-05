# inspiration from https://community.ipswitch.com/s/question/0D53600000fsgvrCAA/ssl-certificate-expiration-active-monitor-script
param (
    [string]$url,
    [int]$timeoutMilliseconds = 30000

)


 [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

 $req = [Net.HttpWebRequest]::Create($url)

 $req.Timeout = $timeoutMilliseconds

 $req.GetResponse()

 [datetime]$expiration = $req.ServicePoint.Certificate.GetExpirationDateString()

 [int]$certExpiresIn = ($expiration - $(get-date)).Days

$certExpiresIn

