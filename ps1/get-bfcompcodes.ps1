FUNCTION get-bfcompcodes {
param($workpath,$xmlpath)

	start-process "cmd.exe" "/c bfcompme.bat" -WorkingDirectory "c:\sc" -Wait -NoNewWindow
	start-process "cmd.exe" "/c WExport exportsettings manifest.xml" -WorkingDirectory "some\path\here" -Wait -NoNewWindow
	$screensxml=[xml](gc $xmlpath)
	$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
	$CCAItems=$OrderScreen|?{$_.screennumber -eq 141}|%{$_.cell}
	$CCscreen=$Orderscreen|?{($_.screennumber -eq $screen)}
	$CCcell=$CCscreen.cell|?{$_.cellnumber -eq $cell}
	$CCPLU=$($CCcell).inventorynumber
	$CCAItems|%{if($_.optiongroup){
		$screen=$_.optiongroup.screennumber[0]
		$cell=$_.optiongroup.cells.Replace(", "," ").split()[0]
		$CCscreen=$($Orderscreen|?{($_.screennumber -eq $screen)})
		$CCcell=$($CCscreen.cell|?{$_.cellnumber -eq $cell})
		$CCPLU=$($CCcell).inventorynumber
		$CCDescription=$($CCcell).cellname
		if($CCDescription -eq "AMOUNT`$"){$screen=$_.optiongroup.screennumber[1];
										 $cell=$_.optiongroup.cells.Replace(", "," ").split()[1];
										 $CCscreen=$($Orderscreen|?{($_.screennumber -eq $screen)});
										 $CCcell=$($CCscreen.cell|?{$_.cellnumber -eq $cell});
										 $CCPLU=$($CCcell).inventorynumber;
										 $CCDescription=$($CCcell).cellname;}
		$bfgresults= @{
			CompClearingCode = [string]::concat($CCPLU,"_",$screen,"_",$cell)
			Reason = $CCDescription
			CompCode = [string]::concat($_.inventorynumber,"_",$($OrderScreen|?{$_.screennumber -eq 141}).ScreenNumber,"_",$_.cellnumber)
			Description = $_.cellname};
		 New-Object psobject -Property $bfgresults}
		}|select Description,CompCode,Reason,CompClearingCode|Export-Csv "$workpath\BFGCompCodes.csv" -NoTypeInformation
}
$savefile = [Environment]::GetFolderPath("Desktop");
$workpath = "some\path\here"
$xmlpath = "some\path\here\screens.xml"
$date = (get-date).ToString('MMddyy')
get-bfcompcodes $workpath $xmlpath;