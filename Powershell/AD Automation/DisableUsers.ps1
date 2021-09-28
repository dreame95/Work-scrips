# Disables user accounts this is for specific criteria

$users = Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 -UsersOnly -SearchBase "OU=Users,OU=WMH,DC=wmh,DC=com" |
 Where-Object {$_.distinguishedName -notlike "*,OU=Shared usernames,OU=Users,OU=WMH,DC=wmh,DC=com"} |
  Where-Object {$_.distinguishedName -notlike "*,OU=Administrators,OU=Users,OU=WMH,DC=wmh,DC=com"} |
   Where-Object {$_.distinguishedName -notlike "*,OU=IT,OU=Administrative Services Division,OU=Users,OU=WMH,DC=wmh,DC=com"} |
    Where-Object {$_.lastlogondate -ne $null} | Select-Object name,SamAccountName,lastlogondate,enabled | Export-Excel -Path C:\Users\Public\Documents\inactiveUsers.xlsx


$users = Import-Excel -Path C:\users\public\Documents\inactiveUsers.xlsx | Select-Object -ExpandProperty SamAccountName

foreach ($user in $users) {
    if((Get-ADUser -Identity $user | Select-Object -ExpandProperty Enabled) -eq $true){
        Write-Host $user
    }
}

<#
#$users = Import-Csv -Path C:\users\aessinger\Downloads\NonActiveEmployees.csv | Select-Object -ExpandProperty SamAccountName

foreach ($user in $users) {
    Write-Host "Disabling user: " $user
    Disable-ADAccount -Identity $user

    Start-Sleep -Seconds 2

    if((Get-ADUser -Identity $user | select-Object -ExpandProperty Enabled) -eq $false){
        Write-Host "user: " $user " IS DISABLED"
    }else{
        Write-Host "ERROR FOR USER: " $user
    }
}

Read-Host "Press Enter to Quite"

#>