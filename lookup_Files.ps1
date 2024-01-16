<###
    Quick search for list of keywords present in filenames accross all sharepoints of a tenant
    License: MIT
    Author: EL HANCHI Othmane - Deepdef 2023 
    Created: 12/21/2023

###>


$AdminSiteURL="get_it_from_env"
Connect-SPOService -url $AdminSiteURL

$check_sites = @()

$files_to_find = @("Get_it_from_env")

Get-SPOSite -Limit All | %{
    $url = $_.url
    Write-Host "Initiating connection to site $url ..." 
    $SiteConnection = Connect-PnPOnline -Url $url  -ClientId "d7c0aa51-ce3d-4538-9d5f-ca7eef928d2d" -Tenant "get_it_from_env" -CertificatePath "$PSScriptRoot\PnPShell.pfx"
    "Collecting items from site $url ..."
    $list_items = Get-PnpListItem -List Documents -PageSize 5000
    $len = ($list_items.FieldValues).Length
    if($len.Length -ne 0){
      "Item Count - Site $url : ", $list_items.FieldValues.Count
       if($len -gt 4900){
        "Item Count nearing max page size for site $url, check it ... $len"
        $check_sites += $url
       }
    }else{
      "Item Count - Site $url :", 0
    }
    foreach($item in $list_items){
        $fref = $item.FieldValues.FileRef
        $files_to_find | % { 
            if($fref.contains($_)){
                "Found following file containing search keyword : $_"
                $fref
            }
        }
    }
}

$check_sites | Out-File "$PSScriptRoot\check_sites"
Disconnect-PnPOnline


