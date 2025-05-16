$computers = gc some\path\here\file.txt
Invoke-Command -ComputerName $computers -Credential $creds -ThrottleLimit 8 -ErrorAction SilentlyContinue -ScriptBlock {
      $bigtipfiles = dir "some\path\here\*.tip" | where-object { $_.Length -gt 1GB } | ForEach-Object {
      $results = New-Object PSObject -Property @{
	  		ComputerName  = gc env:computername
            BigTipName = $_.name
            BigTipSize = ($_.Length / 1GB)
      		}
      Write-Output $results
      } 
}| select ComputerName,BigTipName,BigTipSize | Export-Csv "c:\bigtipfiles.csv" –NoTypeInformation
