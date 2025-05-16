$computer = Read-Host "what computer"
Invoke-Command -computername $computer -credential $creds -scriptblock {
    get-eventlog -log application -source 'Application Error' -Newest 50 | ForEach-Object {
    $results = New-Object PSObject -Property @{            
        ComputerName  = gc env:computername                 
        Time          = $_.TimeGenerated
		Error         = $_.EventID
		Message       = $_.Message
                } 
                Write-Output $results
}} | Select-Object ComputerName, Time, Error, Message | Export-Csv "c:\some\path\here\Windows_Application_Error-Results.csv" -NoTypeInformation

#