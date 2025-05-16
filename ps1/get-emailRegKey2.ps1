Import-Module psremoteregistry
$computer = "localhost"
### Binary information to be injected
$data = Get-Content '\\some\path\here'

Invoke-Command -ComputerName $computer -ErrorAction SilentlyContinue -ScriptBlock {
$UserName = (Get-WmiObject Win32_ComputerSystem).UserName
$Principal = New-Object System.Security.Principal.NTAccount($UserName)
$sr = $Principal.Translate([System.Security.Principal.SecurityIdentifier]).Value
$sb = Get-ChildItem "Registry::HKU\$sr\" -Recurse -ErrorAction SilentlyContinue | where {$_.Property -eq ""}
$fullKeys = $sb | Select-Object Name -ExpandProperty Name
$fullKeys = $fullKeys | ForEach-Object {$_.Substring(58)}
foreach ($step in $fullKeys) {
$sb2 = {param($sr) Set-RegBinary -ComputerName $computer -Hive CurrentUser -Key $step -Value "" -Data $data -force}}}

Get-RegBinary -computername localhost -hive CurrentUser -Key '\\some\path\here' -Value ""
Get-ItemProperty 'HKCU:\some\path\here'