# Script: ad-automation-stager.ps1
# Author: Dylan 'Chromosome' Navarro
# Description: Downloads all the necessary files for AD automation and configures tasks to complete the process. 

# This will need to be changed from the development branch once testing is complete.
$file2download = "https://raw.githubusercontent.com/CyPH3RSkULL5/SysAdminADautoSetup/dylan-development/zip.zip"
$currentPath = (Get-Location).path

(New-Object System.Net.WebClient).DownloadFile($file2download,"zip.zip")  # Downloads the ZIP archive from the repo. 
Expand-Archive -Path zip.zip -DestinationPath .  # Uncompresses the archine in the current directory (.). 
Remove-Item -Path .\zip.zip  # Cleans up the current directory by removing the zip file. 

function scheduletask {
    $trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
    Register-ScheduledJob -Trigger $trigger -FilePath "$currentPath\automation\configure-ad.ps1" -Name "AD Automation"  # Use Get-Job to see if job was complete.
}

scheduletask

Unblock-File -Path .\automation\install-adds.ps1
powershell .\automation\install-adds.ps1

Unblock-File -Path .\automation\configure-ad.ps1

Read-Host ("Press any key to exit....")