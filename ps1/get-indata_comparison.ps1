$targetpath = "\\some\path\here"
$workpath="\\some\path\here"
$numdays=(get-date).day
$year=(Get-Date).year
$month=(Get-Date).month
$prevmonth=(((Get-Date).adddays(-$numdays)).month)
$trndate="$month" + "/*/" + "$year"
$prevtrndate="$prevmonth" + "/*/" + "$year"
$endmonth=(((Get-Date).adddays(-$numdays+1)).addmonths(1)).adddays(-1).toshortdatestring()
$lastmonth=((Get-Date).adddays(-$numdays)).toshortdatestring()

	$a=Test-Path $targetpath\file
	$b=Test-Path $targetpath\file
	
	if ($a -and $b -eq $true)
	{
	copy "\\some\path\here" "$workpath"
	copy "\\some\path\here" "$workpath"

##########################################
#--- convert trndtl.dbf to trndtl.csv ---#
##########################################
	$xlCSV=6
	$xls="\\some\path\here.dbf"
	$csv="\\some\path\here.csv"
	$xl=New-Object -com "Excel.Application"
	$wb=$xl.workbooks.open($xls)
	$wb.SaveAs($csv,$xlCSV)
	$xl.displayalerts=$False
	$xl.quit()
##########################################
#--- convert indata.dbf to weekinv.csv ---#
##########################################
	$xxlCSV=6
	$xxls="\\some\path\here.DBF"
	$ccsv="\\some\path\here.csv"
	$xxl=New-Object -com "Excel.Application"
	$wwb=$xxl.workbooks.open($xxls)
	$wwb.SaveAs($ccsv,$xxlCSV)
	$xxl.displayalerts=$False
	$xxl.quit()
##########################################
#-       gather unit trans totals       -#
##########################################
	$goodweekinv = Import-Csv $workpath\goodweekinv.csv
	$weekinv = Import-Csv $workpath\weekinv.csv
	$goodweekinv_QTY_ADDED = $goodweekinv | select-object "END","QTY_ADDED" | where{$_.END -match $endmonth} | Select-Object "QTY_ADDED"
	$weekinv_QTY_ADDED = $weekinv |  select-object "END","QTY_ADDED" | where{$_.END -match $endmonth} | Select-Object "QTY_ADDED"
	Compare-Object -ReferenceObject $goodweekinv_QTY_ADDED -DifferenceObject $weekinv_QTY_ADDED

<#
	$results = New-Object -typename psobject
	$results | Add-Member -membertype NoteProperty -Name 'goodweekinv_QTY_ADDED' -Value $goodweekinv_QTY_ADDED
	$results | Add-Member -MemberType NoteProperty -Name 'weekinv_QTY_ADDED' -Value $weekinv_QTY_ADDED
	Write-Output $results | Select-Object 'goodweekinv_QTY_ADDED', 'weekinv_QTY_ADDED' | Format-Table -AutoSize
#>
		Start-Process "cmd.exe" "/c $workpath\cleanup.bat" -Wait -NoNewWindow
	} else {
	Write-Host "missing files"
}