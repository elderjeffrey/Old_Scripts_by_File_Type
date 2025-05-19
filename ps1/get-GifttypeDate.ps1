$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -credential support -ErrorAction SilentlyContinue -ThrottleLimit 8 -scriptblock {
$a = dir "\\some\path\here"
$b = Test-Path "\\some\path\here"

if ($b) {
 $results = New-Object PSObject -Property @{
    ComputerName   = gc env:computername
	Gifttype_DAT   = $a.LastWriteTime.toshortdatestring()
	Giftcert_MDB   = $(dir "\\some\path\here").LastWriteTime.toshortdatestring()
	}
	} else {
 $results = New-Object PSObject -Property @{
    ComputerName   = gc env:computername
	Gifttype_DAT   = $a.LastWriteTime.toshortdatestring()
	}
	}
	  Write-Output $results
}| select ComputerName, Gifttype_DAT, Giftcert_MDB  | Export-Csv "\\some\path\here\file.csv" -NoTypeInformation