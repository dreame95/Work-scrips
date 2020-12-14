#Variables
#============================================================================================================================
# warp drive location
$warpDrive = "\\wmh-it\data`$\Private\Software\Imprivata\Epic November 2019 Warp Drive.msi"
# Imprivata Hyper space location
$hyperSpaceConnector = "\\wmh-it\data`$\Private\Software\Imprivata\ImprivataConnectorforEpicHyperspace.msi"
# Imprivata Warp Drive Connector location
$warpDriveConnector = "\\wmh-it\data`$\Private\Software\Imprivata\ImprivataConnectorforEpicWarpDrive.msi"
# config source location
$source = "\\wmh-it\data$\Private\Software\Imprivata\WarpDriveConnectorConfiguration.xml"
# config destination location
$dest = "C:\Program Files (x86)\Imprivata\OneSign Agent\EpicConnector"
# VB script command
$acommand = "C:\Windows\System32\Cscript.exe \\wmh-it\data$\Private\Software\Imprivata\WarpDriveConfig.vbs"

$regPath = 'HKLM:\SOFTWARE\WOW6432Node\Epic Systems Corporation\PoolManager'
$acl = Get-Acl $regPath
$permission = $env:COMPUTERNAME + "/Users"
#============================================================================================================================

# set imprivata type to 2 (shared)
Set-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\SSOProvider\ISXAgent -Name Type -Value 2

# set the registry
$rule = New-Object System.Security.AccessControl.RegistryAccessRule ('Everyone',"FullControl","Allow")
$acl.SetAccessRule($rule)
$acl | Set-Acl -Path $regPath

#create scripts folder in C:
New-Item C:\Scripts -ItemType directory

# move the PRD and SRO vb script to C:\Scripts
Copy-Item '\\wmh-it\data$\Private\Software\Imprivata\Epic 2019 PRD.vbs' -Destination 'C:\Scripts' -Force
Copy-Item '\\wmh-it\data$\Private\Software\Imprivata\Epic 2019 SRO.vbs' -Destination 'C:\Scripts' -Force

# move the batch files
Copy-Item '\\wmh-dfs2\data\Common\Epic Config\Epic 2019 PRD.lnk' -Destination 'C:\Users\Public\Desktop' -Force
Copy-Item '\\wmh-dfs2\data\Common\Epic Config\Epic 2019 SRO.lnk' -Destination 'C:\Users\Public\Desktop' -Force

# Install Warpdrive
Write-Host "Starting the Epic Installer"
Start-Process $warpDrive -ArgumentList "/quiet" -Wait
Write-Host "Install completed"

#Install the Hyperspace connector
Write-Host "Starting HyperSpace installer"
Start-Process $hyperSpaceConnector -ArgumentList "/quiet" -Wait
Write-Host "HyperSpace Install Completed"

#Install the WarpDrive Connector
Write-Host "Starting the WarpDrive Connector installer"
Start-Process $warpDriveConnector -ArgumentList "/quiet" -Wait
Write-Host "Warp Drive Connector Install Completed"

# call the vbScript
#===================================
Write-Host "Running the VB Script"
$acommand = "C:\Windows\System32\Cscript.exe \\wmh-it\data$\Private\Software\Imprivata\WarpDriveConfig.vbs"
Invoke-Expression $acommand
Write-Host "Process Completed"



Write-Host "Copying Config file..... Please Wait"
# Copy the files from source to destination and force it to overwrite
Copy-Item $source -Destination $dest -Force
Write-Host "Copying Config File.....COMPLETED"
