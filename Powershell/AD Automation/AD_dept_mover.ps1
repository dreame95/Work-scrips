########################################
# Description: Checks OU for users     #
# and adds them to appropriate dept    #
#--------------------------------------#
# Author: Austin Essinger              #
#--------------------------------------#
# Date: 9/30/21                        #
########################################

#TODO Get the generic memberships of each dept.
#TODO Test with automator account.

# PSFramework Logging Provider Info (https://psframework.org/)
$logFilePath = '\\wmh-it\data$\Automation\AD\ad_dept_mover_logs.csv'
Set-PSFLoggingProvider -Name logfile -Enabled $true -FilePath $logFilePath

####################
# Global Variables #
####################

$mailFrom = 'AD Automation <adautomation@wyandotmemorial.org>'
$mailTo = 'IT <it@wyandotmemorial.org>'
$mailSubject = 'Test email format'
$mailSMTPServer = 'wmh-exch.wmh.com'

$stagedOU = 'OU=Staged,OU=Users,OU=WMH,DC=wmh,DC=com'
$unknownOU = 'OU=Dept Unknown,OU=Users,OU=WMH,DC=wmh,DC=com'

$unknownOUFilePath = '\\wmh-it\data$\Automation\AD\UnknownDept.xlsx'

$ouHashTable = @{
    'Providers' = @('BSMH-CarePath-Access','CTX-AppEpic-PRD-WarpDrive-Wyandot','CTX-AppEpicPLY-Wyandot','WMHLucid-Provider');
    'RHC - On Campus' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Physician Services');
    'Administrative Services' = @('Management Team', 'memo');
    'Operations Division' = @('BSMH-CarePath-Access','CTX-AppEpic-PRD-WarpDrive-Wyandot,CTX-AppEpic-PRD','memo','Management Team');
    'Wyandot Memorial Hospital' = @('BSMH-CarePath-Access','CTX-AppEpic-PRD-WarpDrive-Wyandot','CTX-AppEpicPLY-Wyandot','Management Team');
    'CEO' = @('BSMH-CarePath-Access','CTX-AppEpic-PRD-WarpDrive-Wyandot','CTX-AppEpicPLY-Wyandot','Management Team');
    'Respiratory/EEG/Sleep Services' = @('BSMH-CarePath-Access','CTX-AppEpic-PRD-WarpDrive-Wyandot','iSTAT-Remote_Access','respiratory_access','WMHLucid-Staff');
    'Human Resources & Regulatory Services Division' = @('memo');
    'Revenue Cycle Division' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-Wyandot','memo','Management Team');
    'Med Surg' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-Wyandot','CTX-AppEpicPRD-WarpDrive-Wyandot');
    'Reimbursement' = @('BSMH-CarePath-Access','CTX-AppEpicPRD-Wyandot');
    'Patient Financial Services' = @('BSMH-CarePath-Access','CTX-AppEpicPRD-Wyandot');
    'Oncology Services' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-Wyandot','Oncology Group');
    'Nursing Services' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-Wyandot','CTX-AppEpicPRD-Warpdrive-Wyandot','Management Team','Nursing Department','Nursing_access');
    'Medical Records' = @('3M Encoders','BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-Warpdrive-Wyandot','CTX-AppEpicPRD-Wyandot','MRCoders');
    'SHC' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','SHC Group');
    'Laboratory Services' = @('BSMH-CarePath-Access','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot');
    'Tarhe Trail' = @('BSMH-CarePath-Access','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Physician Services','Physician Services');
    'Security Services' = @('Camera Security','Security');
    'Pharmacy Services' = @('BSMH-CarePath-Access', 'CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Nursing Department','Nursing_access','Pharmacy group');
    'Information Technology' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','IT','memo','SSL-VPN-MFA');
    'Quality Division' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','memo');
    'Emergency Department' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Nursing Department','Nursing_access', 'WMHLucid-Staff');
    'Radiology & Cardiology' = @('BSMH-CarePath-Access','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','WMHLUcid-Tech');
    'Therapy Services' = @('BSMH-CarePath-Access','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','PT Group');
    'RHC - Sycamore' = @('BSMH-CarePath-Access','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot');
    'Wellness Services' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Wellness Group');
    'Perioperative Services' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Nursing Department','Nursing_access','Surgery Group', 'WMHLucid-Staff');
    'Finance & Nursing Division' = @('memo');
    'ICU' = @('BSMH-CarePath-Access','BSMH-Medex','CCU Group','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Nursing Department','Nursing_Access');
    'Registration' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Registration Group');
    'Accounting' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot');
    'Provider Services' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Physician Services');
    'Materials' = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Materials','memo');
    'Wyandot On Wheels' = @('CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot');
    'Home Health and Hospice Division' = @('HomeHealth-Hospice','SSL-VPN-Access');
    'Home Health Services' = @('HomeHealth-Hospice','SSL-VPN-Access');
    'Hospice Services' = @('HomeHealth-Hospice','SSL-VPN-Access');
    'Social Services and Bereavement Services' = @('memo');
    'Environmental Services' = @('CTX-AppEpicPRD-WarpDrive');
}

function Invoke-Create-Unknown-User-Attachment {
    <#
    .SYNOPSIS
    Creates an Excel spreadsheet with list of unknown users for emailing

    .DESCRIPTION
    Long description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    Write-PSFMessage -Level Output -Message "Creating unknown user email attachment..." -Tag "Information"
    Get-ADUser -Filter * -SearchBase $unknownOU -Properties Department,Manager | Select-Object name,SamAccountName,Department,Manager | Export-Excel -Path $unknownOUFilePath
    Write-PSFMessage -Level Output -Message "Created unknown user attachment." -Tag "Success"
}

