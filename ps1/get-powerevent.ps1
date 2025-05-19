$computer = Read-Host "what computer"
Invoke-Command -computername $computer -credential $creds -scriptblock {
    get-eventlog -log system -source microsoft-windows-kernel-power | where {$_.eventID -eq 41} | ForEach-Object {
    $results = New-Object PSObject -Property @{            
        ComputerName  = gc env:computername                 
        Time          = $_.TimeGenerated
		Error         = $_.Message
                } 
                Write-Output $results
}} | Select-Object ComputerName, Time, Error | Export-Csv "Windows_Power_Error-Results.csv" -NoTypeInformation