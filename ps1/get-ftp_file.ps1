$Credentials = Get-Credential
$file = Read-Host -prompt "What File?"
Set-FTPConnection -Credentials $Credentials -Server ftps://Outback@68.15.45.63 -EnableSsl -ignoreCert -UsePassive
Get-FTPItem -path "ftps://Outback@68.15.45.63///key upgrades/$file" -LocalPath c:\ -Confirm
