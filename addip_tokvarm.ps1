$ips = (Get-Content "ips.Csv") -split ','

$json =  Get-Content '.\kv.json' | Out-String | ConvertFrom-Json


$ips | %{
    $ipblock = [PSCustomObject]@{"value" = $($_.replace('"',''))}
    $json.resources[0].properties.networkAcls.ipRules += $ipblock
}

$json | ConvertTo-Json  -Depth 10 | Out-File '.\new-deploy.json'