Function Get-InvoiceWorker {
param([string]$Invoice,[string]$InvoiceDate,[string]$Concept,[string]$StoreNumber,[string]$logfile)
	Try {
	    $continue = $true
		if ($StoreNumber -eq $null) {
			$files = gci -Path \\oshfaf02\UnitData -Recurse | Where-Object {$_.name -like $Concept} |
					where {$_.name -like $InvoiceDate} |
					Select-String -SimpleMatch $Invoice
			$results = New-Object PSObject -Property @{            
				StoreNumber   = $StoreNumber 
				FileName      = $files.Filename
				Path		  = $files.Path
			}
	  } else {
			$files = gci -Path \\oshfaf02\UnitData -Recurse | Where-Object {$_.name -like ('$Concept'+'$StoreNumber')} |
					where {$_.name -like $InvoiceDate} |
					Select-String -SimpleMatch $Invoice	
			$results = New-Object PSObject -Property @{            
				StoreNumber   = $StoreNumber 
				FileName      = $files.Filename
				Path		  = $files.Path		
				}
			}
	} catch {
		if ($logfile -ne '') { $Invoice | Out-File $logfile -Append }
	    $continue = $false
	}
	if ($continue) {
	    Write-Output $results
	}
}
<#
.SYNOPSIS
Retrieves invoice(s) from \\directoryxxxx

.DESCRIPTION
Get-Invoice allows you to search for an invoice number from concept archives. Search through all stores within a concept or one specific store within a concept

.PARAMETER InvoiceNumber
Include the invoice number(s) you are looking for
format: _xxxxx_

.PARAMETER InvoiceDate
Include the year and month the invoice was submitted to narrow the search. use ?? as wildcard for the day (DD)
format: _YYMM??_ ( ?? is wildcard for DD )

.PARAMETER Concept
Include this parameter to narrow search of invoices to one concept
Specify which concept number: 1_ for Outback, 2_ for Flemings, 3_ for ROYS, 6_ for Bonefish, 7_ for Carrabbas

.PARAMETER StoreNumber
Include this parameter to narrow search of invoices to a specific store number
format: xxxx ex: 1010

.PARAMETER logfile
Include this parameter to have invoice names logged to a file. Specify the filename as the value for this parameter

.EXAMPLE
Just use a single invoice number:
Get-Invoice -InvoiceNumber _174621_ -InvoiceDate _1301??_ -Concept 6_ -StoreNumber 7110 -log c:\errors.txt

.EXAMPLE
Assuming invoices.txt contains one invoice number per line:
Get-Content invoices.txt | Get-Invoice -InvoiceDate _1301??_ -Concept 6_ -StoreNumber 7110 -log c:\errors.txt

#>
Function Get-Invoice {
    [CmdletBinding()]
PARAM(	
    [Parameter(Mandatory=$True,
           ValueFromPipeline=$True,
           ValueFromPipelineByPropertyName=$True)]
	[string[]]$InvoiceNumber,
    [string]$InvoiceDate,
	[string]$Concept,
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
    Get-InvoiceWorker $Invoice $InvoiceDate $Concept $StoreNumber $logfile
	   }
    }
End{}
}

New-Alias ginv Get-Invoice
Export-ModuleMember -Function Get-Invoice
Export-ModuleMember -Alias ginv