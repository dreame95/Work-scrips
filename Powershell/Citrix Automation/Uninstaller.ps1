./CitrixWorkspaceApp.exe /Uninstall /silent | Out-Null

Write-Host "Finished uninstalling"

./CitrixWorkspaceApp.exe /includeSSON /silent /forceInstall | Out-Null
Write-Host "Finished Installing Target Version"
Read-Host "Press Enter to Quit"