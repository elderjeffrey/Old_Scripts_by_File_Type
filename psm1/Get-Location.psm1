Function Get-LocationbyInventoryWorker{
param([string]$Store,[string]$InvNumber,$ExportToFile,$temp,$Date)
    $CurStore = New-Object -TypeName PSObject -Property @{Store=$Store}
    $File = "\\some\path\here\$Concept\$Store\file.XML"
	$screensxml = new-object System.Xml.XmlDocument
	$screensxml.Load($File)
	$Orderscreens = $screensxml.Screens.NewScreens.OrderScreen | ? {$_.Cell.InventoryNumber -like $InvNumber}
	foreach($Screen in $Orderscreens) {
	    $Screens = New-Object -TypeName PSObject -Property @{ScreenNumber=$Screen.ScreenNumber;ScreenName=$Screen.Title}
	    $Records= $Screen.Cell | ?{$_.InventoryNumber -like $InvNumber}
		$Records | %{
						$gcellname = $_.cellname
						$gprep = $_.prepcategory
						$gseq = $_.prepsequence
				[string]$subprepcat = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep}).Name
				[string]$subprepseq = ($PrepSeq.GetEnumerator() | ?{$_.value -eq $gseq}).Name
						$props = @{
							Store = $CurStore.Store
							Title = $Orderscreen.Title
							Screen = $Orderscreen.ScreenNumber
							CellNumber = $_.cellnumber
							PLU = $_.inventorynumber
							CellName = $gcellname
							PrepCategory = $subprepcat
							PrepSequence = $_.prepsequence
							OptionRouting = $_.OptionRouting
							CheckFileOnly = $_.checkfileonly
							MainItem = $_.mainitem
							ManagerOnly = $_.manager
							MustAskSeatNumber = $_.mustaskseatnumber};
						$options = IF($_.optiongroup){$_.optiongroup | %{$_}};
						New-Object psobject -Property $props;IF($Modifiers){Write-Output $options};
						}
		IF(!$ExportToFile){
			#Write-Output $CurStore $Screens $Records | select store,screennumber,screenname,cellnumber,cellname,inventorynumber,prepcategory,prepsequence,mustaskseatnumber,MainItem,CheckFileOnly | ft -AutoSize
		}else{
			Write-Output $CurStore $Screens $Records | select store,screennumber,screenname,cellnumber,cellname,inventorynumber,prepcategory,prepsequence,mustaskseatnumber,MainItem,CheckFileOnly | ft -AutoSize
			Write-Output $CurStore $Screens $Records | select store,screennumber,screenname,cellnumber,cellname,inventorynumber,prepcategory,prepsequence,mustaskseatnumber,MainItem,CheckFileOnly | Export-Csv -Path "$temp\ScreenContentsByInventoryNumber_$Date.csv" -NoTypeInformation -Append
		}
	}
}
<#
.SYNOPSIS
Verifies Prep Routing and, if necessary, changes according to specifications

.DESCRIPTION
Get-Rout allows you to search for a button name or inventory number to verify and/or change it's Prep Routing.

.PARAMETER Concept
Mandatory first position. May select either Outback, Bonefish, Carrabas,Flemings, or Roys

.PARAMETER Load
Mandatory second position. May Select either Platinum or KDS. If your concept does not utilize KDS then select Platinum

.PARAMETER PrepCategory
Madatory. Only available when Concept parameter is present
PrepCategory is a Dynamic Parameter that automatically populates the corresponding list of prep categories depending on
which Concept is selected. Using the [Tab] key to cycle through list the user may choose one prep category. Once selected,
place quotation marks around the prep category. May only select one Prep Category at a time.
Format: "17 GRILL/FRY/MKUP"

.PARAMETER ButtonName
Include the button name you are looking for
format: "*button name*"
May also be a list of names: "*button name*", "*button name*", "*button name*" -- Take note of the comma and space between the values
When searching for more than one ButtonName, be sure they all have the same prep category as only 1 prep category can be searched for at a time

