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
			'EliminateCashoutZeroing' = $nbxml.ItemMaintenance.FieldsAndFlags.RestaurantMiscCashouts2.EliminateCashoutZeroing;
			'TipPoolPercent' = $nbxml.ItemMaintenance.FieldsAndFlags.TipPoolPercentSetup.TipPoolPercent;
			'IncludeTotalSales' = $nbxml.ItemMaintenance.FieldsAndFlags.TipPoolPercentSetup.IncludeTotalSales;
			'IncludeSalesTax' = $nbxml.ItemMaintenance.FieldsAndFlags.TipPoolPercentSetup.IncludeSalesTax;
			'ManuallyEnterContribution' = $nbxml.ItemMaintenance.FieldsAndFlags.TipPoolPercentSetup.ManuallyEnterContribution;
			'ElimCashoutZero' = $nbxml.ItemMaintenance.FieldsAndFlags.UserPrivilegeCodes.ElimCashoutZero;
			'LockedAfterCashout' = $nbxml.ItemMaintenance.FieldsAndFlags.UserPrivilegeCodes.LockedAfterCashout;
        }

        New-Object psobject -Property $props;
    } | select SourceFilename,LastWriteTime,Concept,UnitId,EliminateCashoutZeroing,TipPoolPercent,IncludeTotalSales,IncludeSalesTax,ManuallyEnterContribution,ElimCashoutZero,LockedAfterCashout |
	Export-Csv -Path "\\some\path\here" -NoTypeInformation