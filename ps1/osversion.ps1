$POS_RUN_LIST = import-csv StoreData5.IP
$path = "\\some\path\here"
$cred = Get-Credential
import-csv $path\lists\StoreData5.csv |
Select-object "store"| 
foreach-object {$($_.store + "p1")} | 
foreach-object {
    if (Test-Connection $_ -count 1) {
    
    }
    else {
        Write-Output "$COMPTER failed to connect" (Get-Date) |
        Out-File $path\noconnect.txt -append
        }
}