.PARAMETER InventoryNumber
Include the inventory number you are looking for
format: "*12345*"
May also be a list of inventory numbers: "*12345*", "*12345*", "*12345*" -- Take note of the comma and space between the values
When searching for more than one InventoryNumber, be sure they all have the same prep category as only 1 prep category can be searched for at a time

.PARAMETER ScreenNumber -NOT ABLE TO BE UTILIZED JUST YET-
Include the screen number you are looking for
format: "xx"

.EXAMPLE
Search for ButtonName and PrepCategory; if current prep category found in screens.xml is not set to the value of PrepCategory
it will correct it and save the xml file:
Get-Rout -Concept Outback -Load KDS -PrepCategory "17 GRILL/FRY/MKUP" -ButtonName "*lob tacos*"
-or if using tab complete-
gr Outback KDS "17 GRILL/FRY/MKUP" -ButtonName "*lob tacos*"
or
gr Outback KDS "17 GRILL/FRY/MKUP" -ButtonName "*lob tacos*", "*sir &coco*"

.EXAMPLE
Search for InventoryNumber and PrepCategory; if current prep category found in screens.xml is not set to the value of PrepCategory
it will correct it and save the xml file:
Get-Rout -Concept Outback -Load Platinum -PrepCategory "43 GRILL/FRY/MKUP" -InventoryNumber "10007"
-or if using tab complete-
gr Outback Platinum "43 GRILL/FRY/MKUP" -InventoryNumber "10007"
or
gr Outback KDS "17 GRILL/FRY/MKUP" -InventoryNumber "10007", "10147"

