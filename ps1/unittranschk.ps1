##########################################
#---         define variables         ---#
##########################################
$targetpath = "\\some\path\here"
$workpath="\\some\path\here"
$log="\\some\path\here"

#$beginmonth=(Get-Date).adddays(-$numdays+1).toshortdatestring()
$numdays=(get-date).day
$month=Read-Host -prompt "what month? 1-12"
$year=Read-Host -prompt "what year? example: 2012"
$trndate="$month" + "/*/" + "$year"
$endmonth=(((Get-Date).adddays(-$numdays+1)).addmonths(1)).adddays(-1).toshortdatestring()

$dirs=dir $targetpath | where {$_.psiscontainer -eq $true}
foreach ($dir in $dirs)
	{
	$a=Test-Path $targetpath\$dir\file.dbf
	$b=Test-Path $targetpath\$dir\file.dbf
	$c=Test-Path $targetpath\$dir\file.dat
	$d=Test-Path $targetpath\$dir\file.sys
	$e=Test-Path $targetpath\$dir\file.str
	if ($a -and $b -and $c -and $d -and $e -eq $true)
	{
	copy "$targetpath\$dir\file1*.*" "$workpath"
	copy "$targetpath\$dir\file2.dat" "$workpath"
	copy "$targetpath\$dir\file3.dbf" "$workpath"
	copy "$targetpath\$dir\file4.sys" "$workpath"
	copy "$targetpath\$dir\file5.str" "$workpath"
 
##########################################
#--- convert file.dbf to file.csv ---#
##########################################
	$xlCSV=6
	$xls="$workpath\file.DBF"
	$csv="$workpath\file.csv"
	$xl=New-Object -com "Excel.Application"
	$wb=$xl.workbooks.open($xls)
	$wb.SaveAs($csv,$xlCSV)
	$xl.displayalerts=$False
	$xl.quit()
##########################################
#--- convert file.dbf to file.csv ---#
##########################################
	$weekinv = Start-Process "cmd.exe" "/c $workpath\getweekinv.bat" -Wait -PassThru -NoNewWindow
	$xxlCSV=6
	$xxls="$workpath\file.DBF"
	$ccsv="$workpath\file.csv"
	$xxl=New-Object -com "Excel.Application"
	$wwb=$xxl.workbooks.open($xxls)
	$wwb.SaveAs($ccsv,$xxlCSV)
	$xxl.displayalerts=$False
	$xxl.quit()
##########################################
#-       gather unit trans totals       -#
##########################################
	$trndtl = Import-Csv $workpath\file.csv
	$trndtlsum = $trndtl | select-object "DATE","QUANTITY" | where{$_.DATE -like $trndate} | measure quantity -Sum | select sum
	$indata = Import-Csv $workpath\file.csv
	$indatasum = $indata | select-object "END","QTY_ADDED" | where{$_.END -match $endmonth} | measure qty_added -Sum | select sum
	#Write-Host "$dir.name TRNDTL=$trndtlsum INDATA=$indatasum"
	if ($indatasum -ne $trndtlsum) 
		{
		Write-Host "ACTION NEEDED for $dir! INDATA unit trans does not match TRNDTL" -foregroundcolor "red"
		Write-Output "$dir TRNDTL=$trndtlsum INDATA=$indatasum" | Out-File $log -append	
		}
		else
		{
		Write-Host "unit trans matches for $dir TRNDTL=$trndtlsum INDATA=$indatasum"	
		}
	Start-Process "cmd.exe" "/c $workpath\cleanup.bat" -Wait -PassThru -NoNewWindow
	}
	else
	{
	Write-Host "$dir missing files"
	Write-Output "$dir missing files" | Out-File $log -append
	}
}