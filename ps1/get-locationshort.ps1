$Date=("$((date).month)" + "$((date).day)" + "$((date).year)")
$temp = [Environment]::GetFolderPath("Desktop");
Get-ChildItem -Path $temp -Filter 'file.xml' |
#    Select-Object -First 5 | 
    foreach { 
        $screensxml = [xml]((Get-Content $_.fullname -Raw).Replace("`0",""));

        $props = @{
			'CheckFileOnly' = $screensxml.Screens.NewScreens.OrderScreen.ScreenNumber.Cell.CheckFileOnly;
			'MainItem' = $screensxml.Screens.NewScreens.OrderScreen.ScreenNumber.Cell.MainItem;
			'MustAskSeatNumber' = $screensxml.Screens.NewScreens.OrderScreen.ScreenNumber.Cell.MustAskSeatNumber;
			'PrepSequence' = $screensxml.Screens.NewScreens.OrderScreen.ScreenNumber.Cell.PrepSequence;
			'PrepCategory' = $screensxml.Screens.NewScreens.OrderScreen.ScreenNumber.Cell.PrepCategory;
			'InvetoryNumber' = $screensxml.Screens.NewScreens.OrderScreen.ScreenNumber.Cell.InvetoryNumber;
			'CellName' = $screensxml.Screens.NewScreens.OrderScreen.ScreenNumber.Cell.CellName;
			'CellNumber' = $screensxml.Screens.NewScreens.OrderScreen.ScreenNumber.Cell.CellNumber;
			'ScreenName' = $screensxml.Screens.NewScreens.OrderScreen.Title;
			'ScreenNumber' = $screensxml.Screens.NewScreens.OrderScreen.ScreenNumber;
			
        }

        New-Object psobject -Property $props;
    } | select store,screennumber,screenname,cellnumber,cellname,inventorynumber,prepcategory,prepsequence,mustaskseatnumber,MainItem,CheckFileOnly |
	Export-Csv -Path "$temp\GetLocationByInventoryNumber.csv" -NoTypeInformation