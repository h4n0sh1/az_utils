<#  Split input csv into desired chunk sizes with a forking method
    Author: EHO - Deepdef © 2023
    License : MIT
    Created : 12/15/2023
#>


[CmdletBinding()]
param(
     [Parameter(Mandatory=$True)]
     [String]$PATH
)

$rfolder = Split-Path -Path $PATH -parent
(Split-Path $PATH -Leaf) -match "(.*)\.csv"
$basename = $Matches[1]
$out_basepath = $rfolder + "\$basename.csv"
$out_basepath  -match "(.*)(\.csv)"
$step = 1000 
$n = 0
$m = 0

$csv = Import-Csv $Path
$size = (Get-Item $Path).length/1MB

for($i=0;$i -lt ([int]($size/15)+1);$i++){
    $outpath = $Matches[1] + "-$i" + $Matches[2]
    do{
        $m = $m+$step
        while($m -ge $csv.Length){
            $m--
        }    
        $rows =$csv[$n..$m]
        $rows | Export-Csv -NoTypeInformation -Encoding UTF8 -Append $outpath
        $n=$m+1
        if(($n -ge $csv.Length) -or ($m -ge $csv.Length)){
            Write-Host "End of file reached"
            break outer
        }
    }while((Get-Item $outpath).length/1MB -lt 15)
}
