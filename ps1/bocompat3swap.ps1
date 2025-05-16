$path="some\path\here"
$targetfile="some\path\here"
$bfgstores = Get-Content $path\bfgteststores.txt
$bfgstores |
foreach-object {$($_ + "BH")} | 
foreach-object {
    $site = $_
		if (Test-Connection $site -count 1) {
		net use q: \\$site\some\path\here password /user:username
		$a="rdc navigator"
		$targetpath="some\path\here"
		copy "$targetfile\bocompat3.ocx" "$targetpath\components" -Force -PassThru
		net use q: /del
		} else {
		Write-Output "$site failed to connect"+(Get-Date).ToShortDateString()+(get-date).ToShortTimeString() |
		Out-File $path\noconnect.txt -append
		}
}