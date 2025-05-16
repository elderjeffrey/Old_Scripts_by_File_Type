function get-MDS_Mappingsworker {
	param($PLU,$File,$Concept,$EP,$Date,$savefile)
	$mdsexport=Import-Csv "$EP$File"
	$results=foreach($p in $plu){$mdsexport|?{$_.PLU_NUMBER -eq $p}}
	$results|export-csv -Path "$savefile\MDS_Mappings $Concept $Date.csv" -NoTypeInformation
}
function get-MDS_Mappings{
	[CmdletBinding()]
		param(
    	[Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
		[ValidateSet("Outback","Bonefish","Carrabbas","Flemings")]
    	[string]$Concept,
		[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
		[System.String[]]
		$File,
		[Parameter(Mandatory=$False,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
		[System.String[]]
		$PLU
	)
	begin {
		$EP="\\some\path\here"
		$Date=$(Get-Date -f MMddyy)
		$savefile = [Environment]::GetFolderPath("Desktop")
		}
	process {get-MDS_Mappingsworker $PLU $File $Concept $EP $Date $savefile}
	end {}
}

Export-ModuleMember -Function get-MDS_Mappings
New-Alias -Name mdsmap -Value get-MDS_Mappings -ErrorAction SilentlyContinue
Export-ModuleMember -Alias mdsmap