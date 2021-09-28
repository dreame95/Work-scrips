##########################################
# Description: Generates report of users #
# that haven't logged in, in last 90 days#
# Author: Austin Essinger                #
# Updated: 6/8/21                        #
##########################################


Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 -UsersOnly -SearchBase "OU=Users,OU=WMH,DC=wmh,DC=com" |
 Where-Object {$_.distinguishedName -notlike "*,OU=Shared usernames,OU=Users,OU=WMH,DC=wmh,DC=com"} |
  Where-Object {$_.distinguishedName -notlike "*,OU=Administrators,OU=Users,OU=WMH,DC=wmh,DC=com"} |
   Where-Object {$_.distinguishedName -notlike "*,OU=IT,OU=Administrative Services Division,OU=Users,OU=WMH,DC=wmh,DC=com"} |
    select-object Name,SamAccountName,LastLogonDate,Enabled | Export-Excel -Path C:\Users\aessinger\Downloads\NonActiveEmployeesTEST.xlsx