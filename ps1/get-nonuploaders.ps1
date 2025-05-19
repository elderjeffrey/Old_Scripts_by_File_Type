$workpath = "\\some\path\here"
gc c:\franchiseflags.txt | %{IF(!(Test-Path "$workpath\$_")){write-host $_.substring(2,4) "Has Not Uploaded"}else{$_.substring(2,4)|Out-File "$workpath\UploadedFranchise.txt" -Append}}
$afariaflags = (gc $workpath\UploadedFranchise.txt)
write-host $afariaflags.count "Franchise have uploaded";$afariaflags
del $workpath\UploadedFranchise.txt