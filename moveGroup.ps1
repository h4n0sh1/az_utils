<### 
Azure Move all users from group (and nested groups) into an other
License: MIT
Author : EL HANCHI Othmane - Deepdef 2023
Created : 12/12/2023
####>

[CmdletBinding()]
param(
     [Parameter(Mandatory=$True)]
     [String]$srcGrp,
     [Parameter(Mandatory=$True)]
     [String]$dstGrp
)

$WarningPreference = 'SilentlyContinue'

Connect-AzAccount

function recursiveNestedLook($grp){
    Get-AzADGroup -DisplayName "$grp" | Get-AzADGroupMember | %{ 
        if( $_.OdataType -eq "#microsoft.graph.group"){
            recursiveNestedLook($_.DisplayName) 
        }else{
            # It's a user but check it for good measures ...
            if( $_.OdataType -eq "#microsoft.graph.user"){
                Write-Host "Adding user", $_.DisplayName, "to group $dstGrp ..."
                #Add-AzADGroupMember -TargetGroupDisplayName $dstGrp -MemberObjectId $_.id
            } 
        }
    }
}

recursiveNestedLook $srcGrp 