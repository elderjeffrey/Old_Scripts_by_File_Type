$path = "some\path\here"
$cred = Get-Credential
$log = "$path\beforewinslog.txt"
$log2 = "$path\afterwinslog.txt"
import-csv $path\StoreData5testall.csv |
Select-object "store"| 
foreach-object {$($_.store + "p1")} | 
foreach-object {
    if (Test-Connection $_ -count 1) {
    $site = $_
	$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -comp $site -credential $cred | where{$_.IPEnabled -eq $true}
	Foreach($NIC in $NICs) {
	$bpri = $NIC.WINSPrimaryServer
	$bsec = $NIC.WINSSecondaryServer
	write-output "$site,$bpri,$bsec" | out-file $log -append
	$NIC.SetWINSServer("10.254.128.99","10.254.2.99")
	}
	$VERIFYNICs = Get-WMIObject Win32_NetworkAdapterConfiguration -comp $site -credential $cred | where{$_.IPEnabled -eq $true}
	foreach ($VERIFY in $VERIFYNICs) {
	$apri = $VERIFY.WINSPrimaryServer
	$asec = $VERIFY.WINSSecondaryServer
	Write-Host "primary for $site : $apri" 
	Write-Host "secondary for $site : $asec" 
	write-output "$site,$apri,$asec" | out-file $log2 -append
	}
	} else {
    Write-Output "$site failed to connect" (Get-Date) |
    Out-File $path\noconnect.txt -append
    }
}