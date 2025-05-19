$xmlpath="\\some\path\here"
$savefile = [Environment]::GetFolderPath("Desktop")
$Date=((gci $xmlpath).LastWriteTime.ToShortDateString()).replace("/","-")
$screensxml=[xml](gc $xmlpath)
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen[65..98]
$Orderscreen |%{$items=$_.cell;$title=$_.title;$screen=$_.screennumber;
			$items|%{if($_.mainitem){
			$props= @{
				Title = $title
				Screen = $screen
				PLU = $_.inventorynumber
				Description = $_.cellname
				CheckFileOnly = $_.checkfileonly
				MainItem = $_.mainitem};
			New-Object psobject -Property $props;
		}}}|select Title,Screen,PLU,Description,MainItem,CheckFileOnly|Export-Csv $savefile\ModifierswithMainItem$Date.csv -NoTypeInformation