$menus=(29,30,31,32)
$xmlpath="some\path\here\file.xml"
foreach ($menu in $menus)
{
	try
	{
	[xml]$a=(gc $xmlpath)
	if($($a.Screens.UpdateMenus.menu | ?{$_.menunumber -eq $menu})){
#		$($a.Screens.UpdateMenus.menu | ?{$_.menunumber -eq $menu}).TaxesThatApply='Y,N,N,N'};
#		$a.Save($xmlpath);
		$($a.Screens.UpdateMenus.menu | ?{$_.menunumber -eq $menu}).TaxesThatApply}
	}
	catch
	{
	$_.Exception.Message
	}
}
