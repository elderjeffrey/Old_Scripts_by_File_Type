Function Get-InvoiceWorker {
param([string]$Invoice,[string]$Concept,[string]$InvoiceDate,[string]$StoreNumber,[string]$logfile)
	Try {
	    $continue = $true
		if ($StoreNumber -ne $null) {		
			$files = gci -Path \\some\path\here\$($Concept+$StoreNumber) | where {$_.Name -Like $Concept+$storenumber+$InvoiceDate+$Invoice}
		foreach ($file in $files) {
			$results = New-Object PSObject -Property @{
				FileName      = $file.Name
				Path		  = $file.DirectoryName
				}
				}
	  	} else {
			$folders = gci -Path \\some\path\here | Where-Object {$_.name -like "$Concept"}
			foreach ($folder in $folders) {
			$path = "\\some\path\here"
			$files = gci -Path $path | where {$_.name -like $Concept+$InvoiceDate+$Invoice}
		foreach ($file in $files) {
			$results = New-Object PSObject -Property @{ 
				FileName      = $file.Name
				Path		  = $file.DirectoryName
				}
				}
			}
			}
	} catch {
		if ($logfile -ne '') { $Invoice | Out-File $logfile -Append }
	    $continue = $false
	}
	if ($continue) {
	    Write-Output $results | select Filename, Path
	}
}
<#
.SYNOPSIS
Retrieves invoice(s) from \\oshfaf02\UnitData
.DESCRIPTION
Get-Invoice allows you to search for an invoice number from concept archives. Search through all stores within a concept or one specific store within a concept
.PARAMETER InvoiceNumber
Include the invoice number(s) you are looking for
format: "xxxxx_*.*"
.PARAMETER InvoiceDate
Include the year and month the invoice was submitted to narrow the search. use * as wildcard for the day (DD)
format: "_YYMM*_" ( * is wildcard for DD )
.PARAMETER Concept
Include this parameter to narrow search of invoices to one concept
Specify which concept number:
"1_" for Outback
"2_" for Flemings
"3_" for ROYS
"6_" for Bonefish
"7_" for Carrabbas
.PARAMETER StoreNumber
Include this parameter to narrow search of invoices to a specific store number
format: xxxx ex: "1010"
.PARAMETER logfile
Include this parameter to have failed computer names logged to a file. Specify the filename as the value for this parameter
.EXAMPLE
Just use a single invoice number:
Get-Invoice -InvoiceNumber "160058_*.*" -InvoiceDate "_1301*_" -Concept "6_" -StoreNumber "7110" -log c:\errors.txt
.EXAMPLE
Assuming invoices.txt contains one invoice number per line:
Get-Content invoices.txt | Get-Invoice -InvoiceDate "_1301*_" -Concept "6_" -StoreNumber "7110" -log c:\errors.txt
#>
Function Get-Invoice {
    [CmdletBinding()]
PARAM(	
    [Parameter(Mandatory=$True,
           ValueFromPipeline=$True,
           ValueFromPipelineByPropertyName=$True)]
	[string[]]$InvoiceNumber,
	[Parameter(Mandatory=$True,
           ValueFromPipeline=$True,
           ValueFromPipelineByPropertyName=$True)]
	[string]$Concept,
    [string]$InvoiceDate,	
	[string]$StoreNumber,
    [string]$logfile = ''
	)
Begin{
	if ($logfile -ne '') {
	del -Path $logfile -ErrorAction SilentlyContinue
	}
}
Process{    
	foreach ($Invoice in $InvoiceNumber) {
    Get-InvoiceWorker $Invoice $Concept $InvoiceDate $StoreNumber $logfile
	   }
    }
End{}
}
<#
New-Alias ginv Get-Invoice
Export-ModuleMember -Function Get-Invoice
Export-ModuleMember -Alias ginv
#>