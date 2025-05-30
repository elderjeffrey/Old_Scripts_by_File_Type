$mypath = "\\some\path\here"
Get-ChildItem -Path $mypath -Filter 'TIP*' |
#    Select-Object -First 5 |
    foreach{
		$FileContent = Get-IniContent "$mypath\$_"
		IF ($FileContent["SHIFTS"].Keys){
			$props = @{
	            'Concept' = $_.Name.Substring(4, 1);
	            'UnitId' = $_.Name.Substring(6, 4);
				'Shifts' = "`"$($FileContent["SHIFTS"].Keys | %{$FileContent["SHIFTS"][$_]})`""
				'POOL1' = "`"$($FileContent["POOL1"].Keys | %{$FileContent["POOL1"][$_]})`""
				'POOL2' = "`"$($FileContent["POOL2"].Keys | %{$FileContent["POOL2"][$_]})`""
				'POOL3' = "`"$($FileContent["POOL3"].Keys | %{$FileContent["POOL3"][$_]})`""
				'POOL4' = "`"$($FileContent["POOL4"].Keys | %{$FileContent["POOL4"][$_]})`""
	        } 
		}else{
			$props = @{
	            'Concept' = $_.Name.Substring(4, 1);
	            'UnitId' = $_.Name.Substring(6, 4);
				'Shifts' = "No Shifts Designated-Uses Default"
				'POOL1' = "`"$($FileContent["POOL1"].Keys | %{$FileContent["POOL1"][$_]})`""
				'POOL2' = "`"$($FileContent["POOL2"].Keys | %{$FileContent["POOL2"][$_]})`""
				'POOL3' = "`"$($FileContent["POOL3"].Keys | %{$FileContent["POOL3"][$_]})`""
				'POOL4' = "`"$($FileContent["POOL4"].Keys | %{$FileContent["POOL4"][$_]})`""
	        }		
		}
        New-Object psobject -Property $props;
    } | select Concept,UnitId,Shifts,POOL1,POOL2,POOL3,POOL4 |
	Export-Csv -Path "\\some\path\here" -NoTypeInformation -ErrorAction SilentlyContinue