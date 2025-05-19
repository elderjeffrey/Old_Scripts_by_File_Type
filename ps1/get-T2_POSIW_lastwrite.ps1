$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -Credential support -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
	#$date = (Get-Date).toshortdatestring()
	$a = (dir "\\some\path\here").LastWriteTime.toshortdatestring()

            $results = New-Object PSObject -Property @{            
			ComputerName  = gc env:computername 
			POSIW_lastwrite     = $a
			}
		Write-Output $results
}| select ComputerName, POSIW_lastwrite | Export-Csv c:\file_search\T2_file.csv -NoTypeInformation