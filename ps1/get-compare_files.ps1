$Correctfiles = Get-ChildItem '\\some\path\here' | ?{!$_.psiscontainer}
#$computers = gc "\\some\path\here\all_P1_contorllers.txt
#Invoke-Command -computername $computers -Credential support -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
$SuspectFiles = Get-ChildItem "\\some\path\here" | ?{!$_.psiscontainer}
$BadFiles = Compare-Object ($Correctfiles) ($SuspectFiles) -Property Name, Length, LastWriteTime -ExcludeDifferent

            $results = New-Object PSObject -Property @{            
			ComputerName  = gc env:computername 
			Bad_Files     = $BadFiles
			}
		Write-Output $results
#}| select ComputerName, Bad_Files |Export-Csv '\\some\path\here\file.csv' -NoTypeInformation