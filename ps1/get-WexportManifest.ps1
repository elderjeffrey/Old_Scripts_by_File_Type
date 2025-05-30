$mypath = "\\some\path\here";
Get-ChildItem -Path $mypath -Filter 'file*' |
#    Select-Object -First 5 | 
    foreach { 
        $nbxml = [xml]((Get-Content $_.fullname -Raw).Replace("`0",""));

        $props = @{
            'SourceFilename' = $_.Name;
            'LastWriteTime' = $_.LastWriteTime;
            'Concept' = $_.Name.Substring(4, 1);
            'UnitId' = $_.Name.Substring(6, 4);
            'Index' = $nbxml.ItemMaintenance.FieldsAndFlags.HardwareSetupTerminalStations.Indexes;
            'Location' = $nbxml.ItemMaintenance.FieldsAndFlags.HardwareSetupTerminalStations.Location;
            'MenuScreensSetupTimesAndShifts' = "`"$($nbxml.ItemMaintenance.FieldsAndFlags.MenuScreensSetupTimesAndShifts.EndofShifts)`"";
			'MenuAssign0' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign0;
			'MenuAssign1' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign1;
			'MenuAssign2' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign2;
			'MenuAssign3' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign3;
			'MenuAssign4' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign4;
			'MenuAssign5' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign5;
			'MenuAssign6' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign6;
			'MenuAssign7' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign7;
			'MenuAssign8' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign8;
			'MenuAssign9' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign9;
			'MenuAssign10' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign10;
			'MenuAssign11' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign11;
			'MenuAssign12' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign12;
			'MenuAssign13' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign13;
			'MenuAssign14' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign14;
			'MenuAssign15' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign15;
			'MenuAssign16' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign16;
			'MenuAssign17' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign17;
			'MenuAssign18' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign18;
			'MenuAssign19' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.MenuAssign19;
			'FastOrderMenu0' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu0;
			'FastOrderMenu1' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu1;
			'FastOrderMenu2' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu2;
			'FastOrderMenu3' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu3;
			'FastOrderMenu4' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu4;
			'FastOrderMenu5' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu5;
			'FastOrderMenu6' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu6;
			'FastOrderMenu7' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu7;
			'FastOrderMenu8' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu8;
			'FastOrderMenu9' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu9;
			'FastOrderMenu10' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu10;
			'FastOrderMenu11' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu11;
			'FastOrderMenu12' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu12;
			'FastOrderMenu13' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu13;
			'FastOrderMenu14' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu14;
			'FastOrderMenu15' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu15;
			'FastOrderMenu16' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu16;
			'FastOrderMenu17' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu17;
			'FastOrderMenu18' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu18;
			'FastOrderMenu19' = $nbxml.ItemMaintenance.FieldsAndFlags.MenuTerminalAssignments.FastOrderMenu19;
        }

        New-Object psobject -Property $props;
    } | select SourceFilename,LastWriteTime,Concept,UnitId,Index,Location,MenuScreensSetupTimesAndShifts,MenuAssign0,MenuAssign1,MenuAssign2,MenuAssign3,MenuAssign4,MenuAssign5,MenuAssign6,MenuAssign7,MenuAssign8,MenuAssign9,MenuAssign10,MenuAssign11,MenuAssign12,MenuAssign13,MenuAssign14,MenuAssign15,MenuAssign16,MenuAssign17,MenuAssign18,MenuAssign19,FastOrderMenu0,FastOrderMenu1,FastOrderMenu2,FastOrderMenu3,FastOrderMenu4,FastOrderMenu5,FastOrderMenu6,FastOrderMenu7,FastOrderMenu8,FastOrderMenu9,FastOrderMenu10,FastOrderMenu11,FastOrderMenu12,FastOrderMenu13,FastOrderMenu14,FastOrderMenu15,FastOrderMenu16,FastOrderMenu17,FastOrderMenu18,FastOrderMenu19 |
	Export-Csv -Path "\\some\path\here" -NoTypeInformation