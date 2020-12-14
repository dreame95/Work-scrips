$regPath = 'HKLM:\SOFTWARE\WOW6432Node\Epic Systems Corporation\PoolManager'
$acl = Get-Acl $regPath
$permission = $env:COMPUTERNAME + "/Users"
Write-Host $permission

$rule = New-Object System.Security.AccessControl.RegistryAccessRule ('Everyone',"FullControl","Allow")
$acl.SetAccessRule($rule)
$acl | Set-Acl -Path $regPath

Read-Host "Press any key to quit"