#$computers = gc "\\some\path\here"
$master_exe_list = dir c:\compare_exe
$files = Import-Csv -Path "\\some\path\here" | select name
Invoke-Command -computername "" -Credential $creds -scriptblock {

foreach ($file in $Files) {
	$a = dir "\\some\path\here" | ? {$_ -match $file}}

	$files = dir "\\some\path\here"
	[regex] $master_exe_list_regex = ‘(?i)^(‘ + (($master_exe_list |foreach {[regex]::escape($_)}) –join “|”) + ‘)$’
	$master_exe_list -match $files_regex
	$files -match $master_exe_list_regex
	($master_exe_list | ? {$files -notcontains $_}).count
	($files | ? {$master_exe_list -notcontains $_}).count
	Compare-Object $master_exe_list $Files -Property 'Name','LastWriteTime' -PassThru
	IF (($file).LastWriteTime.ToShortDateString() -notmatch ($master_exe_list).LastWriteTime.ToShortDateString()){
				
		$results = New-Object PSObject -Property @{            
			FileName      = $file.name
			LastWrite     = $file.LastWriteTime.ToShortDateString()
				}
		Write-Output $results
}}| select FileName, LastWrite | Export-Csv "\\some\path\here" -NoTypeInformation
<#
 |
$results = New-Object PSObject -Property @{            
			FileName      = $Files.name
			LastWrite     = $file.LastWriteTime.ToShortDateString()
				}
		Write-Output $results | ft -AutoSize

	}
	#>