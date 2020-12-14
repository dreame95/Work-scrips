Copy-Item -Path "\\wmh-it\data`$\software\Epic Backup Software\Backup software" -Destination "C:\downtime" -Recurse

msiexec.exe /I "C:\Backup software\EpicNovember2019BCAPC.msi" /quiet /L* "C:\Backup software\install.log"