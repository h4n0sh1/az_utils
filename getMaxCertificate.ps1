<#
    Az - App Reg : Check max number of certificate per app. reg  
#>
param(
    [string]$appRegName = "Test-MaxCert"
)  
$i=1
$err=0
Connect-AzureAD
do{
    try {
        Write-Host "Setting Key n°$i"  
        & "$PSScriptRoot\gen_cert.ps1" $appRegName
        $certFile = "$PSScriptRoot\$appRegName.cer"
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate($certFile)
        $keyValue = [System.Convert]::ToBase64String($cert.GetRawCertData())
        $azureADAppReg = Get-AzureADApplication -Filter "DisplayName eq '$appRegName'"
        $key_cred = New-AzureADApplicationKeyCredential -ObjectId $azureADAppReg.ObjectId -Type AsymmetricX509Cert -Usage Verify -Value $keyValue
        Remove-Item -Path "$PSScriptRoot\$appRegName.cer"  
    }
    catch { $err=1 }
    $i+=1
}while(!$err)