#>
Function Get-Location{
	[CmdletBinding()]
PARAM(
    [Parameter(Position=0,
	  Mandatory=$True,
      ValueFromPipeline=$True,
      ValueFromPipelineByPropertyName=$True)]
	[ValidateSet("Outback","Bonefish","Carrabbas","Flemings","Roys")]
    [string]$Concept,
    [Parameter(Position=1,
	  Mandatory=$True,
      ValueFromPipeline=$True,
      ValueFromPipelineByPropertyName=$True)]
	[ValidateSet("KDS","Platinum")]
	[string]$Load,
	<#[Parameter(ValueFromPipeline=$True,
	  ValueFromPipelineByPropertyName=$True)]
	[string[]]$ButtonName,#>
	[Parameter(ValueFromPipeline=$True,
	  ValueFromPipelineByPropertyName=$True)]
    [string[]]$InventoryNumber,
	[parameter(Mandatory=$false)]
	[switch]$ExportToFile
	)
	<#DynamicParam{
		IF($Concept -eq "Outback"){
			$workpath = "G:\POSItouch Information\Gold Load Databases\Outback\Platinum Load"
			$PrepCat= ((gc "$workpath\OBPrepCategories.txt") -replace ',', '=') -join "`n" | ConvertFrom-StringData
			$PrepCatAttribute= New-Object System.Management.Automation.ParameterAttribute
			$PrepCatAttribute.Position=2
			$PrepCatAttribute.Mandatory=$true
			$PrepCatAttributeCollection= New-Object System.Collections.ObjectModel.Collection[System.Attribute]
			$PrepCatAttributeCollection.Add($PrepCatAttribute)
			$ValidateSet= new-object System.Management.Automation.ValidateSetAttribute($PrepCat.get_Keys())
			$PrepCatAttributeCollection.Add($ValidateSet)
			$PrepCatParam= New-Object System.Management.Automation.RuntimeDefinedParameter('PrepCategory', [string], $PrepCatAttributeCollection)
			$paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
         	$paramDictionary.Add('PrepCategory', $PrepCatParam)
         	return $paramDictionary
		}elseif($Concept -eq "Bonefish"){
			$workpath = "G:\POSItouch Information\Gold Load Databases\Bonefish"
			$PrepCat= ((gc "$workpath\BFGPrepCategories.txt") -replace ',', '=') -join "`n" | ConvertFrom-StringData
			$PrepCatAttribute= New-Object System.Management.Automation.ParameterAttribute
			$PrepCatAttribute.Position=2
			$PrepCatAttribute.Mandatory=$true
			$PrepCatAttributeCollection= New-Object System.Collections.ObjectModel.Collection[System.Attribute]
			$PrepCatAttributeCollection.Add($PrepCatAttribute)
			$ValidateSet= new-object System.Management.Automation.ValidateSetAttribute($PrepCat.get_Keys())
			$PrepCatAttributeCollection.Add($ValidateSet)
			$PrepCatParam= New-Object System.Management.Automation.RuntimeDefinedParameter('PrepCategory', [string], $PrepCatAttributeCollection)
			$paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
         	$paramDictionary.Add('PrepCategory', $PrepCatParam)
         	return $paramDictionary
		}elseif($Concept -eq "Carrabbas"){
			$workpath = "G:\POSItouch Information\Gold Load Databases\Carrabbas"
			$PrepCat= ((gc "$workpath\CIGPrepCategories.txt") -replace ',', '=') -join "`n" | ConvertFrom-StringData
			$PrepCatAttribute= New-Object System.Management.Automation.ParameterAttribute
			$PrepCatAttribute.Position=2
			$PrepCatAttribute.Mandatory=$true
			$PrepCatAttributeCollection= New-Object System.Collections.ObjectModel.Collection[System.Attribute]
			$PrepCatAttributeCollection.Add($PrepCatAttribute)
			$ValidateSet= new-object System.Management.Automation.ValidateSetAttribute($PrepCat.get_Keys())
			$PrepCatAttributeCollection.Add($ValidateSet)
			$PrepCatParam= New-Object System.Management.Automation.RuntimeDefinedParameter('PrepCategory', [string], $PrepCatAttributeCollection)
			$paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
         	$paramDictionary.Add('PrepCategory', $PrepCatParam)
         	return $paramDictionary
		}elseif($Concept -eq "Flemings"){
			$workpath = "G:\POSItouch Information\Gold Load Databases\Flemings\Documentation"
			#Import-Csv "$WP\FLMPrepCategories.csv" | ?{$_.Name} | ft -HideTableHeaders -AutoSize | Out-File "$WP\FLMPrepCategories.txt"
			$PrepCat= ((gc "$workpath\FLMPrepCategories.txt") -replace ',', '=') -join "`n" | ConvertFrom-StringData
			$PrepCatAttribute= New-Object System.Management.Automation.ParameterAttribute
			$PrepCatAttribute.Position=2
			$PrepCatAttribute.Mandatory=$true
			$PrepCatAttributeCollection= New-Object System.Collections.ObjectModel.Collection[System.Attribute]
			$PrepCatAttributeCollection.Add($PrepCatAttribute)
			$ValidateSet= new-object System.Management.Automation.ValidateSetAttribute($PrepCat.get_Keys())
			$PrepCatAttributeCollection.Add($ValidateSet)
			$PrepCatParam= New-Object System.Management.Automation.RuntimeDefinedParameter('PrepCategory', [string], $PrepCatAttributeCollection)
			$paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
         	$paramDictionary.Add('PrepCategory', $PrepCatParam)
         	return $paramDictionary
		}elseif($Concept -eq "Roys"){
			$workpath = "G:\POSItouch Information\Gold Load Databases\Roys"
			$PrepCat= ((gc "$workpath\ROYSPrepCategories.txt") -replace ',', '=') -join "`n" | ConvertFrom-StringData
			$PrepCatAttribute= New-Object System.Management.Automation.ParameterAttribute
			$PrepCatAttribute.Position=2
			$PrepCatAttribute.Mandatory=$true
			$PrepCatAttributeCollection= New-Object System.Collections.ObjectModel.Collection[System.Attribute]
			$PrepCatAttributeCollection.Add($PrepCatAttribute)
			$ValidateSet= new-object System.Management.Automation.ValidateSetAttribute($PrepCat.get_Keys())
			$PrepCatAttributeCollection.Add($ValidateSet)
			$PrepCatParam= New-Object System.Management.Automation.RuntimeDefinedParameter('PrepCategory', [string], $PrepCatAttributeCollection)
			$paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
         	$paramDictionary.Add('PrepCategory', $PrepCatParam)
         	return $paramDictionary
		}
	
	}#>
