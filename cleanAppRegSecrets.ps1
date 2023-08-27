<#
    Az - App Reg : Clean all secrets from app. registration
#>
param(
    [string]$appRegName = "app_reg_name"
) 


#Connect-AzAccount
$azureADAppReg = Get-AzureADApplication -Filter "DisplayName eq '$appRegName'"
$secret_list = @()

try {
	"Cleaning ..."
	Set-AzureADApplication -ObjectID $azureADAppReg.ObjectId -PasswordCredentials $secret_list 
}
catch { 
	"Error ..."
}
    
