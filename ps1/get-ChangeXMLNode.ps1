$File = "\\some\path\here\file.XML"
$screensxml = new-object System.Xml.XmlDocument
$screensxml.Load($File)
$a = "8,12,13,14,17,20,45,46"
$b = "8,12,13,14,17,45,46"
IF ($screensxml.SelectNodes("//Cells") | ? {$_.innerxml -eq $a}) {
($screensxml.SelectNodes("//Cells") | ? {$_.innerxml -eq $a}) | % {$_.'#text'=$b}
	IF ($screensxml.SelectNodes("//Cells") | ? {$_.innerxml -eq $b}) {
	Write-Host "good to go"
	} else { 
	Write-Host "text did not replace"
	}
} else {
Write-Host "no match"}
<#
((Select-Xml -Xml $screensxml -XPath '//Cell/OptionGroup').Node.Cells | ? {$_ -eq $a})
((Select-Xml -Xml $screensxml -XPath '//Cell/OptionGroup').Node.Cells | ? {$_ -eq $a}).Replace($a, $b)
$screensxml.Save($File)
$screensxml.Save($File)

$Filecheck = '"\\some\path\here\file.XML"
$screensxmlcheck = new-object System.Xml.XmlDocument
$screensxmlcheck.Load($Filecheck)
((Select-Xml -Xml $screensxmlcheck -XPath '//Cell/OptionGroup').Node.Cells | ? {$_ -eq $a})
#>