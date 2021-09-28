###############################################
# Description: Archive users who are inactive #
# for over 90 days                            #
# Author: Austin Essinger                     #
# Updated: 6/8/2021                           #
###############################################

$inactiveUsers = Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 -UsersOnly -SearchBase "OU=Users,OU=WMH,DC=wmh,DC=com" |
 Where-Object {$_.distinguishedName -notlike "*,OU=Shared usernames,OU=Users,OU=WMH,DC=wmh,DC=com"} |
  Where-Object {$_.distinguishedName -notlike "*,OU=Administrators,OU=Users,OU=WMH,DC=wmh,DC=com"} |
   Where-Object {$_.distinguishedName -notlike "*,OU=IT,OU=Administrative Services Division,OU=Users,OU=WMH,DC=wmh,DC=com"} |
    Select-Object -ExpandProperty SamAccountName

$archiveOU = OU=Archived Users,OU=Users,OU=WMH,DC=wmh,DC=com
foreach ($user in $inactiveUsers) {
    #disable account 
    #Disable-ADAccount -Identity $user
    Write-Host 'Disabling user: ' $user
    Write-Host 'Moving user to Archive OU'
    # Get-ADUser $user | Move-ADObject -TargetPath $archiveOU
    Write-Host 'MOVE COMPLETED'
}