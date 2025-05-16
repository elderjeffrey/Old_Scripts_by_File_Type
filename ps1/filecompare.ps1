$log1="some\path\here\filesmatch.txt"
$log2="some\path\here\filesdontmatch.txt"
$path="some\path\here"
$mypath="some\path\here"
$Filelist=Get-Content $path\filelist.txt
$correctfiles=foreach ($file in $Filelist) {dir $mypath\$file | Select-Object $file.lastwritetime | select name, lastwritetime}
import-csv $path\StoreData5test.csv |
Select-object "store"| 
foreach-object {$($_.store + "p1")} | 
foreach-object {
    if (Test-Connection $_ -count 1) {
    $site = $_
	net use q: \\$site\some\path\here password /user:username
	$targetpath="q:\some\path\here"
	$storefiles=foreach ($file in $Filelist) {dir $targetpath\$file | Select-Object $file.lastwritetime | select name, lastwritetime}

	
	net use q: /d
	}
	}