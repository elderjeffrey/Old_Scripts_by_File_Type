$sw = [System.Diagnostics.Stopwatch]::StartNew()
$sites=(1,2,3,4)
$workpath="\\some\path\here"
$savepath="$workpath\$site\items.xml"
$sites | %{
$sw1 = [System.Diagnostics.Stopwatch]::StartNew()
$site=$_
[xml]$item=(gc "$workpath\$site\items.xml");
$check1=$item.itemmaintenance.menuitem|?{$_.itemnumber -eq 4776};
$check2=$item.itemmaintenance.menuitem|?{$_.itemnumber -eq 4778};
$sw1.stop();$elapsed1 = [string]::concat($sw1.Elapsed.Hours,":",$sw1.Elapsed.Minutes,":",$sw1.Elapsed.Seconds); 
Write-Host $site, $check1.price1, $check2.Price1 -NoNewline;
Write-Host " Report Time " -NoNewline;
Write-Host -F Red $elapsed1
<#
$check1=$item.itemmaintenance.menuitem|?{$_.itemnumber -eq 4776};
$check2=$item.itemmaintenance.menuitem|?{$_.itemnumber -eq 4778};
Write-Host $site, $check1, $check2;
if($check1.price1 -ne '29'){$check1.price1='29';$check1.price2='29';$check1.price3='29'};
if($check2.price1 -ne '31'){$check2.price1='31';$check2.price2='31';$check2.price3='31'};
$item.save($savepath);$changesmade=$true;
if($changesmade){Write-Host "$site was incorrect and had to be changed (get-date).toshortdatestring()"}
#>
}
$sw.stop();$elapsed = [string]::concat($sw.Elapsed.Hours,":",$sw.Elapsed.Minutes,":",$sw.Elapsed.Seconds);write-host "Total Elapsed Time: " -NoNewline;write-host -F Red $elapsed