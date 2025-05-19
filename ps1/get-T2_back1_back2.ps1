$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -Credential $creds -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
	$date = (Get-Date).toshortdatestring()
	$a = (dir "\\some\path\here\file1.zip").LastWriteTime.toshortdatestring()
	$b = (dir "\\some\path\here\file2.zip").LastWriteTime.toshortdatestring()
        if ($a -and $b -notmatch $date) {
	        $results = New-Object PSObject -Property @{            
			ComputerName  = gc env:computername 
			Back1         = $a
			Back2         = $b
			}
		}
		Write-host $results
}| select ComputerName, Back1, Back2 | Export-Csv c:\T2_file1_file2.csv -NoTypeInformation