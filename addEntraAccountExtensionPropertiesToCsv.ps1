Connect-AzureAD
$csv = Import-Csv -Path "C:\Users\OthmaneELHANCHI\Downloads\BRP_Entra_Accounts_20250414_1439.csv"
$csv | %{
    $usr = Get-AzureADUser -ObjectId $_.UPN
    $exts = $usr | select -ExpandProperty ExtensionProperty 
    if($exts.ContainsKey("extension_029be2ced66845deb4e5c3f94847c124_employeeTerminationDate")){
       $ext1 = $exts["extension_029be2ced66845deb4e5c3f94847c124_employeeTerminationDate"] #-Format "MM/dd/yyyy HH:mm"
       $gtx = $ext1 -replace "\.0Z","-0000"  # replace Z with timezone offset  
       $ext1=([DateTime]::ParseExact($gtx, "yyyyMMddHHmmssK", $null)).ToUniversalTime()  
       $ext1 = $ext1.ToString("MM/dd/yyyy HH:mm")
    }else{
       $ext1 = ""
    }

    if($exts.ContainsKey("extension_029be2ced66845deb4e5c3f94847c124_employeeRole")){
       $ext2 = $exts["extension_029be2ced66845deb4e5c3f94847c124_employeeRole"] #-Format "MM/dd/yyyy HH:mm"
    }else{
       $ext2 = ""
    }

    if($exts.ContainsKey("extension_029be2ced66845deb4e5c3f94847c124_employeeDepartmentID")){
       $ext3 = $exts["extension_029be2ced66845deb4e5c3f94847c124_employeeDepartmentID"] #-Format "MM/dd/yyyy HH:mm"
    }else{
       $ext3 = ""
    }

    if($exts.ContainsKey("extension_029be2ced66845deb4e5c3f94847c124_employeeGroup")){
       $ext4 = $exts["extension_029be2ced66845deb4e5c3f94847c124_employeeGroup"] #-Format "MM/dd/yyyy HH:mm"
    }else{
       $ext4 = ""
    }

    $_ | Add-Member -MemberType NoteProperty -Name "EmployeeTerminationDate" -Value $ext1
    $_ | Add-Member -MemberType NoteProperty -Name "EmployeeRole" -Value $ext2
    $_ | Add-Member -MemberType NoteProperty -Name "EmployeeDepartmentID" -Value $ext3
    $_ | Add-Member -MemberType NoteProperty -Name "EmployeeGroup" -Value $ext4
    #$usr | fl -Property * | Out-File "C:\Users\OthmaneELHANCHI\Downloads\$($_.DisplayName).txt"
}

$csv | Export-Csv -NoTypeInformation -Path "C:\Users\OthmaneELHANCHI\Downloads\BRP_Entra_Accounts_20250414_1950.csv"
