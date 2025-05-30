$path = "some\path\here"

import-csv $path\StoreData5FLM.IP |
Select-object "store"| 
foreach-object {$($_.store + "P1")} | 
foreach-object {
    $site = $_
    $site
    if (Test-Connection $site -count 1) {
    New-PSDrive -Name Q -PSProvider filesystem -Root \\$site\"c$"
	start-process "cmd.exe"  "/c $path\fixmyinventory.bat"
    Remove-psdrive –name Q
    }
    else {
        Write-Output "$site failed to connect" (Get-Date) |
        Out-File $path\noconnect.txt -append
        }
}