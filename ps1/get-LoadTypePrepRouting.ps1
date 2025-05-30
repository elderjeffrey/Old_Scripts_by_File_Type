Function get-RoutingStandard {
param($workpath,$xmlpath,$prepcat,$Standard)
$screensxml=[xml](gc $xmlpath\$Standard\file.xml)
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
$ButtonItems = $Orderscreen | %{$_.cell}
$ButtonItems | %{
	$gprep = $_.prepcategory
	$gcellname = $_.cellname
	[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
	$props = @{
			PLU = $_.inventorynumber
			CellName = "`"$gcellname`""
			PrepCategory = $subprepcat};
	New-Object psobject -Property $props;
}  | select PLU,cellname,prepcategory | Export-Csv -Path "$workpath\Standard.csv" -NoTypeInformation -Append
}
Function get-RoutingHPK {
param($workpath,$xmlpath,$prepcat,$HPK)
$screensxml=[xml](gc $xmlpath\$HPK\file.xml)
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
$ButtonItems = $Orderscreen | %{$_.cell}
$ButtonItems | %{
	$gprep = $_.prepcategory
	$gcellname = $_.cellname
	[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
	$props = @{
			PLU = $_.inventorynumber
			CellName = "`"$gcellname`""
			PrepCategory = $subprepcat};
	New-Object psobject -Property $props;
}  | select PLU,cellname,prepcategory | Export-Csv -Path "$workpath\HPK.csv" -NoTypeInformation -Append
}
Function get-RoutingFull {
param($workpath,$xmlpath,$prepcat,$Full)
$screensxml=[xml](gc $xmlpath\$Full\file.xml)
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
$ButtonItems = $Orderscreen | %{$_.cell}
$ButtonItems | %{
	$gprep = $_.prepcategory
	$gcellname = $_.cellname
	[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
	$props = @{
			PLU = $_.inventorynumber
			CellName = "`"$gcellname`""
			PrepCategory = $subprepcat};
	New-Object psobject -Property $props;
}  | select PLU,cellname,prepcategory | Export-Csv -Path "$workpath\Full.csv" -NoTypeInformation -Append
}
Function get-RoutingHotExpo {
param($workpath,$xmlpath,$prepcat,$HotExpo)
$screensxml=[xml](gc $xmlpath\$HotExpo\file.xml)
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
$ButtonItems = $Orderscreen | %{$_.cell}
$ButtonItems | %{
	$gprep = $_.prepcategory
	$gcellname = $_.cellname
	[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
	$props = @{
			PLU = $_.inventorynumber
			CellName = "`"$gcellname`""
			PrepCategory = $subprepcat};
	New-Object psobject -Property $props;
}  | select PLU,cellname,prepcategory | Export-Csv -Path "$workpath\HotExpo.csv" -NoTypeInformation -Append
}
Function get-RoutingHotColdToGoExpo {
param($workpath,$xmlpath,$prepcat,$HotColdToGoExpo)
$screensxml=[xml](gc $xmlpath\$HotColdToGoExpo\file.xml)
$Orderscreen=$screensxml.Screens.NewScreens.OrderScreen
$ButtonItems = $Orderscreen | %{$_.cell}
$ButtonItems | %{
	$gprep = $_.prepcategory
	$gcellname = $_.cellname
	[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
	$props = @{
			PLU = $_.inventorynumber
			CellName = "`"$gcellname`""
			PrepCategory = $subprepcat};
	New-Object psobject -Property $props;
}  | select PLU,cellname,prepcategory | Export-Csv -Path "$workpath\HotColdToGoExpo.csv" -NoTypeInformation -Append
}

Function get-LoadTypePrepRouting {
	[CmdletBinding()]
param(
    [Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[ValidateSet("Outback","Bonefish","Carrabbas","Flemings","Roys")]
    [string]$Concept,
	[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[AllowEmptyCollection()]
	[AllowNull()]
	[string[]]$HotExpo,
	[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[AllowEmptyCollection()]
	[AllowNull()]
	[string[]]$Full,
	[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[AllowEmptyCollection()]
	[AllowNull()]
	[string[]]$HotColdToGoExpo,
	[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[AllowEmptyCollection()]
	[AllowNull()]
	[string[]]$HPK,
	[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
	[AllowEmptyCollection()]
	[AllowNull()]
	[string[]]$Standard
	)
begin{}
process{
IF($Concept -eq "Outback"){$prepcatpath = "\\some\path\here\Outback"
	}elseif($Concept -eq "Bonefish"){$prepcatpath = "\\some\path\here\Bonefish"
	}elseif($Concept -eq "Carrabbas"){$prepcatpath = "\\some\path\here\Carrabbas"
	}elseif($Concept -eq "Flemings"){$prepcatpath = "\\some\path\here\Flemings"
	}elseif($Concept -eq "Roys"){$prepcatpath = "\\some\path\here\Roys"
}
$PrepCat= ((gc "$prepcatpath\*PrepCategories.txt") -replace ',', '=') -join "`n" | ConvertFrom-StringData
$savefile = [Environment]::GetFolderPath("Desktop")
$xmlpath = "\\some\path\here$Concept\Exports\"
$date = (get-date).ToString('MMddyy')
$workpath = "c:\LoadTypes"
gci $workpath -file|%{mv -Force $_.fullname "$workpath\Old\$($_.BaseName+$date+$_.Extension)"} -ErrorAction SilentlyContinue

get-RoutingStandard $workpath $xmlpath $prepcat $Standard
get-RoutingHPK $workpath $xmlpath $prepcat $HPK
get-RoutingFull $workpath $xmlpath $prepcat $Full
get-RoutingHotExpo $workpath $xmlpath $prepcat $HotExpo
get-RoutingHotColdToGoExpo $workpath $xmlpath $prepcat $HotColdToGoExpo

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
	$i++
}
$workbook.saveas(“$workpath\$Concept_Prep_Categories_by_Load_Type_$date.xlsx”)
copy "$workpath\$Concept_Prep_Categories_by_Load_Type_$date.xlsx" $savefile
Write-Host -B White -F DarkGreen “File saved to $savefile and $workpath”
$excel.quit()
}
end{}
}
New-Alias gltpr get-LoadTypePrepRouting
Export-ModuleMember -Function get-LoadTypePrepRouting
Export-ModuleMember -Alias gltpr