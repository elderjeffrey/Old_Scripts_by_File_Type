$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -credential	$creds -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
$month = ((Get-Date).tostring("u")).Substring(5,2)
$files = gci "\\some\path\here" | where {$_.name -like ('L13' + $month + '*.*')}
try {
$continue = $true
foreach ($file in $files) {
$SearchText1 = gc "\\some\path\here\$file" | select-string -Pattern "switching to dial" -Context 40
$SearchText2 = gc "\\some\path\here\$file" | Select-String -Pattern "NO DIALTONE"  -Context 40
$SearchText3 = gc "\\some\path\here\$file" | Select-String -Pattern "No modems available" -Context 40
$results = new-object -typename psobject
$results | Add-Member -MemberType noteproperty -Name 'Computername' -Value (gc env:computername)
IF ($SearchText1) {$results | Add-Member -MemberType noteproperty -Name 'Switching_to_Dial' -Value $file}
IF ($SearchText2) {$results | Add-Member -MemberType noteproperty -Name 'No_Dialtone' -Value $file}
IF ($SearchText3) {$results | Add-Member -MemberType noteproperty -Name 'No_Modems_Available'  -Value $file}
}
} catch {
IF ($SearchText1 = $null) {
Write-Host $file from (gc env:computername) has no errors -ForegroundColor Green
$continue = $false}
IF ($SearchText2 = $null) {
Write-Host $file from (gc env:computername) has no errors -ForegroundColor Green
$continue = $false}
IF ($SearchText3 = $null) {
Write-Host $file from (gc env:computername) has no errors -ForegroundColor Green
$continue = $false}
}
IF ($continue) {Write-Output $results}
}| select ComputerName, Switching_to_Dial, No_DialTone, No_Modems_Available | Export-Csv c:\ModemFailure_results.csv -NoTypeInformation