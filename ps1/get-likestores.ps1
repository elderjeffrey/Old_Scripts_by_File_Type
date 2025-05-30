$workpath = "\\some\path\here"
$ABSJ = "ABSJ-07"
$hhapps = "HH APP-1"
$hhazdrinks = "4 HH"
$hhdrinkmenu - "4 HH"
$sidesaddons = "SA-01"
$SSD = "SSD-05"
$sps = "SPS - 11"
$se = "SE-54"

	$xlCSV=6
	$xlsx="$workpath\ScreenTierGroups.xlsx"
	$csv="$workpath\ScreenTierGroups.csv"
	$xl=New-Object -com "Excel.Application"
	$wb=$xl.workbooks.open($xlsx)
	$wb.SaveAs($csv,$xlCSV)
	$xl.displayalerts=$False
	$xl.quit()
$sites = Import-Csv "$workpath\ScreenTierGroups.csv"
$LikeScreenSites = $sites | ?{($_.FINDS -eq $4finds) -and ($_.ABSJ -eq $ABSJ)-and ($_.HHAPPS -eq $hhapps) -and ($_.HHAZDRINKS -eq $hhazdrinks) -and ($_.HHDRINKMENU -eq $hhdrinkmenu) -and ($_.sidesaddons = $sidesaddons) -and ($_.SSD = $SSD) -and ($_.SPECIALS -eq $sps) -and ($_.SE = -eq $se)}
#$LikePriceSites = $sites | ?{($_.BEER -eq $pbeer) -and ($_.FOOD -eq $pfood) -and ($_.LIQOUR -eq $pliqour) -and ($_.MISC -eq $pmisc) -and ($_.BEVERAGE -eq $pnabev) -and ($_.WINE -eq $pwine)}


Write-Output $LikePriceSites, $LikeScreenSites | Export-Csv $workpath\LikeSites.csv -NoTypeInformation
del "$workpath\PriceTiers_ScreenTiers.xlsx"
del "$workpath\PriceTiers_ScreenTiers.csv"