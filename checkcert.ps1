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

