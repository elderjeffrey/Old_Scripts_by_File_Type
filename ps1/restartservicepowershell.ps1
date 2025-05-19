$service= Read-Host -Prompt "restart which service?"
$computername= Read-Host -prompt "what store?"
$cred= Get-Credential 
$svc=gwmi win32_service  -ComputerName $computername -Credential $cred -filter $service
gwmi win32_service -filter "name='$service'" -comp $computername | Select-Object "state"
$svc.StopService().returnvalue 
gwmi win32_service -filter "name='$service'" -comp $computername | Select-Object "state"
$svc.StartService().returnvalue
gwmi win32_service -filter "name='$service'" -comp $computername | Select-Object "state" 