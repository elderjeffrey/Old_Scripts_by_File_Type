$computers = gc "\\some\path\here"
Invoke-Command -computername $computers -ThrottleLimit 8 -ErrorAction SilentlyContinue -scriptblock {
$result = New-Object PSObject -Property @{            
	ComputerName   = gc env:computername
	}
	#Write-Output $result
$path = "\\some\path\here"  
$bad = "MOM BC"
function get-files {dir $path | where {$_.Name -like ('130601*.tcm')} | sort -Property LastWriteTime | select -Last 1
					dir $path | where {$_.Name -like ('130602*.tcm')} | sort -Property LastWriteTime | select -Last 1
					dir $path | where {$_.Name -like ('130603*.tcm')} | sort -Property LastWriteTime | select -Last 1
					dir $path | where {$_.Name -like ('130604*.tcm')} | sort -Property LastWriteTime | select -Last 1
					dir $path | where {$_.Name -like ('130605*.tcm')} | sort -Property LastWriteTime | select -Last 1
					dir $path | where {$_.Name -like ('130606*.tcm')} | sort -Property LastWriteTime | select -Last 1
					dir $path | where {$_.Name -like ('130607*.tcm')} | sort -Property LastWriteTime | select -Last 1}

$files = get-files
Write-Output $result
$continue = 
foreach ($file in $files) {
	$temp = Import-Csv $file -Header ("a","b","c","d","e","f") | select d, e
	IF ($temp -and $temp2 -match $bad){
			$results = New-Object PSObject -Property @{            
			  File   = $file.name 
			  }
			  Write-Output $results
			  Write-Host $results
		      } else {
			  Write-Host (gc env:computername) $file has no errors
			  $continue = $false
			 }
			}
	#IF ($results) { Write-Output $result}
}| select ComputerName, File | Export-Csv c:\tcm_results.csv -NoTypeInformation