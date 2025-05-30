Function Get-KDSRoutWorker{
param([string]$Store,[string[]]$ButtonName,[string[]]$InventoryNumber,[string[]]$ScreenNumber,[string[]]$BadPrepCategory,[string[]]$GoodPrepCategory)
	Try {
        $continue = $true
        $Date=("$((date).month)" + "$((date).day)" + "$((date).year)")
        $CurStore = New-Object -TypeName PSObject -Property @{Store=$Store} 
	    $File = "\\some\path\here\$Store\file.XML"
		$screensxml = new-object System.Xml.XmlDocument
		$screensxml.Load($File)
		$screens=$screensxml.SelectNodes('//OrderScreen') | Select ScreenNumber,Cell | ? {$_.Cell.CellName -like $ButtonName}
		
        if ($InventoryNumber) {
                $Records = $screensxml.SelectNodes('//Cell') | ? {$_.InventoryNumber -eq $InventoryNumber}
		        $Records | % {IF(!($_.PrepCategory -eq $GoodPrepCategory)) {IF($_.PrepCategory=$GoodPrepCategory) {$changesmade='changesmade'}}}
            }else{
		        $Records = $screensxml.SelectNodes('//Cell') | ? {$_.CellName -like $ButtonName}
		        $Records | % {IF(!($_.PrepCategory -eq $GoodPrepCategory)) {IF($_.PrepCategory=$GoodPrepCategory) {$changesmade='changesmade'}}}
                }
    } catch {
		if ($changesmade -and $InventoryNumber) {
	        $screensxml.Save($File)
	        $NewRecords=$screensxml.SelectNodes('//Cell') | ? {$_.CellName -like $InventoryNumber}
	        Write-Output $CurStore $NewRecords | select store,cellnumber,cellname,inventorynumber,prepcategory | Export-Csv "C:\PrepRoutingChanged_$Date.csv" -NoTypeInformation -Append}		
		else{
		if ($changesmade){
	        $screensxml.Save($File)
	        $NewRecords=$screensxml.SelectNodes('//Cell') | ? {$_.CellName -like $ButtonName}
	        Write-Output $CurStore $NewRecords | select store,cellnumber,cellname,inventorynumber,prepcategory | Export-Csv "C:\PrepRoutingChanged_$Date.csv" -NoTypeInformation -Append}
			}
		$continue = $false
		}
	if ($continue) {
        Write-Output $CurStore $screens $Records | select store,screennumber,cellnumber,cellname,inventorynumber,prepcategory | Format-Table -AutoSize
		Write-Output $CurStore $screens $Records | select store,screennumber,cellnumber,cellname,inventorynumber,prepcategory | Export-Csv "C:\PrepRoutingCorrect_$Date.csv" -NoTypeInformation -Append
		}
}
<#
.SYNOPSIS
Verifies KDS Prep Routing and changes according to specifications

.DESCRIPTION
Get-KDSRout allows you to search for a button name or inventory number to verify and/or change it's KDS Prep Routing.

.PARAMETER ButtonName
Include the button name you are looking for
format: *button name*

.PARAMETER InventoryNumber
Include the inventory number you are looking for
format: *inventory number*

.PARAMETER ScreenNumber
Include the screen number you are looking for
format: 'xx'

.PARAMETER BadPrepCategory
Include the screen number you are looking for
format: 'xx'

.PARAMETER GoodPrepCategory
Include the screen number you are looking for
format: 'xx'

.EXAMPLE
Search for ButtonName and GoodPrepCategory; if current prep category is not set to the value of GoodPrepCategory it will correct it and save the xml file:
Get-KDSRout -ButtonName *sir &coco* -GoodPrepCategory 17

.EXAMPLE
Search for InventoryNumber and GoodPrepCategory; if current prep category is not set to the value of GoodPrepCategory it will correct it and save the xml file:
Get-KDSRout -InventoryNumber *10079* -GoodPrepCategory 17

#>
Function Get-KDSRout {
	[CmdletBinding()]
PARAM(	
	[string[]]$ButtonName,
    [string[]]$InventoryNumber,
	[string[]]$ScreenNumber,
	[string[]]$BadPrepCategory,
	[string[]]$GoodPrepCategory
	)
Begin{
    $logfile= test-path "C:\PrepRoutingChanged*.csv"
	$logfile2= test-path "C:\PrepRoutingCorrect*.csv"
	if ($logfile) {del $logfile -ErrorAction SilentlyContinue}
	if ($logfile2) {del $logfile -ErrorAction SilentlyContinue}
	}
Process{
	$workpath = "C:\Users\jelder\Desktop"
	copy "\\some\path\here\file.xlsx" $workpath
	$xlCSV=6
	$xlsx="$workpath\file.xlsx"
	$csv="$workpath\file.csv"
	$xl=New-Object -com "Excel.Application"
	$wb=$xl.workbooks.open($xlsx)
	$wb.SaveAs($csv,$xlCSV)
	$xl.displayalerts=$False
	$xl.quit()
	$sites = Import-Csv "$workpath\file.csv"
	$StoreNumber = ($sites | ?{$_.KDS -eq 'Full'}).Site
	del "$workpath\file.xlsx" 
	foreach ($Store in $StoreNumber) {
    Get-KDSRoutWorker $Store $ButtonName $InventoryNumber $ScreenNumber $BadPrepCategory $GoodPrepCategory
	   }
    }
End{
	if (Test-Path "C:\PrepRoutingChanged*.csv"){[system.collections.ArrayList]$Verified=Import-Csv "C:\PrepRoutingCorrect*.csv" | select Store -Unique
												$Verified.RemoveRange(1,1)
												Write-host $Verified.count "KDS Sites InCorrect"}
	
	if (Test-Path "C:\PrepRoutingCorrect*.csv"){[system.collections.ArrayList]$Verified2=Import-Csv "C:\PrepRoutingCorrect*.csv" | select Store -Unique
												$Verified2.RemoveRange(1,1)
												Write-host $Verified2.count "KDS Sites Correct"}
	#del "C:\PrepRoutingCorrect*.csv"
	del "$workpath\OBS_Platinum Load Sites & One Off's.csv"
	}
}

New-Alias gkds Get-KDSRout
Export-ModuleMember -Function Get-KDSRout
Export-ModuleMember -Alias gkds