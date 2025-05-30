﻿<#
.SYNOPSIS
Get-DiskInventory retrieves logical disk information from one or
more computers.
.DESCRIPTION
Get-DiskInventory uses WMI to retrieve the Win32_LogicalDisk
instances from one or more computers. It displays each disk's
drive letter, free space, total size, and percentage of free
space.
.PARAMETER computername
The computer name, or names, to query. Default: Localhost.
.PARAMETER drivetype
The drive type to query. See Win32_LogicalDisk documentation
for values. 3 is a fixed disk, and is the default.
.EXAMPLE
Get-DiskInventory -computername SERVER-R2 -drivetype 3
#>



param (
	$computername = 'localhost',
	$drivertype = 3
)
Get-WmiObject -class Win32_LogicalDisk -computername $computername -filter "drivetype=$drivetype" |
 Sort-Object -property DeviceID |
 Format-Table -property DeviceID,
     @{l='FreeSpace(MB)';e={$_.FreeSpace / 1MB -as [int]}},
     @{l='Size(GB)';e={$_.Size / 1GB -as [int]}},
     @{l='%Free';e={$_.FreeSpace / $_.Size * 100 -as [int]}}