function Invoke-Retrieve-Unknown-Users {
    <#
    .SYNOPSIS
    Retrieves the list of users within the Dept Unknown OU

    .DESCRIPTION
    Long description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    Write-PSFMessage -Level Output -Message "Retrieving users within the Unknown OU..." -Tag "Information"
    return Get-ADUser -Filter * -SearchBase $unknownOU -Properties Department | Select-Object -ExpandProperty Name
}

function Send-IT-Email {
    <#
    .SYNOPSIS
    Sends an email to Wyandot Memorial Hospital IT with the list of unknown users

    .DESCRIPTION
    Long description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    $unknownUsers = Invoke-Retrieve-Unknown-Users
    Write-PSFMessage -Level Output -Message "Retrieved users within the Unknown OU." -Tag "Success"

    Invoke-Create-Unknown-User-Attachment

    Write-PSFMessage -Level Output -Message "Creating IT email to send for unknown users..." -Tag "Information"
    $body = "The Following Users have Unknown Departments and need Manual Intervention: `r`n" + ($unknownUsers -join "`r`n")
    Send-MailMessage -From $mailFrom -To $mailTo -Subject $mailSubject -Body $body -SmtpServer $mailSMTPServer -Attachments $unknownOUFilePath
    Write-PSFMessage -Level Output -Message "Sent IT email unknown users." -Tag "Success"
}

function Set-Membership($targetUser){
    <#
    .SYNOPSIS
    Sets group membership based on user's OU

    .DESCRIPTION
    Long description

    .PARAMETER targetUser
    User to place into provided AD groups
    type: [string]
s
    .PARAMETER targetGroups
    List of AD groups
    type: [array]

    .EXAMPLE
    User: John Doe
    Placed in Group(s): CTX-AppEpicPRD-WarpDrive

    .NOTES
    General notes
    #>

    Write-PSFMessage -Level Output -Message "Adding $targetUser to: $targetGroups" -Tag "Information"
    for ($i=0; $i -lt $targetGroups.Length; $i++){
        Add-ADGroupMember -Identity $targetGroups[$i] -Members $targetUser
    }
    Write-PSFMessage -Level Output -Message "$targetUser added to: $targetGroups" -Tag "Success"
}

function Set-Unknown($user){
    <#
    .SYNOPSIS
    Sets group membership based to unknown for user

    .DESCRIPTION
    Long description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    Write-PSFMessage -Level Important -Message "$user goes to OU: Dept Unknown" -Tag 'Unknown'
    Get-AdUser $user | Move-ADObject -TargetPath $unknownOU
    Write-PSFMessage -Level Important -Message "$user set to OU: Dept Unknown" -Tag 'Unknown'
}

function Invoke-Retrieve-Department($user) {
    <#
    .SYNOPSIS
    Retrieves the department associated with the AD user

    .DESCRIPTION
    Long description

    .PARAMETER user
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    Write-PSFMessage -Level Output -Message "Retrieving $user from the staged OU..." -Tag "Information"
    return Get-ADUser $user -Properties department | select-object -ExpandProperty department
}

function Move-Department($user) {
    <#
    .SYNOPSIS
    Moves AD users into appropriate department OUs

    .DESCRIPTION
    Long description

    .EXAMPLE
    User: John Doe
    Department: Environmental Services
    Placed in OU: Environmental Services

    .NOTES
    General notes
    #>

    $dept = Invoke-Retrieve-Department($user)
    Write-PSFMessage -Level Output -Message "Retrieved $user from the staged OU." -Tag "Success"

    if($null -eq $dept){
        Set-Unknown($user)
    }else{
        if ($ouHashTable.$dept){
            Write-PSFMessage -Level Output -Message "$user goes to OU: $dept" -Tag $dept
            Set-Membership($user,$ouHashTable.$dept)
            Write-PSFMessage -Level Output -Message "$user successfully set to OU: $dept" -Tag $dept
        }else{
            Write-PSFMessage -Level Critical -Message "Department not found in hash table" -Tag 'Failure' -ErrorRecord $_
        }
    }
}

function Invoke-Retrieve-AD-Users($orgUnit) {
    <#
    .SYNOPSIS
    Retrieves all AD users sAMAccountNames from provided OU

    .DESCRIPTION
    Long description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    Write-PSFMessage -Level Output -Message "Retrieving user list for $stagedOU from AD..." -Tag "Information"
    return Get-ADUser -Filter * -SearchBase $orgUnit | select-object -ExpandProperty SamAccountName
}

function Invoke-Main {
    <#
    .SYNOPSIS
    The main function for the program

    .DESCRIPTION
    Processes a list of users from a given OU, assigns them
    to appropriate groups, and sends an email of unknown users
    that need manual intervention.

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    $users = Invoke-Retrieve-AD-Users($stagedOU)
    Write-PSFMessage -Level Output -Message "Retrieved user list for $stagedOU from AD." -Tag "Success"

    if ($null -eq $users){
        Write-PSFMessage -Level Output -Message "No users to process" -Tag 'Information'
        Exit
    }elseif ($users -isnot [array]) {
        Move-Department($users)
    }else{
        for ($i = 0; $i -lt $users.Length; $i++){
            Move-Department($users[$i])
        }
    }

    # Just a sleep...
    Start-Sleep -Seconds 30

    Send-IT-Email
}

Invoke-Main
