If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}
# Now running elevated so launch the script:
& "C:\Users\aessinger\Desktop\Scripts\Powershell\workspace_uninstall_final.ps1"
<#
cd "C:\ProgramData\Citrix\Citrix Workspace 2006"
.\TrolleyExpress.exe /uninstall /cleanup /silent

#>

