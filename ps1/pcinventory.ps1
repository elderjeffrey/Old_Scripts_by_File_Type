$path = "\\some\path\here"
$cred = Get-Credential
$log = "\\some\path\here.csv"
import-csv $path\StoreData5test.csv |
Select-object "store"| 
foreach-object {$($_.store + "p1")} | 
foreach-object {
    if (Test-Connection $_ -count 1) {
    $site = $_
	$sysItems = Get-WmiObject Win32_ComputerSystem -Namespace "root\CIMV2" -Comp $site -credential $cred
	foreach($sys in $sysItems) {
	Write-Host "Computer Manufacturer: " $sys.Manufacturer
	Write-Host "Computer Model: " $sys.Model
	Write-Host "Total Memory: " $sys.TotalPhysicalMemory "bytes"
	}
	$OSItems = Get-WmiObject Win32_OperatingSystem -Namespace "root\CIMV2"	-Comp $site -credential $cred
	foreach($OS in $OSItems) {
	Write-Host "Operating System: " $OS.Name
	}
	$DISKItems = Get-WmiObject Win32_DiskDrive -Namespace "root\CIMV2" -Comp $site -credential $cred
	foreach($DISK in $DISKItems) {
	Write-Host "Disk:" $DISK.DeviceID
	Write-Host "Size:" $DISK.Size "bytes"
	}
	$NETItems = Get-WmiObject Win32_NetworkAdapterConfiguration -Namespace "root\CIMV2"	-Comp $site -credential $cred | where{$_.IPEnabled -eq "True"}
	foreach($NET in $NETItems) {
	Write-Host "IP Address:" $NET.IPAddress
	Write-Host "Subnet Mask:" $NET.IPSubnet
	Write-Host "Gateway:" $NET.DefaultIPGateway
	Write-Host "MAC Address:" $NET.MACAddress
	write-host "DNS Host Name:" $NET.DNSHostName
	write-host "DNS Search Order:" $NET.DNSServerSearchOrder
	write-host "Primary wins:" $NET.WINSPrimaryServer
	write-host "Secondary wins:" $NET.WINSSecondaryServer
	}
	$hostname = $NET.DNSHostName
	$ip = $NET.IPAddress
	$subnet = $NET.IPSubnet
	$gateway = $NET.MACAddress
	$dns = $NET.DNSServerSearchOrder
	$primary = $NET.WINSPrimaryServer
	$secondary = $NET.WINSSecondaryServer
	$size = $DISK.Size
	$deviceID = $DISK.DeviceID
	$manufacturer = $sys.Manufacturer
	$model = $sys.Model
	$memory = $sys.TotalPhysicalMemory
	$osname = $OS.Name
	$colinfo = @($hostname,$ip,$subnet,$gateway,$dns,$primary,$secondary,$size,$deviceID,$manufacturer,$model,$memory,$osname)
	$colinfo | foreach {
	$props = $_.Properties

	$hostname = @{name="host";expression={$props["host"]}}
	
	
	$cn = @{name="CN";expression={$props["cn"]}}
	$title = @{name="Title";expression={props["title"]}}
	$department = @{name="Department";expression={$props["department"]}}
	$co = @{name="CO";expression={$props["co"]}}
	$props | select $cn,$title,$department,$co
	} | export-csv OCSUsers.csv
	get-variable $hostname,$ip,$subnet,$gateway,$dns,$primary,$secondary,$size,$deviceID,$manufacturer,$model,$memory,$osname | export-csv $log
	} else {
    Write-Output "$site failed to connect" |
    Out-File $path\noconnect2.txt -append
    }
}