$ips = (Get-Content "ips.Csv") -split ','

$json =  Get-Content '.\deploy.json' | Out-String | ConvertFrom-Json

$ips | %{
    $ipblock = [PSCustomObject]@{"ipMask" = $($_.replace('"','')); "action" = "Allow"}
    $json.resources[2].properties.ipRules += $ipblock
}



$json | ConvertTo-Json  -Depth 5 | Out-File '.\new-deploy.json'