<###
    Azure List all RBAC permissions of every resource contained in each subscription of the tenant
    License: MIT
    Author: EL HANCHI Othmane - Deepdef 2023 
    Created: 12/21/2023
###>


Connect-AzAccount


$roleMap = @{}

Get-AzSubscription | %{
   $SubscriptionName = $_.Name
   Set-AzContext $_.Name
   Get-AzResource |  Select-Object -Property * | %{
        $ResourceName = $_.ResourceName
        $ResourceType = $_.ResourceType
        $ResourceId = $_.ResourceId 
        Get-AzRoleAssignment -ResourceGroupName $_.ResourceGroupName -ResourceName $_.ResourceName -ResourceType $_.ResourceType | Select-Object -Property * | %{
            $inherited = $true
            if( $_.Scope -match ".*$ResourceName.*"){
                $inherited = $false
            }
            $_ | Add-Member -MemberType NoteProperty -Name "ResourceName" -Value $ResourceName 
            $_ | Add-Member -MemberType NoteProperty -Name "ResourceType" -Value $ResourceType
            $_ | Add-Member -MemberType NoteProperty -Name "ResourceId" -Value $ResourceId
            $_ | Add-Member -MemberType NoteProperty -Name "SubscriptionName" -Value $SubscriptionName
            $_ | Add-Member -MemberType NoteProperty -Name "Inherited" -Value $inherited
            $_ | Export-Csv -Path "$PSScriptRoot\rbac_resources.csv" -NoTypeInformation -Append  
            if(!$roleMap.ContainsKey($_.RoleAssignmentName)){
                $roleMap.Add($_.RoleAssignmentName,"")
            }
        }
        
   }
   Get-AzRoleAssignment | %{
        if(!$roleMap.ContainsKey($_.RoleAssignmentName)){
            $_ | Export-Csv -Path "$PSScriptRoot\rbac_sleeping.csv" -NoTypeInformation -Append  
        }
   }
   
}

