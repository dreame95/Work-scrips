param([switch]$Elevated)
function Check-Admin {
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Check-Admin) -eq $false)  {
if ($elevated)
{
# could not elevate, quit
}
 
else {
 
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}
exit
}

sc.exe config wuauserv start=disabled
sc.exe stop wuauserv
Disable-ScheduledTask -Taskname "Microsoft Compatibility Appraiser" -TaskPath "\Microsoft\Windows\Application Experience"
get-appxpackage -allusers *3dbuilder* | remove-appxpackage
get-appxpackage -allusers *windowsstore* | Remove-AppxPackage
get-appxpackage -allusers *alarms* | remove-appxpackage
get-appxpackage -allusers *appconnector* | remove-appxpackage
get-appxpackage -allusers *appinstaller* | remove-appxpackage
get-appxpackage -allusers *communicationsapps* | remove-appxpackage
get-appxpackage -allusers *camera* | remove-appxpackage
get-appxpackage -allusers *feedback* | remove-appxpackage
get-appxpackage -allusers *officehub* | remove-appxpackage
get-appxpackage -allusers *getstarted* | remove-appxpackage
get-appxpackage -allusers *skypeapp* | remove-appxpackage
get-appxpackage -allusers *zunemusic* | remove-appxpackage
get-appxpackage -allusers *zune* | remove-appxpackage
get-appxpackage -allusers *maps* | remove-appxpackage
get-appxpackage -allusers *messaging* | remove-appxpackage
get-appxpackage -allusers *solitaire* | remove-appxpackage
get-appxpackage -allusers *wallet* | remove-appxpackage
get-appxpackage -allusers *bingfinance* | remove-appxpackage
get-appxpackage -allusers *bing* | remove-appxpackage
get-appxpackage -allusers *zunevideo* | remove-appxpackage
get-appxpackage -allusers *bingnews* | remove-appxpackage
get-appxpackage -allusers *onenote* | remove-appxpackage
get-appxpackage -allusers *oneconnect* | remove-appxpackage
get-appxpackage -allusers *commsphone* | remove-appxpackage
get-appxpackage -allusers *windowsphone* | remove-appxpackage
get-appxpackage -allusers *phone* | remove-appxpackage
get-appxpackage -allusers *photos* | remove-appxpackage
get-appxpackage -allusers *bingsports* | remove-appxpackage
get-appxpackage -allusers *sticky* | remove-appxpackage
get-appxpackage -allusers *sway* | remove-appxpackage
get-appxpackage -allusers *3d* | remove-appxpackage
get-appxpackage -allusers *soundrecorder* | remove-appxpackage
get-appxpackage -allusers *bingweather* | remove-appxpackage
get-appxpackage -allusers *holographic* | remove-appxpackage
get-appxpackage -allusers *xbox* | remove-appxpackage
get-appxpackage -allusers *Microsoft.Windows.Cortana* | Remove-AppxPackage
get-appxprovisionedpackage -online | remove-appxprovisionedpackage -online