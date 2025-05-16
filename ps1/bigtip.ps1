$path="some\path\here"
$log="some\path\here\bigtip.log"
$teststores = Get-Content $path\teststores.txt
$teststores |
foreach-object {$($_ + "P1")} | 
foreach-object {
    $site = $_
		if (Test-Connection $site -count 1) {
		net use q: \\$site\"some\path\here" password /user:username
		$targetpath="\\$site\some\path\here"
		#$search=""
		$files=dir $targetpath\"us05*12.tip" | where  {($_.Length /1GB) -gt 1}
		Write-Output $files | Out-File $LOG -Append -NoClobber
		net use q: /del
		} else {
	Write-Output "$site failed to connect"(Get-Date).ToShortDateString()(get-date).ToShortTimeString() |
	Out-File $path\noconnect.txt -append
	}
}