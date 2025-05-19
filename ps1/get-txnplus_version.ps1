$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -Credential $creds -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
	$a = gwmi win32_service -Filter "name='dbstps'"
	$b = dir "\\some\path\here"
	        $results = New-Object PSObject -Property @{            
			ComputerName  = gc env:computername 
			Build         = $a.description
			Path          = $a.pathname
			LastWriteTime = $b.LastWriteTime.toshortdatestring()
			Size          = $b.length
			}
		Write-Output $results
}| select ComputerName, Build, Path, LastWriteTime, Size | Export-Csv c:\file_Results.csv -NoTypeInformation