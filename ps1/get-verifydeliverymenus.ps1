$sw = [System.Diagnostics.Stopwatch]::StartNew()
$sites=(1012,1013,1014,1015,1016,1017,1023,1024,2016,2017,2022,3446)
$workpath="\\some\path\here"
$savepath="$workpath\$site\file.xml"
$sites | %{
$sw1 = [System.Diagnostics.Stopwatch]::StartNew()
$site=$_
[xml]$screens=(gc "$workpath\$site\file.xml");
$check1=($screens.screens.UpdateMenus.Menu[30]).orderscreens;
$sw1.stop();$elapsed1 = [string]::concat($sw1.Elapsed.Hours,":",$sw1.Elapsed.Minutes,":",$sw1.Elapsed.Seconds); 
Write-Host $site, $check1 -NoNewline;
Write-Host " Report Time " -NoNewline;
Write-Host -F Red $elapsed1
}
$sw.stop();$elapsed = [string]::concat($sw.Elapsed.Hours,":",$sw.Elapsed.Minutes,":",$sw.Elapsed.Seconds);write-host $sites.count "sites took: " -NoNewline;write-host -F Red $elapsed