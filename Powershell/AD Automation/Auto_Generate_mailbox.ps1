Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

function Set-MultiUsers{
    for ($i = 0; $i -lt $arr.Length; $i++){

    #concantenate the email address
    $principleName = $arr[$i] + "@wyandotmemorial.org"
    
    #get the first and last name of the user (needed for the exchange commands)
    $name = Get-ADUser -Identity $arr[$i] | select -ExpandProperty Name
    $fullName = $name.Split(" ")
    $firstName = $fullName[0]
    $lastName = $fullName[1]
    $userAccount = "wmh\" + $arr[$i]

   
    $condition = Get-Recipient -ANR $arr[$i]
    $output = Write-Output $condition

    #Check if email box is already set up, if so skip that
    #mailbox creation for that user
    if($output -ne $null){
        #There is a mail box
        #so do nothing
        Write-Host nothing to do for $arr[$i]
        

    }else{
        #there isn't a mail box, this is want me want
        #create the mailbox
        Write-Host creating mailbox for $arr[$i]
        $createMailbox = Enable-Mailbox -Identity $userAccount
        Start-Sleep -Seconds 180

    }
    $condition = Get-Recipient -ANR $arr[$i]
    $output = Write-Output $condition
    If( $output -ne $null){
        # The mailbox was created
        $successful = "The mailbox was genearated for " + $arr[$i]
        Write-Host  $successful
        #set users UPN
        Set-ADUser -Identity $arr[$i] -UserPrincipalName $principleName
        #move user to new staged OU
        Get-ADUser $arr[$i] | Move-ADObject -TargetPath $newOU
        #Add user to emailList group
        If($memebers -contains $arr[$i]){
            #do nothing as user is apart of email list

        }else{
            #User is not in Email Group
            Add-ADGroupMember -identity $group $arr[$i]
        }

    }else{
            #Mailbox wasn't created successfully
            $failed = "The mailbox wasn't created for " + $arr[$i]
            Write-Host = $failed
            #add user to failedmailbox array
            $failedMailbox += $arr[$i] 

     }
    
    }
}

Get-Date | Out-File -FilePath C:\Users\Public\emailLog.txt -Append

$newOU = 'OU=Staged,OU=Users,OU=WMH,DC=wmh,DC=com'
$OUpath = 'OU=New Employees Workday,OU=Users,OU=WMH,DC=wmh,DC=com'
$group = "Email List"

#Get-ADUser -Filter * -SearchBAse $OUpath | Select-Object Name,UserPrincipalName
$arr = Get-ADUser -Filter * -SearchBase $OUpath | select-object -ExpandProperty SamAccountName
#$arr | Out-File -Append C:\Users\aessinger\users.txt

if ($arr -eq $null){
    Get-Date | Out-File C:\Users\Public\emailLog.txt -Append
    Write-Output "No New users ending script" | Out-File C:\Users\Public\emailLog.txt -Append
    Write-Output "=============================================================" | Out-File C:\Users\Public\emailLog.txt -Append
    Exit
}
#array to store users who mailboxes failed to get created.
#empty for time being
$failedMailboxes= @()

# Loop through each User create email and then run commands to create mailbox.
# will want to verify if mailbox already exists
$members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty SamAccountName

if($arr -is [array]){
    Set-MultiUsers
}else{
    $principleName = $arr + "@wyandotmemorial.org"
    $name = Get-ADUser -Identity $arr | select -ExpandProperty Name
    $fullName = $name.Split(" ")
    $firstName = $fullName[0]
    $lastName = $fullName[1]
    $userAccount = "wmh\" + $arr

    $condition = Get-Recipient -ANR $arr
    $output = Write-Output $condition

    #Check if email box is already set up, if so skip that
    #mailbox creation for that user
    if($output -ne $null){
        #There is a mail box
        #so do nothing
        Write-Host nothing to do for $arr
        

    }else{
        #there isn't a mail box, this is want me want
        #create the mailbox
        Write-Host creating mailbox for $arr
        $createMailbox = Enable-Mailbox -Identity $userAccount
        Start-Sleep -Seconds 180
    }
    $condition = Get-Recipient -ANR $arr
    $output = Write-Output $condition
    Start-Sleep -Seconds 5
    If( $output -ne $null){
        # The mailbox was created
        $successful = "The mailbox was genearated for " + $arr
        Write-Host  $successful
        #set users UPN
        Set-ADUser -Identity $arr -UserPrincipalName $principleName
        #move user to new staged OU
        Get-ADUser $arr | Move-ADObject -TargetPath $newOU
        #Add user to emailList group
        If($memebers -contains $arr){
            #do nothing as user is apart of email list

        }else{
            #User is not in Email Group
            Add-ADGroupMember -identity $group $arr
        }


    }else{
            #Mailbox wasn't created successfully
            $failed = "The mailbox wasn't created for " + $arr
            Write-Host = $failed
            #add user to failedmailbox array
            $failedMailbox += $arr
        

     }

}
#Output Time and failed users to File
if ( -not [string]::IsNullOrEmpty($failedMailboxes)){
    Write-Output "Can't create a mailbox for the following users $failedMailbox " | Out-file C:\Users\Public\emailLog.txt -Append
    }

Write-Output "Finished Running at" | Out-File -FilePath C:\Users\Public\emailLog.txt -Append
Get-Date | Out-File -FilePath C:\Users\Public\emailLog.txt -Append
Write-Output "=============================================================" | Out-File C:\Users\Public\emailLog.txt -Append