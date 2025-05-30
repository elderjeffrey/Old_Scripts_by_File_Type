$mypath = "\\some\path\here"
Get-ChildItem -Path $mypath -Filter 'file.xml' |
#    Select-Object -First 5 | 
    foreach { 
		$CurStore = New-Object -TypeName PSObject -Property @{Store=$Store};
		$savefile = [Environment]::GetFolderPath("Desktop");
		$screensxml = [xml]((Get-Content $_.fullname -Raw).Replace("`0",""));



        $props = @{
				Store = $CurStore.Store
				Title = $screensxml.Screens.NewScreens.OrderScreen.Title
				Screen = $screensxml.Screens.NewScreens.OrderScreen.ScreenNumber
				CellNumber = $screensxml.Screens.NewScreens.OrderScreen.cell.cellnumber
				PLU = $screensxml.Screens.NewScreens.OrderScreen.cell.inventorynumber
				CellName = $screensxml.Screens.NewScreens.OrderScreen.cell.cellname
				PrepCategory = $screensxml.Screens.NewScreens.OrderScreen.cell.prepcategory
				PrepSequence = $screensxml.Screens.NewScreens.OrderScreen.cell.prepsequence
				OptionRouting = $screensxml.Screens.NewScreens.OrderScreen.cell.OptionRouting
				CheckFileOnly = $screensxml.Screens.NewScreens.OrderScreen.cell.checkfileonly
				MainItem = $screensxml.Screens.NewScreens.OrderScreen.cell.mainitem
				MustAskSeatNumber = $screensxml.Screens.NewScreens.OrderScreen.cell.mustaskseatnumber
				ModType = $screensxml.Screens.NewScreens.OrderScreen.cell.optiongroup.type
				ModScreen = $screensxml.Screens.NewScreens.OrderScreen.cell.optiongroup.screennumber
				ModCells = $screensxml.Screens.NewScreens.OrderScreen.cell.optiongroup.cells
				}

        New-Object psobject -Property @($props | select -ExpandProperty values) ;
    } | select store,title,screen,cellnumber,PLU,cellname,prepcategory,prepsequence,modtype,modscreen,modcells,mustaskseatnumber,mainitem,checkfileonly |
	Export-Csv -Path "$savefile\fileXML_$Date.csv" -NoTypeInformation -Append