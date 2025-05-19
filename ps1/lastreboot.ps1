$storedata5test = import-csv "\\some\path\here"
$log = "\\some\path\here"
$cred= Get-Credential
$storedata5test |
Select-object "store"| 
foreach-object {$($_.store + "P1")} | 
foreach-object {
    $site = $_
	$wmi = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $site -Credential $cred
	$lastboot = $wmi.ConvertToDateTime($wmi.LastBootUpTime)
	Write-host $site,$lastboot | Out-File $log
	}