Begin{
		IF($Concept -eq "Outback"){
			$workpath = "\\some\path\here"
			if (test-path "$workpath\OBS_Platinum Load Sites & One-Offs.csv") {del "$workpath\OBS_Platinum Load Sites & One-Offs.csv" -ErrorAction SilentlyContinue}
			$xlCSV=6
			$xlsx="$workpath\OBS_Platinum Load Sites & One-Offs.xlsx"
			$csv="$workpath\OBS_Platinum Load Sites & One-Offs.csv"
			$xl= New-Object -com "Excel.Application"
			$wb=$xl.workbooks.open($xlsx)
			$wb.SaveAs($csv,$xlCSV)
			$xl.displayalerts=$False
			$xl.quit()
			[System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)
		}elseif($Concept -eq "Bonefish"){
			$workpath = "\\some\path\here"
			if (test-path "$workpath\BFG_One-offs.csv") {del "$workpath\BFG_One-offs.csv" -ErrorAction SilentlyContinue}		
			$xlCSV=6
			$xlsx="$workpath\BFG_One-offs.xlsx"
			$csv="$workpath\BFG_One-offs.csv"
			$xl= New-Object -com "Excel.Application"
			$wb=$xl.workbooks.open($xlsx)
			$wb.SaveAs($csv,$xlCSV)
			$xl.displayalerts=$False
			$xl.quit()
			[System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)
		}elseif($Concept -eq "Carrabbas"){
			$workpath = "\\some\path\here"
			if (test-path "$workpath\CIG One-Offs.csv") {del "$workpath\CIG One-Offs.csv" -ErrorAction SilentlyContinue}			
			$xlCSV=6
			$xlsx="$workpath\CIG One-Offs.xlsx"
			$csv="$workpath\CIG One-Offs.csv"
			$xl= New-Object -com "Excel.Application"
			$wb=$xl.workbooks.open($xlsx)
			$wb.SaveAs($csv,$xlCSV)
			$xl.displayalerts=$False
			$xl.quit()
			[System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)
		}elseif($Concept -eq "Flemings"){
			$workpath = "\\some\path\here"
			if (test-path "$workpath\Fleming's One-Offs.csv") {del "$workpath\Fleming's One-Offs.csv" -ErrorAction SilentlyContinue}			
			$xlCSV=6
			$xlsx="$workpath\Fleming's One-Offs.xlsx"
			$csv="$workpath\Fleming's One-Offs.csv"
			$xl= New-Object -com "Excel.Application"
			$wb=$xl.workbooks.open($xlsx)
			$wb.SaveAs($csv,$xlCSV)
			$xl.displayalerts=$False
			$xl.quit()
			[System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)
		}elseif($Concept -eq "Roys"){
			$workpath = "\\some\path\here"
			if (test-path "$workpath\Roy's One-Offs.csv") {del "$workpath\Roy's One-Offs.csv" -ErrorAction SilentlyContinue}			
			$xlCSV=6
			$xlsx="$workpath\Roy's One-Offs.xlsx"
			$csv="$workpath\Roy's One-Offs.csv"
			$xl= New-Object -com "Excel.Application"
			$wb=$xl.workbooks.open($xlsx)
			$wb.SaveAs($csv,$xlCSV)
			$xl.displayalerts=$False
			$xl.quit()
			[System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl)
		}
	}
Process{
	$Date=("$((date).month)" + "$((date).day)" + "$((date).year)")
	$temp = [Environment]::GetFolderPath("Desktop")
	$sites = Import-Csv "$workpath\*One-Offs.csv"
	$StoreNumber = $sites.Site
	foreach ($Store in $StoreNumber) {
		$i++
		[int]$Pct=(($i/$StoreNumber.count)*100)
		Write-Progress -activity “Hold Please...” -status “Verifying/Correcting” -PercentComplete $Pct -CurrentOperation "$Pct% complete"
    	IF($InventoryNumber){
			foreach($InvNumber in $InventoryNumber){
				Get-LocationbyInventoryWorker $Store $InvNumber $ExportToFile $temp $Date
			}
		}
	}	
}
End{$props}
}
New-Alias gl Get-Location
Export-ModuleMember -Function Get-Location
Export-ModuleMember -Alias gl