$path = "\\some\path\here"
$log = "\\some\path\here"
$log2 = "\\some\path\here"
$script = "\\some\path\here"
$storedata5test = import-csv $path\StoreData5test.csv
$storedata5test |
Select-object "store"| 
foreach-object {$($_.store + "P1")} | 
foreach-object {
    $site = $_
    $site
	if (Test-Connection $site -count 1) {
		cd\
		cd working
		del gifttran.mdb
		net use \\$site\c$ username /user:password
		$targetpath="\\some\path\here"
		Copy "\\some\path\here" "$path" -Force -PassThru
		Start-Process "cmd.exe"  "/c '\\some\path\here' -Wait
		$b=Test-Path '\\some\path\here'
		if ($b -eq $true)
		{
		Write-output "$_.store does not match" | Out-File $log -Append
		del file.txt
		net use \\$site\c$ /d
		}
		} else {
	    Write-Output "$site failed to connect" (Get-Date).ToShortDateString()","(get-date).ToShortTimeString()" |
	    Out-File $path\noconnect.txt -append
		}
	}