Function Get-RoutWorker {
param($Store,$ButtonName,$InventoryNumber,$ScreenNumber,$BadPrepCategory,$GoodPrepCategory)
	Try {
        $continue = $true
        $Date=(date).ToShortDateString()
        $CurStore = New-Object -Property @{Store=$Store}
	    $File = "\\some\path\here\$Store\file.XML"
		$screensxml = new-object System.Xml.XmlDocument
		$screensxml.Load($File)

        IF($InventoryNumber) {
                $Records = $screensxml.SelectNodes('//Cell') | ? {$_.InventoryNumber -eq $InventoryNumber}
		        $Records | % {IF(!($_.PrepCategory -eq $GoodPrepCategory)) {IF($_.PrepCategory=$GoodPrepCategory) {$changesmade='changesmade'}}}
            }else{
		        $Records = $screensxml.SelectNodes('//Cell') | ? {$_.CellName -like $ButtonName}
		        $Records | % {IF(!($_.PrepCategory -eq $GoodPrepCategory)) {IF($_.PrepCategory=$GoodPrepCategory) {$changesmade='changesmade'}}}
                }
        } catch {
		if ($changesmade) {
        $screensxml.Save($File)
        $NewRecords=$screensxml.SelectNodes('//Cell') | ? {$_.CellName -like $ButtonName}
        Write-Output $CurStore $Records | select store,cellnumber,cellname,inventorynumber,prepcategory | Export-Csv "C:\PrepRoutingChanged_$Date.csv" -NoTypeInformation -Append}
	    $continue = $false
	}
	if ($continue) {
        Write-Output $CurStore $Records | select store,cellnumber,cellname,inventorynumber,prepcategory | Format-Table -AutoSize
	}
}
<#
.SYNOPSIS
Verifies KDS Prep Routing and changes according to specifications

.DESCRIPTION
Get-VerifyKDSScreenXML allows you to search for a button name or inventory number to verify and/or change it's KDS Prep Routing.

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
Get-VerKDSRout -ButtonName *sir &coco* -GoodPrepCategory 17

.EXAMPLE
Search for InventoryNumber and GoodPrepCategory; if current prep category is not set to the value of GoodPrepCategory it will correct it and save the xml file:
Get-VerKDSRout -InventoryNumber *10079* -GoodPrepCategory 17

#>
Function Get-KDSRout {
    [CmdletBinding()]
PARAM(	
    [Parameter(Mandatory=$True,
           ValueFromPipeline=$True,
           ValueFromPipelineByPropertyName=$True)]
	[string[]]$ButtonName,
    [string[]]$InventoryNumber,
	[string]$ScreenNumber,
	[string]$BadPrepCategory,
	[string]$GoodPrepCategory
	)
Begin{
    $logfile= test-path "C:\PrepRoutingChanged*.csv"
	if ($logfile) {del $logfile -ErrorAction SilentlyContinue}
	 }
Process{
	$workpath = "C:\Users\jelder\Desktop"
	copy "\\some\path\hereOBS_Platinum Load Sites & One Off's.xlsx" $workpath
	$xlCSV=6
	$xlsx="$workpath\OBS_Platinum Load Sites & One Off's.xlsx"
	$csv="$workpath\OBS_Platinum Load Sites & One Off's.csv"
	$xl=New-Object -com "Excel.Application"
	$wb=$xl.workbooks.open($xlsx)
	$wb.SaveAs($csv,$xlCSV)
	$xl.displayalerts=$False
	$xl.quit()
	$sites = Import-Csv "$workpath\OBS_Platinum Load Sites & One Off's.csv"
	$StoreNumber = $sites | ?{$_.KDS -eq 'Full'}
	del "$workpath\OBS_Platinum Load Sites & One Off's.xlsx" 
	foreach ($Store in $StoreNumber) {
    Get-RoutWorker $Store $ButtonName $InventoryNumber $ScreenNumber $BadPrepCategory $GoodPrepCategory
	   }
    }
End{
	del "$workpath\OBS_Platinum Load Sites & One Off's.xlsx"
	del "$workpath\OBS_Platinum Load Sites & One Off's.csv"
   }
}

New-Alias gkds Get-KDSRout
Export-ModuleMember -Function Get-KDSRout
Export-ModuleMember -Alias gkds