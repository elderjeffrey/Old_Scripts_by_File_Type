function get-removeside2 {
[CmdletBinding()]
param(
	[Parameter(ValueFromPipeline=$True,
	  ValueFromPipelineByPropertyName=$True)]
    [string[]]$ItemNumber)
$exports = "\\some\path\here"
$Stores = gci $exports
$i=0
foreach($Store in $Stores){
	$i++
	[int]$Pct1=(($i/$Stores.count)*100)
	Write-Progress -activity “Removing Side-II modifiers from requested Item Numbers” -status “$Store” -CurrentOperation "$Pct1% complete"
	$xmlpath = "$exports\$Store\file.xml"
	[xml]$filexml=(gc $xmlpath)
	foreach($Item in $ItemNumber){
	($filexml.SelectNodes("//Cell")|?{($_.inventorynumber -eq $Item)}).optiongroup|?{$_.ScreenNumber -eq '114'}|%{$_.ParentNode.RemoveChild($_)}
	$filexml.save($xmlpath)}}}
Export-ModuleMember -Function get-removeside2

New-Alias -Name grs2 -Value get-removeside2 -ErrorAction SilentlyContinue
if ($?) {
	Export-ModuleMember -Alias grs2
}
	