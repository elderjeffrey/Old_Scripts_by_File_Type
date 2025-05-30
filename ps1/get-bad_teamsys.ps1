$computers = gc some\path\here\file.txt
Invoke-Command -computername $computers -Credential $creds -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
$teams2syschk = gc some\path\here\TEAMS2.SYS
$teamssyschk = gc some\path\here\TEAMS.SYS
IF ($teamssyschk -notmatch $teams2syschk) {
$a = dir c:\SC\TEAMS.SYS
$results = New-Object -TypeName PSObject
$results | Add-Member -MemberType noteproperty -Name 'ComputerName' -Value (gc env:computername)
$results | Add-Member -MemberType noteproperty -Name 'Bad_File' -Value (($a).name + "_" + ($a).LastWriteTime.toshortdatestring())
} else {
write-host (gc env:computername) "Teams.sys matches Teams2.sys"
}
Write-Output $results
}| select ComputerName, Bad_File | Export-Csv c:\Teams_chk.csv -NoTypeInformation