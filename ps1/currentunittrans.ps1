##########################################
#---         define variables         ---#
##########################################
$targetpath = "some\path\here"
$workpath="some\path\here"
$log=

$numdays=(get-date).day
$year=(Get-Date).year
$month=(Get-Date).month
$prevmonth=(((Get-Date).adddays(-$numdays)).month)
$trndate="$month" + "/*/" + "$year"
$prevtrndate="$prevmonth" + "/*/" + "$year"
$endmonth=(((Get-Date).adddays(-$numdays+1)).addmonths(1)).adddays(-1).toshortdatestring()
$lastmonth=((Get-Date).adddays(-$numdays)).toshortdatestring()

	$a=Test-Path $targetpath\trndtl.dbf
	$b=Test-Path $targetpath\indata.dbf
	$c=Test-Path $targetpath\inmaster.dat
	$d=Test-Path $targetpath\screens.sys
	$e=Test-Path $targetpath\rdcdata.str
	if ($a -and $b -and $c -and $d -and $e -eq $true)
	{
	copy "$targetpath\indata*.*" "$workpath"
	copy "$targetpath\inmaster.dat" "$workpath"
	copy "$targetpath\trndtl.dbf" "$workpath"
	copy "$targetpath\screens.sys" "$workpath"
	copy "$targetpath\rdcdata.str" "$workpath"

##########################################
#--- convert trndtl.dbf to trndtl.csv ---#
##########################################
	$xlCSV=6
	$xls="$workpath\TRNDTL.DBF"
	$csv="$workpath\trndtl.csv"
	$xl=New-Object -com "Excel.Application"
	$wb=$xl.workbooks.open($xls)
	$wb.SaveAs($csv,$xlCSV)
	$xl.displayalerts=$False
	$xl.quit()
##########################################
#--- convert indata.dbf to weekinv.csv ---#
##########################################
	$weekinv = Start-Process "cmd.exe" "/c $workpath\getweekinv.bat" -Wait -PassThru -NoNewWindow
	$xxlCSV=6
	$xxls="$workpath\weekinv.DBF"
	$ccsv="$workpath\weekinv.csv"
	$xxl=New-Object -com "Excel.Application"
	$wwb=$xxl.workbooks.open($xxls)
	$wwb.SaveAs($ccsv,$xxlCSV)
	$xxl.displayalerts=$False
	$xxl.quit()
##########################################
#-       gather unit trans totals       -#
##########################################
	$trndtl = Import-Csv $workpath\trndtl.csv
	$trndtlsum = $trndtl | select-object "DATE","QUANTITY" | where{$_.DATE -like $trndate} | measure quantity -Sum | select sum
	$indata = Import-Csv $workpath\weekinv.csv
	$indatasum = $indata | select-object "END","QTY_ADDED" | where{$_.END -match $endmonth} | measure qty_added -Sum | select sum
	
	$results = New-Object -typename psobject
	$results | Add-Member -membertype NoteProperty -Name 'Indata_Sum' -Value $indatasum.Sum
	$results | Add-Member -MemberType NoteProperty -Name 'Trndtl_Sum' -Value $trndtlsum.Sum
	Write-Output $results | Select-Object 'Indata_Sum', 'Trndtl_Sum' | Format-Table -AutoSize
	<#
if ("$trndtlsum" -ne "$indatasum") 
		{
			$results = New-Object PSObject -Property @{            
	        IndataSum  = $indatasum                 
	        TrndtlSum  = $trndtlsum
		} |
		Write-Output $results 
		Select-Object IndataSum, TrndtlSum | Write-Host -foregroundcolor red
		#Write-Output "$dir TRNDTL=$trndtlsum INDATA=$indatasum" | Out-File $log -append			
		}
		else
		{
			$results = New-Object PSObject -Property @{            
	        IndataSum  = $indatasum.ToString()
	        TrndtlSum  = $trndtlsum.ToString()
			}
			Write-Output $results 
		} select IndataSum, TrndtlSum | format-table -autosize
		#Write-Output TRNDTL=$trndtlsum INDATA=$indatasum" | Out-File $log2 -Append
		}
	#>
	Start-Process "cmd.exe" "/c $workpath\cleanup.bat" -Wait -NoNewWindow
	} else {
	Write-Host "missing files"
	}
#}