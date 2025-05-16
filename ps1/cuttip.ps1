$path="some\path\here"
$log="some\path\here\011013.txt"
$tips=Get-Content $path\us011013.tip -TotalCount 27
Write-Output $tips | Out-File $LOG