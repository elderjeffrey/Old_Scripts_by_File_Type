$cred=  Get-Credential
$path = "\\some\path\here"
import-csv $path\storedata5test.ip |
Select-object "store" |
foreach-object {$($_.store + "P1")} | 
foreach-object {
    $site = $_
	$session = New-PSSession -ComputerName $site -credential $cred
	Enter-PSSession -Session $session
	$folder = Get-ChildItem c:\ctdbf
	$total = $folders.count
	$oldest = Get-ChildItem c:\ctdbf | select name -First 1
	$size = (Get-ChildItem c:\ctdbf -recurse | Measure-Object -property length -sum)
	$truesize = "{0:N2}" -f ($size.sum / 1GB) + "GB"     
	echo "$site,$total,$truesize,$oldest" | out-file $path\test.txt -append
	Exit-PSSession
}
