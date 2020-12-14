(get-process | ? { $_.mainwindowtitle -ne "" -and $_.processname -ne "powershell" } )| stop-process
Start-Sleep -s 5
Stop-Process powershell