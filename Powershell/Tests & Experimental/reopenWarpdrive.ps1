############################################
# Author: Austin Essinger                  #
############################################

$epicProc = "ISXEpicWarpDriveConn"
$launchScript = "C:\Scripts\Epic 2019 PRD.bat"

while($true){
    $proc = Get-Process -Name $epicProc -ErrorAction SilentlyContinue
    if ($proc -eq $null){
        # Process isn't found relaunch the script
        cmd.exe /c $launchScript
        Write-Host "Launching Epic"
    }else{
        Write-Host "Epic process found to do"
    }
}
