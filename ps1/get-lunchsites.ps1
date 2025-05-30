$workpath = "\\some\path\here"
copy "\\some\path\here" $workpath
	$xlCSV=6
	$xlsx="$workpath\file.xlsx"
	$csv="$workpath\file.csv"
	$xl=New-Object -com "Excel.Application"
	$wb=$xl.workbooks.open($xlsx)
	$wb.SaveAs($csv,$xlCSV)
	$xl.displayalerts=$False
	$xl.quit()
$sites = Import-Csv "$workpath\cile.csv"
$LunchNonKDSSites = $sites | ?{($_.Lunch -eq 'Yes') -and ($_.KDS -eq 'Full')}
#$DinnerNonKDSSites = $sites | ?{($_.Lunch -eq 'No') -and ($_.KDS -eq 'No')}
Write-Output $LunchNonKDSSites | select "Site #","Time Zone" | Export-Csv $workpath\PrepCategoryChangeLunchSites.csv -NoTypeInformation
#Write-Output $DinnerNonKDSSites | select "Site #","Time Zone" | Export-Csv $workpath\PrepCategoryChangeDinnerSites.csv -NoTypeInformation
del "$workpath\file.xlsx"
del "$workpath\file.csv"