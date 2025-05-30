$workpath = "\\some\path\here";
$siteworkpath = "\\some\path\here";
if(test-path "$siteworkpath\file.csv") {del "$siteworkpath\file.csv" -ErrorAction SilentlyContinue};
$endpath = "\\some\path\here"
if(test-path "$endpath\$foodtier\$filename\FLM*.txt"){del "$endpath\$foodtier\$filename\*.txt"}
$xlCSV=6;
$xlsx="$siteworkpath\file.xlsx";
$csv="$siteworkpath\file.csv";
$xl= New-Object -com "Excel.Application";
$wb=$xl.workbooks.open($xlsx);
$wb.SaveAs($csv,$xlCSV);
$xl.displayalerts=$False;
$xl.quit();
[Void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($xl);
$sites = Import-Csv "$siteworkpath\file.csv";
$header = "PLU,ItemName,Major,Minor,,Price1,Price2,,,AltID,,,,,,,,,,,,,";
$files=0
$allfiles = gci $workpath -Filter "*.sys"
$allfiles |%{$files++
			 [int]$Pct1=(($files/$allfiles.count)*100)
			 Write-Progress -activity “Stores” -status “Hold Please...” -CurrentOperation "$Pct1% complete";
			 $items = ((((Get-Content $_.fullname -Raw).Replace("`0","")).Insert(0,"`n")).Insert(0,$header));
			 $filename = $_.Name.Substring(6,4);
			 $filedate = $_.Name.Substring(11,8);
			 $foodtier = ($sites | ?{$_.site -eq $filename}).Food_Tier;
			 $tempfile = "$endpath\$foodtier\$filename\FLM_$filename Items_$filedate.txt";
			 $items | out-File $tempfile;
			 $newitems = Import-Csv $tempfile -WarningAction SilentlyContinue| select PLU,ItemName,Major,Minor,Price1,Price2,Price3,AltID;
			 $filepathredirect = "$endpath\$foodtier\$filename\FLM_$filename file_$filedate.csv";
			 $newitems | Export-Csv $filepathredirect -Force -NoTypeInformation}