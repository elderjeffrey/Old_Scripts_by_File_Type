$mypath = "\\some\path\here";
gci $mypath -Filter 'file*' |
#Select-Object -First 5 | 
    %{ 
        $nbxml = [xml]((Get-Content $_.fullname -Raw).Replace("`0",""));
        $props = 
			@{
            	'UnitId' = $_.Name.Substring(10, 4);
				'MiscTables' = $nbxml.ItemMaintenance.FieldsAndFlags.LoginScreen1.UseNumberInPartyWithMiscTables999
        	 }
        New-Object psobject -Property $props;
     } | select UnitId,MiscTables |
#ft -AutoSize
	Export-Csv -Path "\\some\path\here" -NoTypeInformation