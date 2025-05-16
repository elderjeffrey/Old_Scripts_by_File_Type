#######################################################
#-----                   START                   -----#
#######################################################

#######################################################
#----- 		       define variables              -----#
#######################################################

$log = "some\path\here\actioneeded.log"
$path = "some\path\here"
$TargetFolder = "some\path\here"
$failurestartcig = "failurestart.mode.cig*"
$failurestartbfg = "failurestart.mode.bfg*"
$failurestartflm = "failurestart.mode.flm*"
$failurestartobs = "failurestart.mode.obs*"
$niteproc = "niteproc.end.*"
$lastposisync = "lastposisync.line.*"
$failurestart = "failurestart.mode.*"
$posbackup = "posbackup.term.*"
$redncopylog = "redncopy.log.*"
$redncopymissing = "redncopylog.missing.*"
$spcinv = "spcinv.*"
$backmode = "backmode.found.*"
$screens = "screens.*"
$LastWrite = (Get-Date).ToShortDateString()
$syncdate = (Get-Date).adddays(-1).ToShortDateString()
$failpass = "FailureStartMode=PASSWORD"
$storedata5test = import-csv $path\StoreData5test.csv

######################################################
#-----       compare redncopylog.missing        -----#
######################################################
$storedata5test |
Select-object "unit","abrconcept" |
foreach-object {$($_.abrconcept + "_" + $_.unit)} | 
foreach-object {
$site = $_
$redfile = "redncopylog.missing." + $site
$redncopy = Get-ChildItem $TargetFolder -Include $redncopymissing -Recurse | where {$_.name -eq "$redfile"}
	if ($redncopy -ne $null)
		{
		Write-Host  "ACTION NEEDED for $site!" -ForegroundColor "DarkGreen"
		Write-Output "ACTION NEEDED! REDNCOPY not created for $site" |
		out-file $log -Append
		Remove-Item $redncopy | Out-Null		
		}
	else
		{
		write-host "$site has created redncopy successfully" -ForegroundColor "Red"
		}
}
#######################################################
#-----         compare lastposisync.mode         -----#
#######################################################
$storedata5test|
Select-object "unit","abrconcept" |
foreach-object {$($_.abrconcept + "_" + $_.unit)} | 
foreach-object {
$site = $_
$syncfile = "lastposisync.line." + $site
$posisync = Get-ChildItem $TargetFolder -Include $lastposisync -Recurse | where {$_.name -eq "$syncfile"}
	if ($posisync.lastwritetime.ToShortDateString() -eq $syncdate)
		{
		write-host "Deleting File $posisync, $site has completed running posisync" -ForegroundColor "Red"
        Remove-Item $posisync | Out-Null
		}
	else
		{
		Write-Host  "ACTION NEEDED for $site!" -ForegroundColor "DarkGreen"
		Write-Output "ACTION NEEDED! POSISYNC has incorrect date for $site" |
		out-file $log -Append
		Remove-Item $posisync | Out-Null
		}
}
########################################################	
#-----           compare niteproc.end             -----#
########################################################
$storedata5test |
Select-object "unit","abrconcept" |
foreach-object {$($_.abrconcept + "_" + $_.unit)} | 
foreach-object {
$site = $_
$nitefile = "niteproc.end." + $site
$nites = Get-Childitem $TargetFolder -Include $niteproc -Recurse | where {$_.name -eq "$nitefile"}
	if ($nites -ne $null)
		{
		write-host "Deleting File $nites, $site finished running niteproc" -ForegroundColor "Red"
        Remove-Item $nites | Out-Null
        }
    else
        {
        Write-Host "ACTION NEEDED for $site!" -foregroundcolor "DarkGreen"
		Write-Output "NITEPROC did not finish for $site" |
        Out-File $log -append
		Remove-Item $nites | Out-Null
        }
}
########################################################
#-----         compare failurestart.mode          -----#
########################################################
$storedata5test |
Select-object "unit","abrconcept" |
foreach-object {$($_.abrconcept + "_" + $_.unit)} | 
foreach-object {
$site = $_
$failfile = "failurestart.mode." + $site
$failure = Get-Childitem $TargetFolder -Include $failurestart -Recurse | where {$_.name -eq "$failfile"}  
$fail = Get-content $failure | Select-Object -Index 2
	if ($fail -eq $failpass)
		{
		write-host "Deleting File $failure, $site has correct failure restart password setting" -ForegroundColor "Red"
        Remove-Item $failure | Out-Null
		}
	else
		{
		Write-Host "ACTION NEEDED for $site!" -foregroundcolor "DarkGreen"
		Write-Output "incorrect failure restart password setting for $site" |
        Out-File $log -append
		Remove-Item $failure | Out-Null
		}
}
#######################################################	
#-----  find and delete older than current date  -----#
#----- 			  backmode.mode.*	             -----#
#######################################################
$Files = Get-Childitem $TargetFolder -Include $backmode -Recurse | Where {$_.lastwritetime -le "$LastWrite"}
foreach ($File in $Files)
    {
    if ($File -ne $NULL)
        {
        write-host "Deleting File $File" -ForegroundColor "Red"
        Remove-Item $File | out-null
        }
    else
        {
        Write-Host "No more files to delete!" -foregroundcolor "DarkGreen"
        }
    }
#####################################################
#-----  find and delete files no longer used   -----#
#----- 		   failurestart.mode.cig*		   -----#
#----- 		   failurestart.mode.bfg*		   -----#
#----- 		   failurestart.mode.flm*		   -----#
#----- 		   failurestart.mode.obs*		   -----#
#----- 		   redncopy.log.*		           -----#
#----- 		   spcinv.*             		   -----#
#-----         screens.*                       -----#
#####################################################
$purging = get-childitem  $targetfolder -Include $failurestartcig,$failurestartbfg,$failurestartflm,$failurestartobs,$spcinv,$screens,$redncopylog -Recurse
foreach ($purge in $purging)
    {
    if($purge -ne $null)
        {
        write-host "Deleting File $purge" -ForegroundColor "Red"
        Remove-Item $purge | out-null
        }
    else 
	{
        Write-Host "No more files to delete!" -foregroundcolor "DarkGreen"
        }
    }