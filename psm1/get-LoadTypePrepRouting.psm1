Function get-RoutingStandard {
param($workpath,$xmlpath,$prepcat,$OptRout,$Standard)
$screensxml= [xml](gc $xmlpath\$Standard\Screens.xml)
$itemsxml= [xml](gc $xmlpath\$Standard\Items.xml)
$items= $itemsxml.ItemMaintenance.MenuItem
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
$ButtonItems = $Orderscreen | %{$_.cell}
$i=0
$ButtonItems | %{
	$i++
	[int]$Pct1=(($i/$ButtonItems.count)*100)
	Write-Progress -activity “Hold Please...” -CurrentOperation "Standard $Standard $Pct1% complete"
	$gprep = $_.prepcategory
	$gcellname = $_.cellname
	$gOptRout = $_.OptionRouting
	[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
	[string]$subOptRout = ($OptRout.GetEnumerator() | ?{$_.value -eq $gOptRout}).Name
	$PLU= $_.inventorynumber
	$PrepMins= ($items|?{$_.ItemNumber -eq $PLU}).PrepMins
	$props = @{
			PLU = $PLU
			CellName = "`"$gcellname`""
			CookTime = $PrepMins
			PrepCat = $subprepcat
			OptRout = $subOptRout
			PrepSeq = $_.prepsequence};
	New-Object psobject -Property $props;
}  | select PLU,cooktime,cellname,prepcat,OptRout,PrepSeq | Export-Csv -Path "$workpath\Standard.csv" -NoTypeInformation -Append
}
Function get-RoutingHPK {
param($workpath,$xmlpath,$prepcat,$OptRout,$HPK)
$screensxml=[xml](gc $xmlpath\$HPK\Screens.xml)
$itemsxml= [xml](gc $xmlpath\$HPK\Items.xml)
$items= $itemsxml.ItemMaintenance.MenuItem
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
$ButtonItems = $Orderscreen | %{$_.cell}
$i=0
$ButtonItems | %{
	$i++
	[int]$Pct1=(($i/$ButtonItems.count)*100)
	Write-Progress -activity “Hold Please...” -CurrentOperation "HPK $HPK $Pct1% complete"
	$gprep = $_.prepcategory
	$gcellname = $_.cellname
	$gOptRout = $_.OptionRouting
	[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
	[string]$subOptRout = ($OptRout.GetEnumerator() | ?{$_.value -eq $gOptRout}).Name
	$PLU= $_.inventorynumber
	$PrepMins= ($items|?{$_.ItemNumber -eq $PLU}).PrepMins
	$props = @{
			PLU = $PLU
			CellName = "`"$gcellname`""
			CookTime = $PrepMins
			PrepCat = $subprepcat
			OptRout = $subOptRout
			PrepSeq = $_.prepsequence};
	New-Object psobject -Property $props;
}  | select PLU,cooktime,cellname,prepcat,OptRout,PrepSeq| Export-Csv -Path "$workpath\HPK.csv" -NoTypeInformation -Append
}
Function get-RoutingFull {
param($workpath,$xmlpath,$prepcat,$OptRout,$Full)
$screensxml=[xml](gc $xmlpath\$Full\Screens.xml)
$itemsxml= [xml](gc $xmlpath\$Full\Items.xml)
$items= $itemsxml.ItemMaintenance.MenuItem
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
$ButtonItems = $Orderscreen | %{$_.cell}
$i=0
$ButtonItems | %{
	$i++
	[int]$Pct1=(($i/$ButtonItems.count)*100)
	Write-Progress -activity “Hold Please...” -CurrentOperation "Full $Full $Pct1% complete"
	$gprep = $_.prepcategory
	$gcellname = $_.cellname
	$gOptRout = $_.OptionRouting
	[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
	[string]$subOptRout = ($OptRout.GetEnumerator() | ?{$_.value -eq $gOptRout}).Name
	$PLU= $_.inventorynumber
	$PrepMins= ($items|?{$_.ItemNumber -eq $PLU}).PrepMins
	$props = @{
			PLU = $PLU
			CellName = "`"$gcellname`""
			CookTime = $PrepMins
			PrepCat = $subprepcat
			OptRout = $subOptRout
			PrepSeq = $_.prepsequence};
	New-Object psobject -Property $props;
}  | select PLU,cooktime,cellname,prepcat,OptRout,PrepSeq | Export-Csv -Path "$workpath\Full.csv" -NoTypeInformation -Append
}
Function get-RoutingHotColdToGoExpo {
param($workpath,$xmlpath,$prepcat,$OptRout,$HotColdToGoExpo)
$screensxml=[xml](gc $xmlpath\$HotColdToGoExpo\Screens.xml)
$itemsxml= [xml](gc $xmlpath\$HotColdToGoExpo\Items.xml)
$items= $itemsxml.ItemMaintenance.MenuItem
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
$ButtonItems = $Orderscreen | %{$_.cell}
$i=0
$ButtonItems | %{
	$i++
	[int]$Pct1=(($i/$ButtonItems.count)*100)
	Write-Progress -activity “Hold Please...” -CurrentOperation "HotColdToGoExpo $HotColdToGoExpo $Pct1% complete"
	$gprep = $_.prepcategory
	$gcellname = $_.cellname
	$gOptRout = $_.OptionRouting
	[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
	[string]$subOptRout = ($OptRout.GetEnumerator() | ?{$_.value -eq $gOptRout}).Name
	$PLU= $_.inventorynumber
	$PrepMins= ($items|?{$_.ItemNumber -eq $PLU}).PrepMins
	$props = @{
			PLU = $PLU
			CellName = "`"$gcellname`""
			CookTime = $PrepMins
			PrepCat = $subprepcat
			OptRout = $subOptRout
			PrepSeq = $_.prepsequence};
	New-Object psobject -Property $props;
}  | select PLU,cooktime,cellname,prepcat,OptRout,PrepSeq | Export-Csv -Path "$workpath\HotColdToGoExpo.csv" -NoTypeInformation -Append
}
<#Function get-RoutingHotExpo {
param($workpath,$xmlpath,$prepcat,$OptRout,$HotExpo)
$screensxml=[xml](gc $xmlpath\$HotExpo\Screens.xml)
#$itemsxml= [xml](gc $xmlpath\$HotExpo\Items.xml)
#$items= $itemsxml.ItemMaintenance.MenuItem
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
$ButtonItems = $Orderscreen | %{$_.cell}
$i=0
$ButtonItems | %{
	$i++
	[int]$Pct1=(($i/$ButtonItems.count)*100)
	Write-Progress -activity “Hold Please...” -CurrentOperation "HotExpo $HotExpo $Pct1% complete"
	$gprep = $_.prepcategory
	$gcellname = $_.cellname
	$gOptRout = $_.OptionRouting
	[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
	[string]$subOptRout = ($OptRout.GetEnumerator() | ?{$_.value -eq $gOptRout}).Name
	$PLU= $_.inventorynumber
	#$PrepMins= ($items|?{$_.ItemNumber -eq $PLU}).PrepMins
	$props = @{
			PLU = $PLU
			CellName = "`"$gcellname`""
			CookTime = $PrepMins
			PrepCat = $subprepcat
			OptRout = $subOptRout
			PrepSeq = $_.prepsequence};
	New-Object psobject -Property $props;
}  | select PLU,cooktime,cellname,prepcat,OptRout,PrepSeq | Export-Csv -Path "$workpath\HotExpo.csv" -NoTypeInformation -Append
}<#cooktime#>
#>
Function get-LoadTypePrepRouting {
	[CmdletBinding()]
param(
    [Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[ValidateSet("Outback","Bonefish","Carrabbas","Flemings","Roys")]
    [string]$Concept,
	[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[AllowEmptyCollection()]
	[AllowNull()]
	[string[]]$Standard,
	<#[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[AllowEmptyCollection()]
	[AllowNull()]
	[string[]]$HotExpo,#>
	[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[AllowEmptyCollection()]
	[AllowNull()]
	[string[]]$HPK,
	[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[AllowEmptyCollection()]
	[AllowNull()]
	[string[]]$Full,
	[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[AllowEmptyCollection()]
	[AllowNull()]
	[string[]]$HotColdToGoExpo
	)
begin{$sw = [System.Diagnostics.Stopwatch]::StartNew()}
process{
IF($Concept -eq "Outback"){$prepcatpath = "\\some\path\here\Outback"
	}elseif($Concept -eq "Bonefish"){$prepcatpath = "\\some\path\here\Bonefish"
	}elseif($Concept -eq "Carrabbas"){$prepcatpath = "\\some\path\here\Carrabbas"
	}elseif($Concept -eq "Flemings"){$prepcatpath = "\\some\path\here\Flemings"
	}elseif($Concept -eq "Roys"){$prepcatpath = "\\some\path\here\Roys"
	}
$PrepCat= ((gc "$prepcatpath\*PrepCategories.txt") -replace ',', '=') -join "`n" | ConvertFrom-StringData
$OptRout= ((gc "$prepcatpath\*OptRouting.txt") -replace ',', '=') -join "`n" | ConvertFrom-StringData
$savefile = [Environment]::GetFolderPath("Desktop")
$xmlpath = "\\some\path\here\$Concept\Exports\"
$date = (get-date).ToString('MMddyy')
$workpath = "\\some\path\here"
gci $workpath -file|%{mv -Force $_.fullname "$workpath\Old\$($_.BaseName+$date+$_.Extension)"} -ErrorAction SilentlyContinue

get-RoutingStandard $workpath $xmlpath $prepcat $OptRout $Standard
get-RoutingHPK $workpath $xmlpath $prepcat $OptRout $HPK
get-RoutingFull $workpath $xmlpath $prepcat $OptRout $Full
get-RoutingHotColdToGoExpo $workpath $xmlpath $prepcat $OptRout $HotColdToGoExpo

#get-RoutingHotExpo $workpath $xmlpath $prepcat $HotExpo

$files= gci $workpath -File
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
	$center = -4108
	$range.Rows.HorizontalAlignment = $center
	$range.Application.ActiveWindow.SplitRow = 1
	$range.Application.ActiveWindow.FreezePanes = $true
	$i++
}

$workbook.saveas(“$workpath\Prep_Categories_by_Load_Type_$Concept.xlsx”)
copy “$workpath\Prep_Categories_by_Load_Type_$Concept.xlsx” $savefile
Write-Host -B White -F DarkGreen “Prep_Categories_by_Load_Type_$Concept.xlsx saved to $savefile and $workpath”
$excel.quit()
}
end{$sw.stop();$elapsed = [string]::concat($sw.Elapsed.Hours,":",$sw.Elapsed.Minutes,":",$sw.Elapsed.Seconds);	write-host -B White -F DarkGreen "Total Elapsed Time: $elapsed"}
}
New-Alias gltpr get-LoadTypePrepRouting
Export-ModuleMember -Function get-LoadTypePrepRouting
Export-ModuleMember -Alias gltpr