$age = Read-Host "Specify the age of password you want to see (in days): "
$today = Get-Date
$XDaysAgo = $today.AddDays(-$age)

Get-ADUser -Filter "Enabled -eq 'True' -and passwordlastset -lt '$XDaysAgo'" | 
select-object name,passwordlastset
