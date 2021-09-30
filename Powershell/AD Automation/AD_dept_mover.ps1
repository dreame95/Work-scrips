########################################
# Description: checks OU for users     #
# and adds them to appropriate dept    #
#--------------------------------------#
# Author: Austin Essinger              #
#--------------------------------------#
# Date: 9/30/21                        #
########################################

#TODO Get the generic memberships of each dept.
#TODO Test with automator account.

function Set-Membership($targetUser, $targetGroups){
    # apply groups to users based on arguments
    Write-Output $targetUser 'should get the following groups'
    Write-Output '======================================='
    for ($i=0; $i -lt $targetGroups.Length; $i++){
        Write-Output $targetGroups[$i]
        Add-ADGroupMember -Identity $targetGroups[$i] -Members $targetUser
    }
}
function Move-Department{
    $dept = Get-ADUser $args[0] -Properties department | select-object -ExpandProperty department
    if($dept -eq $null){
        Write-Output $args[0] ' goes to OU: Dept Unknown'
        Get-AdUser $args[0] | Move-ADObject -TargetPath $unknownOU
    }else{
        switch ($dept){
            'Providers' {Write-Output $args[0] ' goes to OU: Providers'}
            'RHC - On Campus' {Write-Output $args[0] ' goes to OU: RHC - On Campus'}
            'Administrative Services' {Write-Output $args[0] ' goes to OU: Administrative Services'}
            'Operations Division' {Write-Output $args[0] ' goes to OU: Operations Division'}
            'Wyandot Memorial Hospital' {Write-Output $args[0] ' goes to OU: CEO'}
            'CEO' {Write-Output $args[0] ' goes to OU: CEO'}
            'Respiratory/EEG/Sleep Services' {Write-Output $args[0] ' goes to OU: Respiratory/EEG/Sleep Services'}
            'Revenue Cycle Division' {Write-Output $args[0] ' goes to OU: Revenue Cycle Division'}
            'Med Surg' {Write-Output $args[0] ' goes to OU: Med Surg'}
            'Reimbursement' {Write-Output $args[0] ' goes to OU: Reimbursement'}
            'Patient Financial Services' {Write-Output $args[0] ' goes to OU: PFS'}
            'Oncology Services' {Write-Output $args[0] ' goes to OU: Oncology Services'}
            'Nursing Services' {Write-Output $args[0] ' goes to OU: Nursing Services'}
            'Medical Records' {Write-Output $args[0] ' goes to OU: Medical Records'}
            'SHC' {Write-Output $args[0] ' goes to OU: SHC'}
            'Laboratory Services' {Write-Output $args[0] ' goes to OU: Laboratory Services'}
            'Tarhe Trail' {Write-Output $args[0] ' goes to OU: Tarhe Trail'}
            'Security Services' {Write-Output $args[0] ' goes to OU: Security Services'}
            'Pharmacy Services' {Write-Output $args[0] ' goes to OU: Pharmacy Services'}
            'Information Technology' {
                Write-Output $args[0] ' goes to OU: Information Technology'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','IT','memo','SSL-VPN-MFA')
                Set-Membership $args[0] $groups
            }
            'Quality Division' {Write-Output $args[0] ' goes to OU: Quality Division'}
            'Emergency Department' {Write-Output $args[0] ' goes to OU: Emergency Department'}
            'Radiology & Cardiology' {Write-Output $args[0] ' goes to OU: Radiology & Cardiology'}
            'Therapy Services' {Write-Output $args[0] ' goes to OU: Therapy Services' }
            'RHC - Sycamore' {Write-Output $args[0] ' goes to OU: RHC - Sycamore'}
            'Wellness Services' {Write-Output $args[0] ' goes to OU: Wellness Services'}
            'Perioperative Services' {Write-Output $args[0] ' goes to OU: Perioperative Services'}
            'Finance & Nursing Division' {Write-Output $args[0] ' goes to OU: Finance & Nursing Division'}
            'ICU' {Write-Output $args[0] ' goes to OU: ICU'}
            'Registration' {Write-Output $args[0] ' goes to OU: Registration'}
            'Accounting' {Write-Output $args[0] ' goes to OU: Accounting'}
            'Provider Services' {Write-Output $args[0] ' goes to OU: Provider Services'}
            'Materials' {Write-Output $args[0] ' goes to OU: Materials'}
            'Wyandot On Wheels' {Write-Output $args[0] ' goes to OU: Wyandot On Wheels'}
            'Radiology & Cardiology' {Write-Output $args[0] ' goes to OU: Radiology & Cardiology'}
            'Home Health and Hospice Division' {Write-Output $args[0] ' goes to OU: Home Health and Hospice'}
            'Home Health Services' {Write-Output $args[0] ' goes to OU: Home Health and Hospice'}
            'Hospice Services' {Write-Output $args[0] ' goes to OU: Home Health and Hospice'}
            'Social Services and Bereavement Services' {Write-Output $args[0] ' goes to OU: Social Services and Bereavement Services'}
            'Environmental Services' {Write-Output $args[0] ' goes to OU: Environmental Services'}
            default {
                Write-Output $args[0] ' goes to OU: Dept Unknown'
                Get-AdUser $args[0] | Move-ADObject -TargetPath $unknownOU
            }
        }
    }
}


$stagedOU = 'OU=Staged,OU=Users,OU=WMH,DC=wmh,DC=com'
$unknownOU = 'OU=Dept Unknown,OU=Users,OU=WMH,DC=wmh,DC=com'
$users = Get-ADUser -Filter * -SearchBase $stagedOU | select-object -ExpandProperty SamAccountName
if ($users -eq $null){
    #no users modify later to output to log
    Write-Output "No Users in OU... Ending Script"
    Exit
}elseif ($users -isnot [array]) {
    Move-Department($users)
}else{
    for ($i = 0; $i -lt $users.Length; $i++){
        Move-Department($users[$i])
    }
}
Start-Sleep -Seconds 30
$failedUsers = Get-ADUser -Filter * -SearchBase $unknownOU -Properties Department | Select-Object -ExpandProperty Name
$body = "The Following Users have Unknown Departments and need Manual Intervention: `r`n" + ($failedUsers -join "`r`n") 
Send-MailMessage -From 'AD Automation <adautomation@wyandotmemorail.org>' -To 'IT <it@wyandotmemorial.org>' -Subject 'Test email format' -Body $body -SmtpServer wmh-exch.wmh.com 






