#$computers = gc c:\all_P1_contorllers.txt
$master_exe_list = dir "some\path\here\*.exe"
Invoke-Command -computername cig1105P1 -Credential $creds -scriptblock {
	$files = dir "c:\SC\*.exe"
	foreach ($file in $files)  {
	IF ($file.LastWriteTime.ToShortDateString() -notmatch $master_exe_list.LastWriteTime.ToShortDateString()){
				
		$results = New-Object PSObject -Property @{            
			FileName      = $File.name
			LastWrite     = $file.LastWriteTime.ToShortDateString()
				}
		Write-Output $results

	}
}}| select FileName, LastWrite | Export-Csv c:\exe_file_compare.csv -NoTypeInformation
<#
Compare-Object $master_exe_list.lastwritetime.toshortdatestring() $files.lastwritetime.toshortdatestring() |
$results = New-Object PSObject -Property @{            
			FileName      = $Files.name
			LastWrite     = $file.LastWriteTime.ToShortDateString()
				}
		Write-Output $results | ft -AutoSize

	}
	#>