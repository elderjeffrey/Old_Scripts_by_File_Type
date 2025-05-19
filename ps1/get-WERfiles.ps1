$computername= Read-Host -prompt "what store? ex. OBSxxxx"
Invoke-Command -computername $computername -credential $creds -scriptblock {
	dir "\\some\path\here" | ForEach-Object {
    $results = New-Object PSObject -Property @{            
        Computer         = gc env:computername                 
        Time             = $_.LastWriteTime
        Faulting_Program = $_.Name
    }  
    Write-Output $results 
}} | Select-Object Computer, Time, Faulting_Program | Export-Csv "\\some\path\here\file-Results.csv" -NoTypeInformation