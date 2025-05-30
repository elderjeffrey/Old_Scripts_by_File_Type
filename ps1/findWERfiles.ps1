<#
$path="some\path\here"
$log="some\path\here\file.csv"
$targetpath="some\path\here"
dir $targetpath | select-object lastwritetime,name | Export-Csv -Path $log -NoTypeInformation | where {$_.lastwritetime -match "6/17/2012" -or "06/18/2012"}
#>
$computername= Read-Host -prompt "what store? ex. OBSxxxxBH"
Invoke-Command -computername $computername -Credential $creds -scriptblock {
$targetpath="c:\some\path\here"
dir $targetpath | select-object lastwritetime,name | ForEach-Object {
    $results = New-Object PSObject -Property @{            
        ComputerName     = gc env:computername                 
        Time             = $_.lastwritetime
        Faulting_Program = $_.Name
    }  
    Write-Output $results
}} | select Computername, Time, Faulting_Program | Export-Csv "c:\WER_Results.csv" -NoTypeInformation

#| Select-Object ComputerName, Time, Error | 
