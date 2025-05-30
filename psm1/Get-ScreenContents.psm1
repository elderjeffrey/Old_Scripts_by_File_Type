Function Get-ScreenContentsWorker{
param([string]$Store,[string]$Screen,$Concept)

    $Date=("$((date).month)" + "$((date).day)" + "$((date).year)")
    $CurStore = New-Object -TypeName PSObject -Property @{Store=$Store}
    $File = "\\some\path\here\$Concept\$Store\file.XML"
	$screensxml = new-object System.Xml.XmlDocument
	$screensxml.Load($File)
	$Orderscreen = $screensxml.Screens.NewScreens.OrderScreen | ?{$_.ScreenNumber -match $Screen}
	$ButtonItems = $Orderscreen | ?{$_.Cell.OptionGroup} | foreach($_.Cell){Write-Output $_.cell}
	#$temp= [Environment]::GetFolderPath("Desktop")
	Write-Output $CurStore $Orderscreen $ButtonItems | select store,screennumber,title,cellnumber,cellname,inventorynumber,celltype,cellcolor,prepcategory,prepsequence,mustaskseatnumber | ft -AutoSize
}
<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.PARAMETER

.EXAMPLE1

.EXAMPLE2


#>
function Get-ScreenContents{
	[CmdletBinding()]
param(
    [Parameter(Position=0,
	  Mandatory=$True,
      ValueFromPipeline=$True,
      ValueFromPipelineByPropertyName=$True)]
	[ValidateSet("Outback","Bonefish","Carrabbas","Flemings","Roys")]
    [string]$Concept,
	[string[]]$StoreNumber,
	[string[]]$ScreenNumber)

Begin{}
Process{
	$i=0
	foreach ($Store in $StoreNumber) {
		$i++
		[int]$Pct=(($i/$StoreNumber.count)*100)
		Write-Progress -activity “Hold Please...” -status “Verifying/Correcting” -PercentComplete $Pct -CurrentOperation "$Pct% complete"
			foreach($Screen in $ScreenNumber){
				Get-ScreenContentsWorker $Store $Screen $Concept
			}
	}
}
End{}
}
New-Alias gsi Get-ScreenContents
Export-ModuleMember -Function Get-ScreenContents
Export-ModuleMember -Alias gsi