function get-RoutingComparison {
	[CmdletBinding()]
	param(
	  	[Parameter(Position=0,
	     Mandatory=$True,
         ValueFromPipeline=$True,
         ValueFromPipelineByPropertyName=$True)]
		[ValidateSet("Outback","Bonefish","Carrabbas","Flemings","Roys")]
    	[System.String]$Concept,
		[Parameter(Position=1, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String[]]$Store1,
		[Parameter(Position=2)]
		[ValidateNotNullOrEmpty()]
		[System.String[]]$Store2
	)
	
	begin {
		try {
			$savefile = [Environment]::GetFolderPath("Desktop");
			IF($Concept -eq "Outback"){$screenpath = "\\some\path\here";$workpath = "\\some\path\here"}
			elseif($Concept -eq "Bonefish"){$screenpath = "\\some\path\here";$workpath = "\\some\path\here"}
		 	elseif($Concept -eq "Carrabbas"){$screenpath = "\\some\path\here";$workpath = "\\some\path\here"}
			elseif($Concept -eq "Flemings"){$screenpath = "\\some\path\here";$workpath = "\\some\path\here"}
			$PrepCat= ((gc "$workpath\*PrepCategories.txt") -replace ',', '=') -join "`n" | ConvertFrom-StringData
			$Store1xmlpath = "$screenpath\$Store1\screens.xml";
			$Store2xmlpath = "$screenpath\$Store2\screens.xml";
			$Date=((gci $Store1xmlpath).LastWriteTime.ToShortDateString()).replace("/","-")
		}
		catch {
			$_.Exception.Message
		}
	}
	process {
		try {
			[xml]$Store1screensxml=(gc $Store1xmlpath)
			[xml]$Store2screensxml=(gc $Store2xmlpath)
			$S1 = ($Store1screensxml.SelectNodes("//Cell")|?{($_.prepcategory)-and($_.prepcategory -ne '2')}|%{
				$gprep1 = $_.prepcategory;
				[string]$subprepcat1 = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep1}).Name;
				[string]::concat($_.CellName,"_",$subprepcat1,"_",$_.InventoryNumber)})
				
			$S2 = ($Store2screensxml.SelectNodes("//Cell")|?{($_.prepcategory)-and($_.prepcategory -ne '2')}|%{
				$gprep2 = $_.prepcategory;
				[string]$subprepcat2 = ($PrepCat.GetEnumerator() | ?{$_.value -eq $gprep2}).Name;
				[string]::concat($_.CellName,"_",$subprepcat2,"_",$_.InventoryNumber)})
			
			$diff= diff $S1 $S2|%{if($_.SideIndicator -eq "<="){$_.InputObject;}}
			$diff|select -Unique|sort -Desc ;($diff|select -Unique|sort -Desc).count
		}
		catch {
		}
	}
	end {
		try {
		}
		catch {
		}
	}
}
Export-ModuleMember -Function get-RoutingComparison

New-Alias -Name grc -Value get-RoutingComparison -ErrorAction SilentlyContinue
if ($?) {
	Export-ModuleMember -Alias grc
}
				
