$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -Credential $creds -ThrottleLimit 8 -scriptblock {
	$ComputerBrowser = gwmi win32_service -Filter "name='Browser'"
	IF ($ComputerBrowser.StartMode -match "Manual"){
		$ComputerBrowser.ChangeStartMode('Automatic')
		$ComputerBrowser2 = gwmi win32_service -Filter "name='Browser'"
		
		$ServiceInfo = New-Object PSObject -Property @{            
			ComputerName     = gc env:computername 
			Service          = $ComputerBrowser2.Name
			FormerStartMode  = $ComputerBrowser.StartMode
			CurrentStartMode = $ComputerBrowser2.StartMode
			State            = $ComputerBrowser2.State
			Status           = $ComputerBrowser2.Status
				}
		Write-Output $ServiceInfo
	}
}| select ComputerName, Service, FromerStartMode, CurrentStartMode, State, Status | Export-Csv c:\ComputerBrowserService_results.csv -NoTypeInformation