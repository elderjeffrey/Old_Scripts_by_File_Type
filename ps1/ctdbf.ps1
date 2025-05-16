$folder = Get-ChildItem c:\ctdbf
$total = $folders.count
$oldest = Get-ChildItem c:\ctdbf | select name -First 1
$size = (Get-ChildItem c:\ctdbf -recurse | Measure-Object -property length -sum)
$truesize = "{0:N2}" -f ($size.sum / 1GB) + "GB"     
echo "$site,$total,$truesize,$oldest" | out-file c:\test.txt -append 