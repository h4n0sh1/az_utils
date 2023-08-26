<#
    Windows : Generate cer/pfx certificates 
#>
param(
    [string]$certname = "Test",
    [string]$type = "cer" # |pfx
)
$cert = New-SelfSignedCertificate -Subject "CN=$certname" -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 -KeyAlgorithm RSA -HashAlgorithm SHA256

if($type -eq "cer"){
    Export-Certificate -Cert $cert -FilePath "$PSScriptRoot\$certname.cer" 
}else{
    Export-PfxCertificate -FilePath "$PSScriptRoot\$certname.pfx" -Password ""
}
    
