        $ButtonName="*"
		$Store=1000
		$GoodPrepCategory='7'
		$ScreenNumber=33
		$continue = $true
        $Date=("$((date).month)" + "$((date).day)" + "$((date).year)")
        $CurStore = New-Object -TypeName PSObject -Property @{Store=$Store} 
	    $File = "\\some\path\here"
		$screensxml = new-object System.Xml.XmlDocument
		$screensxml.Load($File)

		$Orderscreens = $screensxml.Screens.NewScreens.OrderScreen | ? {$_.Cell.CellName -like $ButtonName}
		foreach($Screen in $Orderscreens) {
    		foreach($Record in ($Screen.Cell | ? {$_.CellName -like $ButtonName})) {
    			$results = New-Object -TypeName PSObject -Property @{
					'ScreenNumber'= $Screen.ScreenNumber
					'cellnumber'= $Record.cellnumber
					'cellname'= $Record.cellname
					'inventorynumber'= $Record.inventorynumber
					'prepcategory'= $Record.PrepCategory}
				Write-Output $results | select screennumber,cellnumber,cellname,inventorynumber,prepcategory | ft -AutoSize
			} 
		}
		

        $Orderscreens= $screensxml.Screens.NewScreens.OrderScreen | ? {$_.Cell.CellName -like $ButtonName}
            $Screens= New-Object -TypeName PSObject -Property @{ScreenNumber=$OrderScreens.ScreenNumber}
            foreach ($screen in $OrderScreens) {
            $Records=$Screen.Cell | ? {$_.CellName -like $ButtonName}
            $Records | % {IF(!($_.PrepCategory -eq $GoodPrepCategory)) {IF($_.PrepCategory=$GoodPrepCategory) {$changesmade='changesmade'}}}
            Write-Output $Screen $Records | select ScreenNumber,cellnumber,cellname,inventorynumber,prepcategory | ft -AutoSize}
	        Write-Output $Records2 | select ScreenNumber,cellnumber,inventorynumber,cellname,prepcategory | ft -AutoSize

foreach($Screen in $Orderscreens) {
            $a=$Screen.ScreenNumber
            
            Write-Output $a | select screennumber | ft -AutoSize
		}