$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -Credential $creds -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {

$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
$SearchResult = $UpdateSearcher.Search("IsAssigned=1 and IsHidden=0 and IsInstalled=0")

	$results = New-Object PSObject -Property @{            
		ComputerName  = gc env:computername 
		Total         = $($SearchResult.updates.count)
		Critical      = $($SearchResult.updates | where {$_.MsrcSeverity -eq "Critical"}).count
		Important     = $($SearchResult.updates | where {$_.MsrcSeverity -eq "Important"}).count
		Other         = $($SearchResult.updates | where {$_.MsrcSeverity -eq $null}).count
			}
		Write-Output $results
		#Write-Host $results | Format-Table -Expand ComputerName, Total, Critical, Important, Other -AutoSize
}| select ComputerName, Total, Critical, Important, Other | Export-Csv '\\some\path\here' -NoTypeInformation





<#
$update = new-object -com Microsoft.update.Session
$searcher = $update.CreateUpdateSearcher()
$pending = $searcher.Search("IsAssigned=1 and IsHidden=0 and IsInstalled=0")
#>

<#
#Matrix Results for type of updates that are needed
$Critical = $SearchResult.updates | where { $_.MsrcSeverity -eq "Critical" }
$important = $SearchResult.updates | where { $_.MsrcSeverity -eq "Important" }
$other = $SearchResult.updates | where { $_.MsrcSeverity -eq $null }
#>
<#
#Write Results
Write-Host "total=$($SearchResult.updates.count)"
Write-Host "critical=$($Critical.count)"
Write-Host "important=$($Important.count)"
Write-Host "other=$($other.count)"
#>