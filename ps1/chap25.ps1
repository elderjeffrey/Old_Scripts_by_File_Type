Function Get-OSInfoWorker {
param([string]$name,[string]$logfile)
	Try {
	$continue = $true
	$bios=gwmi win32_bios -ComputerName $name -ErrorAction Stop
	} catch {
		if ($logfile -ne '') { $name | Out-File $logfile -Append }
	$continue = $false
	    }
	if ($continue) {
	$os=gwmi win32_operatingsystem -ComputerName $name
	$obj = new-object -typename psobject
	$obj | Add-Member -MemberType noteproperty -Name 'Computername' -Value $name
	$obj | Add-Member -MemberType noteproperty -Name 'OSBuild' -Value $($os.BuildNumber)
	$obj | Add-Member -MemberType noteproperty -Name 'BiosSerial' -Value $($bios.SerialNumber)
	$obj | Add-Member -MemberType noteproperty -Name 'LastBoot'  -Value $os.ConvertToDateTime($os.LastBootUpTime)
	Write-output $obj
	}
}
<#
.SYNOPSIS
Retrieves key information from the specified computer(s)
.DESCRIPTION
Get-OSInfo uses WMI to retrieve information from from the WIN32_OpertingSystem and the WIN32_Bios classes. The result is a combined object, included translated date/time information for the computer's most recent restart
.PARAMETER computername
The computer name, or names, to query
.PARAMETER logfile
Include this parameter to have failed computer names logged to a file. Specify the filename as the value for this parameter
.EXAMPLE
Assuming names.txt contains one computer name per line:
Get-Content names.txt | Get-OSInfo -log c:\errors.txt
.EXAMPLE
Assuming the ActiveDirectory module is available, this example retrieves information from all computers in the domain:
Get-ADComputer -filter * | Select -expand name | Get-OSInfo
.EXAMPLE
Just use a single computer name:
Get-OSInfo -computername localhost
#>
Function Get-OSInfo {
    [CmdletBinding()]
PARAM(
    [Parameter(Mandatory=$True,
           ValueFromPipeline=$True,
           ValueFromPipelineByPropertyName=$True)]
    [Alias('host')]
    [string[]]$computername,
    [string]$logfile = ''
)
Begin{
	if ($logfile -ne '') {
	del -Path $logfile -ErrorAction SilentlyContinue
	}
}
Process{
    foreach ($name in $computername) {
        Get-OSInfoWorker $name $logfile
        }
      }
End{}
}

New-Alias goi Get-OSInfo
Export-ModuleMember -Function Get-OSInfo
Export-ModuleMember -Alias goi