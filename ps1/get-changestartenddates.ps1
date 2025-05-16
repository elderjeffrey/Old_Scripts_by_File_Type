$numbers=3532,11512,11514,11515,11517
$path="\\some\path\here"
$sites=gci $path
foreach ($site in $sites){
[xml]$items=[xml](gc $path\$site\items.xml)
foreach ($num in $numbers){$item=$items.ItemMaintenance.MenuItem | where{$_.ItemNumber -eq $num};
if($item.StartDate){$item.StartDate='01/01/1971'}}$items.Save($items);
$($items.ItemMaintenance.MenuItem | where{$_.ItemNumber -eq $num}).StartDate}