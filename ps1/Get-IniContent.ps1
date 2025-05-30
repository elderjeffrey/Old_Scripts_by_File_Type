$mypath = '\\some\path\here';
Get-ChildItem -Path $mypath -Filter 'TIP*' |
#    Select-Object -First 5 |
    foreach{
		$FileContent = Get-IniContent "$mypath\$_"
		IF ($FileContent["SHIFTS"].Keys){
			$props = @{
	            'Concept' = $_.Name.Substring(4, 1);
	            'UnitId' = $_.Name.Substring(6, 4);
				'Shifts' = "`"$($FileContent["SHIFTS"].Keys | %{$FileContent["SHIFTS"][$_]})`""
	        }
		}else{
			$props = @{
	            'Concept' = $_.Name.Substring(4, 1);
	            'UnitId' = $_.Name.Substring(6, 4);
				'Shifts' = "No Shifts Designated"
	        }		
		}
        New-Object psobject -Property $props;
    } | select Concept,UnitId,Shifts |
	Export-Csv -Path "\\some\path\here" -NoTypeInformation