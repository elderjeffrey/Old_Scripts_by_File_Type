$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -Credential $creds -ThrottleLimit 8 -scriptblock {
	$shift1 = "SHIFT1=default,00:00:00"
	$shift2 = "SHIFT=SCND SHIFT,03:00:00"
	$correctshift1 = "SHIFT1=FRST SHIFT,15:00:00"
	$correctshift2 = "SHIFT2=SCND SHIFT,02:00:00"

	$File = gc "\\some\path\here" | ?{$_ -match "SHIFT"}
	IF ($File) {
		IF ($File -contains $shift1) {
			$Results = New-Object PSObject -Property @{            
				ComputerName     = gc env:computername 
				BadShift1         = $shift1
					}
			}
		IF ($File -contains $shift2) {
			$Results = New-Object PSObject -Property @{            
				ComputerName     = gc env:computername 
				BadShift2         = $shift2
					}
			}
		IF ($File -contains $correctshift1 -and $Correctshift2) {
			$Results = New-Object PSObject -Property @{            
				ComputerName     = gc env:computername 
				CorrectShift1    = $correctshift1
				CorrectShift2    = $correctshift2
					}
			}
	Write-Output $Results
	}
}| select ComputerName, BadShift1, BadShift2,CorrectShift1, CorrectShift2 | Export-Csv c:\file_results.csv -NoTypeInformation