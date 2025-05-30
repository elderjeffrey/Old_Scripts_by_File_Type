$workpath = "some\path\here"
if(test-path "$workpath\OBS Databases Defined.csv"){del "$workpath\OBS Databases Defined.csv" -ErrorAction SilentlyContinue}
$xlCSV=6
$xlsx="$workpath\OBS Databases Defined.xls"
$csv="$workpath\OBS Databases Defined.csv"
$xl= New-Object -com "Excel.Application"
$xl.displayalerts=$False
$xl.visible=$false
$wb=$xl.workbooks.open($xlsx)
$wb.SaveAs($csv,$xlCSV)
$xl.quit()
[Void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)
$LastWrite = (Get-Date).ToShortDateString()
$sites = Import-Csv "$workpath\OBS Databases Defined.csv"| select ExportGroup, Site |?{$_.exportgroup -like "*new*"}
$allobj = @()
foreach ($Store in $sites.site){
	$exportgroup= $sites | ?{$Store -match $_.Site}
	$TargetFolder= "\\some\path\here\$Store"
	$Files = dir $TargetFolder | ?{$_.name -like "*.xml"}
	$colObj= @()
	$Files | %{if($_.lastwritetime.ToShortDateString() -eq $LastWrite){Write-host $exportgroup.ExportGroup"Completed Exporting Successfully"$exportgroup.Site$_.name$_.lastwritetime}else{
			$obj = new-object -typename psobject
			$obj | Add-Member -MemberType noteproperty -Name 'Site' -Value $exportgroup.Site
			$obj | Add-Member -MemberType noteproperty -Name 'ExportGroup' -Value $exportgroup.ExportGroup.Trim('NEW Export Group')
			$obj | Add-Member -MemberType noteproperty -Name 'File' -Value $_.Name
			$obj | Add-Member -MemberType noteproperty -Name 'LastWrite'  -Value $_.LastWriteTime
			$colObj += $obj}}
	$allobj += $colObj
}


Write-Output $allObj | ft -AutoSize;Write-Host "Report last run $(Get-Date -f g)";write-output $(Get-Date -f g) | Out-File "$workpath\CheckExports.log" -Append
<#	foreach ($File in $Files){
		if($file.lastwritetime.ToShortDateString() -eq $LastWrite){
			
		}else{
			$obj = new-object -typename psobject
			$obj | Add-Member -MemberType noteproperty -Name 'Site' -Value $exportgroup.Site
			$obj | Add-Member -MemberType noteproperty -Name 'ExportGroup' -Value $exportgroup.ExportGroup.Trim('NEW Export Group')
			$obj | Add-Member -MemberType noteproperty -Name 'File' -Value $_.Name
			$obj | Add-Member -MemberType noteproperty -Name 'LastWrite'  -Value $_.LastWriteTime
			$colObj += $obj 
		}
	}
##>