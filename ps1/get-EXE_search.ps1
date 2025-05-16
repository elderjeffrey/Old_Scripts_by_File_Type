$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
       $computername = gc env:computername
	   $a = gci "\\some\path\here"
       If ((Test-Path "\\some\path\here") -eq $False -or ($a).length -ne 613376) {
              $client = New-Object system.net.WebClient
              $client.DownloadFile("\\some\path\here", "\\some\path\here")
				$x = gci "\\some\path\here"
		        $results = New-Object PSObject -Property @{
				ComputerName  = $computername
				Reportsw_LengthPrior = $a.Length
				Reportsw_LengthAfter = $x.Length
				Reportsw_Version = $x.LastWriteTime.ToShortDateString()
				}
              Write-Output "File-copied $computername"
			  Write-Output $results
       } else {
              $x = gci "\\some\path\here"
              Write-Output "File-exists $($x.name) - $($x.length)   $computername"
       }
} | select ComputerName, Reportsw_LengthPrior, Reportsw_LengthAfter, Reportsw_Version | Export-Csv "\\some\path\here" -NoTypeInformation