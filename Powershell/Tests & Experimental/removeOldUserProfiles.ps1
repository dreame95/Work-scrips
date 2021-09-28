########################################
# Removes Profiles Over 90 Days Old    #
# Author: Austin Essinger              #
# Date: 5/27/21                        #
########################################
Import-Module ActiveDirectory


$users = @(Get-WmiObject -ClassName Win32_UserProfile | Select-Object -Property LocalPath)
$blackList = 'C:\Users\0164HLUA'

foreach ($i in $users){
    $temp = $i -replace 'LocalPath='
    $temp = $temp -replace '[@{}]'

    $lastWrite = (Get-Item $temp).LastWriteTime
    $timespan = New-TimeSpan -days 90

    if ($temp.StartsWith("C:\Users") -and $temp -ne $blackList){
        $account = $temp.substring(9)
        #check if account is enabled
        $isEnabled = Get-ADUser -Identity $account | select-object -Property enabled
        if($isEnabled -eq $false ){
            if(((get-date) - $lastWrite) -gt $timespan){
                Write-Host $temp " is over # days old and AD is disabled"
            }
        }else{
            Write-Host "No AD account found or account is still active: " $account
        }
    }else{
        Write-Host $temp " is not disabled DO NOT REMOVE"
    }
}