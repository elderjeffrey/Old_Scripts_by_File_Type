$path = "\\some\path\here"
del "\\some\path\here" -Force -ErrorAction SilentlyContinue
$adOpenStatic = 3
$adLockOptimistic = 3
$sourceQuery = "Select * from Version"
$objConnection = New-Object -comobject ADODB.Connection
$objRecordset = New-Object -comobject ADODB.Recordset

$objConnection.Open("Provider = Microsoft.Jet.OLEDB.4.0; Data Source = $path")
$objRecordset.Open($sourceQuery, $objConnection, $adOpenStatic, $adLockOptimistic)
$objRecordset.MoveFirst()
do {
$dbVersion = $objRecordset.Fields.Item("dbVersion").Value
if ($dbVersion) {
	$results = New-Object PSObject -Property @{ 
		ComputerName   = gc env:computername
		dbVersion       = $dbVersion
	} -WarningAction SilentlyContinue
	Write-Output $results
	#Write-Host $results
	}
	$objRecordset.MoveNext()
	} until ($objRecordset.EOF -eq $True)
$objRecordset.Close()
$objConnection.Close()