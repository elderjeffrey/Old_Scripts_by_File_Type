### List of all BH PCs
$computers = get-content "\\some\path\here"
Import-Module psremoteregistry
### Just one pc for testing
$computer = 'localhost'

### Binary information to be injected
$data = Get-Content "\\some\path\here"

### Loop
foreach ($comp in $computers) {
### Get SID logged user
$sr = {
       $UserName = (Get-WmiObject Win32_ComputerSystem).UserName
       $Principal = New-Object System.Security.Principal.NTAccount($UserName)
       $Principal.Translate([System.Security.Principal.SecurityIdentifier]).Value
}

$SID = Invoke-Command -ComputerName $computer -ScriptBlock $sr

$sb = {param($SID) Get-ChildItem "Registry::HKU\$SID\" -Recurse -ErrorAction SilentlyContinue | where {$_.Property -eq "001f662a"}}
$fullKeys = Invoke-Command -ComputerName $computer -ScriptBlock $sb -ArgumentList $SID | Select-Object Name -ExpandProperty Name
$fullKeys = $fullKeys | ForEach-Object {$_.Substring(58)}

### Set the key for all locations on the PC
foreach ($step in $fullKeys) {
      $sb2 = {param($SID) Set-RegBinary -ComputerName $computer -Hive CurrentUser -Key $step -Value TestKey -Data $data -force}}}
