FUNCTION get-obscompcodes {
param($workpath,$xmlpath)

	start-process "cmd.exe" "/c compme.bat" -WorkingDirectory "some\path\here" -Wait -NoNewWindow
	start-process "cmd.exe" "/c WExport exportsettings obmanifest.xml" -WorkingDirectory "some\path\here" -Wait -NoNewWindow
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
		if($CCDescription -eq "AMOUNT`?"){$screen=$_.optiongroup.screennumber[1];
										 $cell=$_.optiongroup.cells.Replace(", "," ").split()[1];
										 $CCscreen=$($Orderscreen|?{($_.screennumber -eq $screen)});
										 $CCcell=$($CCscreen.cell|?{$_.cellnumber -eq $cell});
										 $CCPLU=$($CCcell).inventorynumber;
										 $CCDescription=$($CCcell).cellname;}
		$obsresults= @{
			CompClearingCode = [string]::concat($CCPLU,"_",$screen,"_",$cell)
			Reason = $CCDescription
			CompCode = [string]::concat($_.inventorynumber,"_",$($OrderScreen|?{$_.screennumber -eq 141}).ScreenNumber,"_",$_.cellnumber)
			Description = $_.cellname};
		 New-Object psobject -Property $obsresults}
		}|select Description,CompCode,Reason,CompClearingCode|Export-Csv "$workpath\OBSCompCodes.csv" -NoTypeInformation
}
FUNCTION get-cigcompcodes {
param($workpath,$xmlpath)

	start-process "cmd.exe" "/c cigcompme.bat" -WorkingDirectory "some\path\here" -Wait -NoNewWindow
	start-process "cmd.exe" "/c WExport exportsettings obmanifest.xml" -WorkingDirectory "some\path\here" -Wait -NoNewWindow
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
		$cigresults= @{
			CompClearingCode = [string]::concat($CCPLU,"_",$screen,"_",$cell)
			Reason = $CCDescription
			CompCode = [string]::concat($_.inventorynumber,"_",$($OrderScreen|?{$_.screennumber -eq 141}).ScreenNumber,"_",$_.cellnumber)
			Description = $_.cellname};
		 New-Object psobject -Property $cigresults}
		}|select Description,CompCode,Reason,CompClearingCode|Export-Csv "$workpath\CIGCompCodes.csv" -NoTypeInformation
}

$savefile = [Environment]::GetFolderPath("Desktop");
$workpath = "c:\CompCodes"
$xmlpath = "some\path\here\file.xml"
$date = (get-date).ToString('MMddyy')

get-obscompcodes $workpath $xmlpath;
get-cigcompcodes $workpath $xmlpath;

$files= gci $workpath
$excel = New-Object -comobject Excel.Application
$excel.DisplayAlerts=$false
$excel.Visible=$false
$workbook = $excel.Workbooks.Add()
$i=1
ForEach ($file in $files) {
	If ($i -gt 1){$workbook.worksheets.Add() | Out-Null}
	$worksheet = $workbook.worksheets.Item(1)
	$worksheet.name = $file.Name.TrimEnd(".csv")
	$tempcsv = $excel.Workbooks.Open("$workpath\$file")
	$tempsheet = $tempcsv.Worksheets.Item(1)
	$tempSheet.UsedRange.Copy() | Out-Null
	$worksheet.Paste()
	$tempcsv.close()
	$range = $worksheet.UsedRange
	$range.EntireColumn.Autofit() | out-null
	$i++
}
$workbook.saveas(“$savefile\CCACompCodes$date.xlsx”)
Write-Host -B Black -F Green “File saved to $savefile\CCACompCodes$date.xlsx”
$excel.quit()