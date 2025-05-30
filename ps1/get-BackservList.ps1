$computername = gc "c:\all_BOH_PCs.txt"
Invoke-Command -computername $computername -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
	$a = Test-Path 'c:\backserv.$$$'
	if (!($a)){
    $results = New-Object PSObject -Property @{            
        Computer         = gc env:computername                 
	    }
    Write-Output $results 
}} | Select-Object Computer | Export-Csv "c:\Backserv-Results.csv" -NoTypeInformation