$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -credential $creds -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
del "\\some\path\here" -Force -ErrorAction SilentlyContinue
$path = "\\some\path\here"
$Month = (Get-Date).month
$Year = (Get-Date).year
$dateQuery = "$month" + "/*/" + "$Year"

$adOpenStatic = 3
$adLockOptimistic = 3
$sourceQuery = "Select * from CardsHistory"
$objConnection = New-Object -comobject ADODB.Connection
$objRecordset = New-Object -comobject ADODB.Recordset

$objConnection.Open("Provider = Microsoft.Jet.OLEDB.4.0; Data Source = $path")
$objRecordset.Open($sourceQuery, $objConnection, $adOpenStatic, $adLockOptimistic)
$objRecordset.MoveFirst()
do {
$TranDate =  ($objRecordset.Fields.Item("TranDate").Value).toshortdatestring()
$Amount = $objRecordset.Fields.Item("Amount").Value
$EnterType = $objRecordset.Fields.Item("EnterType").Value

if (($EnterType -match '4') -and ($TranDate -like $dateQuery)) {
	$results = New-Object PSObject -Property @{ 
		ComputerName   = gc env:computername
		TranDate       = $TranDate
		Amount         = $Amount
		EnterType      = $EnterType
	} -WarningAction SilentlyContinue
	Write-Output $results
	#Write-Host $results
	}
	$objRecordset.MoveNext()
	} until ($objRecordset.EOF -eq $True)
$objRecordset.Close()
$objConnection.Close()
}| select ComputerName, TranDate, Amount, EnterType | Export-Csv c:\Manually_Entered_Gcard_results.csv -NoTypeInformation