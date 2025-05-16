$path="some\path\here"
$log="some\path\here\file.log"
$637spcwinup = Get-Content $path\637spcwinup.txt
$637spcwinup |
foreach-object {$($_ + "P1")} | 
foreach-object {
    $site = $_
		if (Test-Connection $site -count 1) {
		net use q: \\$site\some\path\here password /user:username
		$targetpath="some\path\here"
		$file="noquery.*"
		$a=Test-Path $targetpath\$file
		if ($a -eq $true)
		{
		Write-Host "$site is good"
		} else {
		Write-Output $site | Out-File $LOG -Append -NoClobber
		}
		net use q: /del
		} else {
	Write-Output "$site failed to connect"+(Get-Date).ToShortDateString()+(get-date).ToShortTimeString() |
	Out-File $path\noconnect.txt -append
	}
}