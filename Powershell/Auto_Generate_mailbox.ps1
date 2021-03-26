Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn

#TODO the user to a different 



$newOU = 'OU=Staged,OU=Users,OU=WMH,DC=wmh,DC=com'
$OUpath = 'OU=New Employees Workday,OU=Users,OU=WMH,DC=wmh,DC=com'

#Get-ADUser -Filter * -SearchBAse $OUpath | Select-Object Name,UserPrincipalName
$arr = Get-ADUser -Filter * -SearchBase $OUpath | select -ExpandProperty SamAccountName
#$arr | Out-File -Append C:\Users\aessinger\users.txt


#array to store users who mailboxes failed to get created.
#empty for time being
$failedMailboxes= @()

# Loop through each User create email and then run commands to create mailbox.
# will want to verify if mailbox already exists

for ($i = 0; $i -lt $arr.Length; $i++){

    #concantenate the email address
    $principleName = $arr[$i] + "@wyandotmemorial.org"
    
    #get the first and last name of the user (needed for the exchange commands)
    $name = Get-ADUser -Identity $arr[$i] | select -ExpandProperty Name
    $fullName = $name.Split(" ")
    $firstName = $fullName[0]
    $lastName = $fullName[1]
    $userAccount = "wmh\" + $arr[$i]
    $createMailbox = Enable-Mailbox -Identity $userAccount
    

   
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
        Invoke-Expression $createMailbox


    }
    $condition = Get-Recipient -ANR $arr[$i]
    $output = Write-Output $condition

    If( $output -ne $null){
        # The mailbox was created
        $successful = "The mailbox was genearated for " + $arr[$i]
        Write-Host  $successful
        Set-ADUser -Identity $arr[$i] -UserPrincipalName $principleName
        #Move the User to a different OU Potentially
        # format should look like Get-ADUser $name | Move-ADObject -TargetPath 'OU=Staged,OU=Users,OU=WMH,DC=WMH,DC=com
        Get-ADUser $arr[$i] | Move-ADObject -TargetPath $newOU

    }else{
        #Mailbox wasn't created successfully
        $failed = "The mailbox wasn't created for " + $arr[$i]
        Write-Host = $failed
        #add user to failedmailbox array
        $failedMailbox += $arr[$i]
        

    }

    
}

#Output Time and failed users to File
Write-Output "Can't create a mailbox for the following users $failedMailbox " | Out-file C:\Users\Public\emailLog.txt -Append
