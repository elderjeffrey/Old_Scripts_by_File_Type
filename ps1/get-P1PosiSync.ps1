$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -Credential $creds -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
	$posisynclog = (dir -ErrorAction SilentlyContinue "\\some\path\here").LastWriteTime.ToShortDateString()
	IF ($posisynclog -match (get-date).ToShortDateString()){
				
		$results = New-Object PSObject -Property @{            
			ComputerName  = gc env:computername 
			LastRun       = $posisynclog
				}
		Write-Output $results
		#del c:\sc\posisync.exe
		#del c:\SC\sync.txt
	}
}| select ComputerName, LastRun | Export-Csv c:\P1_Posisync_results.csv -NoTypeInformation