[CmdletBinding()]
param
(
    [Parameter(Position=0,Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [ValidateSet("Outback","Bonefish","Carrabbas","Flemings")]
    [ValidateNotNullOrEmpty()]
    [string]$Concept,
    [Parameter(Position=1,Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [ValidateNotNullOrEmpty()]
    [string[]]$StoreNumber,
    [Parameter(Position=2,Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
    [string]$Covers
)
foreach ($store in $StoreNumber)
{
    try
    {
        $XmlPath = [string]::concat("\\some\path\here\",$Concept,"\Exports\",$store,"\file.xml");
        $items = [xml](gc $XmlPath);
        $items.Itemmaintenance.MenuItem | %{$_.covers=$Covers};
        $items.Save($XmlPath);
        $items.Itemmaintenance.MenuItem | %{$_.covers};
    }
    catch
    {
        $_.Exception.Message
    }
}
