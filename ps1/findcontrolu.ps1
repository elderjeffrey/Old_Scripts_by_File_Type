$path="some\path\here"
$log="some\path\here\controlu.txt"
$log2="some\path\here\nocontrolu.txt"
$msg="controlu does not exist"
$637spcwinup = Get-Content $path\bfgteststores.txt
$637spcwinup |
foreach-object {$($_ + "P1")} | 
foreach-object {
    $site = $_
		if (Test-Connection $site -count 1) {
		net use q: \\$site\some\path\here password /user:username
		$targetpath="q:\some\path\here"
		$a=Test-Path $targetpath\controlu.dat
		if ($a -ne $false) {
			$files=gc $targetpath | where {$_ -like "controlu.*"}
			foreach ($f in $files) {
				Write-output $site","$f.fileinfo","$f.LastWriteTime.toshortdatestring | Out-File $log -Append -NoClobber
				} else {
				Write-Output $site","$msg | Out-File $log -Append -NoClobber
				}
			}
		net use q: /del
		} else {
	Write-Output "$site failed to connect"+(Get-Date).ToShortDateString()+(get-date).ToShortTimeString() |
	Out-File $path\noconnect.txt -append
	}
}