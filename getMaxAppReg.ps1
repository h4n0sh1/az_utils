<#
    Az - App Reg : Check max number of secrets per app. reg  
#>
param(
    [string]$appRegName = "app_reg_name"
)  
$i=1
$err=0
Connect-AzAccount
$azureADAppReg = Get-AzureADApplication -Filter "DisplayName eq '$appRegName'"
do{
    $new_secret = New-AzureADApplicationPasswordCredential -ObjectId $azureADAppReg.ObjectId -EndDate ((Get-Date).AddYears(10))
    $secret_list = $azureADAppReg.PasswordCredentials
    $secret_list.Add($new_secret)
    try {
        Set-AzureADApplication -ObjectID $azureADAppReg.ObjectId -PasswordCredentials $secret_list
        Write-Host "Secret n°$i"  
    }
    catch { $err=1 }
    $i+=1
}while(!$err)