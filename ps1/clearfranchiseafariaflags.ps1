$workpath = "\\some\path\here"
gc c:\franchiseflags.txt |%{IF(Test-Path "$workpath\$_"){$_.substring(2,4)|Out-File "$workpath\AfariaFlagDelete.txt" -Append;del "$workpath\$_" -ErrorAction SilentlyContinue}else{write-host $_.substring(2,4) "Has Not Uploaded"}}
$afariaflags = (gc $workpath\AfariaFlagDelete.txt).count
Write-Host $afariaflags "Afaria Flags Deleted"
del $workpath\AfariaFlagDelete.txt