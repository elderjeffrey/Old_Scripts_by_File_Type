$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -Credential $creds -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
	Try {
		$continue = $true
		$poimport = gc "\\some\path\her" | Select-String -Pattern "06/04/2013", "06/05/2013", "06/06/2013"
		
	        $results = New-Object PSObject -Property @{            
			ComputerName  = gc env:computername
			Invoices      = $poimport.Count
			}
		} catch {
		}
		if ($continue) { Write-Output $results}
}| select ComputerName, Invoices | Export-Csv "\\some\path\here" -NoTypeInformation