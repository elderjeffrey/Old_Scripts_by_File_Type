$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
	$year = ((Get-Date).tostring("u")).Substring(0,4)
	$month = ((Get-Date).tostring("u")).Substring(6,1)
	

    $files = dir "\\some\path\here" | where {$_.LastWriteTime.toshortdatestring() -notlike ("$month" + "/*/" + "$year")}
	if ($files) {
		foreach ($file in $files) {
	        $results = New-Object PSObject -Property @{            
			ComputerName  = gc env:computername 
			Filename      = $file.name
			LastWrite     = $file.LastWriteTime.ToShortDateString()
			}
	Write-output $results
}}}| select ComputerName, Filename, LastWrite | Export-Csv c:\Old_Invoices.csv -NoTypeInformation