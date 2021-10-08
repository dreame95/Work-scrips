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
            'Providers' {
                Write-Output $args[0] ' goes to OU: Providers'
                $groups = @('BSMH-CarePath-Access','CTX-AppEpic-PRD-WarpDrive-Wyandot','CTX-AppEpicPLY-Wyandot','WMHLucid-Provider')
                Set-Membership $args[0] $groups
            }
            'RHC - On Campus' {
                Write-Output $args[0] ' goes to OU: RHC - On Campus'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Physician Services')
                Set-Membership $args[0] $groups
                }
            'Administrative Services' {
                Write-Output $args[0] ' goes to OU: Administrative Services'
                $groups = @('Management Team', 'memo')
                Set-Membership $args[0] $groups
                }
            'Operations Division' {
                Write-Output $args[0] ' goes to OU: Operations Division'
                $groups = @('BSMH-CarePath-Access','CTX-AppEpic-PRD-WarpDrive-Wyandot,CTX-AppEpic-PRD','memo','Management Team')
                Set-Membership $args[0] $groups
                }
            'Wyandot Memorial Hospital' {
                Write-Output $args[0] ' goes to OU: CEO'
                $groups = @('BSMH-CarePath-Access','CTX-AppEpic-PRD-WarpDrive-Wyandot','CTX-AppEpicPLY-Wyandot','Management Team')
                Set-Membership $args[0] $groups
                }
            'CEO' {
                Write-Output $args[0] ' goes to OU: CEO'
                $groups = @('BSMH-CarePath-Access','CTX-AppEpic-PRD-WarpDrive-Wyandot','CTX-AppEpicPLY-Wyandot','Management Team')
                Set-Membership $args[0] $groups
            }
            'Respiratory/EEG/Sleep Services' {
                Write-Output $args[0] ' goes to OU: Respiratory/EEG/Sleep Services'
                $groups = @('BSMH-CarePath-Access','CTX-AppEpic-PRD-WarpDrive-Wyandot','iSTAT-Remote_Access','respiratory_access','WMHLucid-Staff')
                Set-Membership $args[0] $groups
            }
            'Human Resources & Regulatory Services Division'{
                Write-Output $args[0] ' goes to OU: Human Resources & Regulatory Services Division'
                $groups = @('memo')
                Set-Membership $args[0] $groups
            }
            'Revenue Cycle Division' {
                Write-Output $args[0] ' goes to OU: Revenue Cycle Division'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-Wyandot','memo','Management Team')
                Set-Membership $args[0] $groups
            }
            'Med Surg' {
                Write-Output $args[0] ' goes to OU: Med Surg'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-Wyandot','CTX-AppEpicPRD-WarpDrive-Wyandot')
                Set-Membership $args[0] $groups
            }
            'Reimbursement' {
                Write-Output $args[0] ' goes to OU: Reimbursement'
                $groups = @('BSMH-CarePath-Access','CTX-AppEpicPRD-Wyandot')
                Set-Membership $args[0] $groups
            }
            'Patient Financial Services' {
                Write-Output $args[0] ' goes to OU: PFS'
                $groups = @('3M Encoders','Billers','BSMH-CarePath-Access','CTX-AppEpicPRD-Wyandot','Cisco Sparks Denied','Patient Access Log', 'PFS Group')
                Set-Membership $args[0] $groups
            }
            'Oncology Services' {
                Write-Output $args[0] ' goes to OU: Oncology Services'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-Wyandot','Oncology Group')
                Set-Membership $args[0] $groups
            }
            'Nursing Services' {
                Write-Output $args[0] ' goes to OU: Nursing Services'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-Wyandot','CTX-AppEpicPRD-Warpdrive-Wyandot','Management Team','Nursing Department','Nursing_access')
                Set-Membership $args[0] $groups
            }
            'Medical Records' {
                Write-Output $args[0] ' goes to OU: Medical Records'
                $groups = @('3M Encoders','BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-Warpdrive-Wyandot','CTX-AppEpicPRD-Wyandot','MRCoders')
                Set-Membership $args[0] $groups
            }
            'SHC' {
                Write-Output $args[0] ' goes to OU: SHC'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','SHC Group')
                Set-Membership $args[0] $groups
            }
            'Laboratory Services' {
                Write-Output $args[0] ' goes to OU: Laboratory Services'
                $groups = @('BSMH-CarePath-Access','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot')
                Set-Membership $args[0] $groups
            }
            'Tarhe Trail' {
                Write-Output $args[0] ' goes to OU: Tarhe Trail'
                $groups = @('BSMH-CarePath-Access','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Physician Services','Physician Services')
                Set-Membership $args[0] $groups

            }
            'Security Services' {
                Write-Output $args[0] ' goes to OU: Security Services'
                $groups = @('Camera Security','Security')
                Set-Membership $args[0] $groups
            }
            'Pharmacy Services' {
                Write-Output $args[0] ' goes to OU: Pharmacy Services'
                $groups = @('BSMH-CarePath-Access', 'CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Nursing Department','Nursing_access','Pharmacy group')
                Set-Membership $args[0] $groups
            }
            'Information Technology' {
                Write-Output $args[0] ' goes to OU: Information Technology'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','IT','memo','SSL-VPN-MFA')
                Set-Membership $args[0] $groups
            }
            'Quality Division' {
                Write-Output $args[0] ' goes to OU: Quality Division'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','memo')
                Set-Membership $args[0] $groups
            }
            'Emergency Department' {
                Write-Output $args[0] ' goes to OU: Emergency Department'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Nursing Department','Nursing_access', 'WMHLucid-Staff')
                Set-Membership $args[0] $groups
            }
            'Radiology & Cardiology' {
                Write-Output $args[0] ' goes to OU: Radiology & Cardiology'
                $groups = @('BSMH-CarePath-Access','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','WMHLUcid-Tech')
                Set-Membership $args[0] $groups
            }
            'Therapy Services' {
                Write-Output $args[0] ' goes to OU: Therapy Services' 
                $groups = @('BSMH-CarePath-Access','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','PT Group')
                Set-Membership $args[0] $groups
            }
            'RHC - Sycamore' {
                Write-Output $args[0] ' goes to OU: RHC - Sycamore'
                $groups = @('BSMH-CarePath-Access','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot')
                Set-Membership $args[0] $groups
            }
            'Wellness Services' {
                Write-Output $args[0] ' goes to OU: Wellness Services'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Wellness Group')
                Set-Membership $args[0] $groups
            }
            'Perioperative Services' {
                Write-Output $args[0] ' goes to OU: Perioperative Services'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Nursing Department','Nursing_access','Surgery Group', 'WMHLucid-Staff')
                Set-Membership $args[0] $groups
            }
            'Finance & Nursing Division' {
                Write-Output $args[0] ' goes to OU: Finance & Nursing Division'
                $groups = @('memo')
                Set-Membership $args[0] $groups
            }
            'ICU' {
                Write-Output $args[0] ' goes to OU: ICU'
                $groups =@('BSMH-CarePath-Access','BSMH-Medex','CCU Group','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Nursing Department','Nursing_Access')
                Set-Membership $args[0] $groups
            }
            'Registration' {
                Write-Output $args[0] ' goes to OU: Registration'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Registration Group')
                Set-Membership $args[0] $groups
            }
            'Accounting' {
                Write-Output $args[0] ' goes to OU: Accounting'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot')
                Set-Membership $args[0] $groups
            }
            'Provider Services' {
                Write-Output $args[0] ' goes to OU: Provider Services'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Physician Services')
                Set-Membership $args[0] $groups
            }
            'Materials' {
                Write-Output $args[0] ' goes to OU: Materials'
                $groups = @('BSMH-CarePath-Access','BSMH-Medex','CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot','Materials','memo')
                Set-Membership $args[0] $groups
            }
            'Wyandot On Wheels' {
                Write-Output $args[0] ' goes to OU: Wyandot On Wheels'
                $groups = @('CTX-AppEpicPRD-WarpDrive-Wyandot','CTX-AppEpicPRD-Wyandot')
                Set-Membership $args[0] $groups
            }
            'Home Health and Hospice Division'{
                Write-Output $args[0] ' goes to OU: Home Health and Hospice'
                $groups = @('HomeHealth-Hospice','SSL-VPN-Access')
            }
            'Home Health Services' {
                Write-Output $args[0] ' goes to OU: Home Health and Hospice'
                $groups = @('HomeHealth-Hospice','SSL-VPN-Access')
                Set-Membership $args[0] $groups
        }
            'Hospice Services' {
                Write-Output $args[0] ' goes to OU: Home Health and Hospice'
                $groups = @('HomeHealth-Hospice','SSL-VPN-Access')
                Set-Membership $args[0] $groups
            }
            'Social Services and Bereavement Services' {
                Write-Output $args[0] ' goes to OU: Social Services and Bereavement Services'
                $groups = @('memo')
                Set-Membership $args[0] $groups
            }
            'Environmental Services' {
                Write-Output $args[0] ' goes to OU: Environmental Services'
                $groups = @('CTX-AppEpicPRD-WarpDrive')
                Set-Membership $args[0] $groups
            }
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
Get-AdUser -Filter * -SearchBase 'OU=Dept Unknown,OU=Users,OU=WMH,DC=wmh,DC=com' -Properties Department,Manager | Select-Object name,SamAccountName,Department,Manager | Export-Excel -Path '\\wmh-it\data$\Automation\AD\UnknownDept.xlsx' 
Send-MailMessage -From 'AD Automation <adautomation@wyandotmemorial.org>' -To 'IT <it@wyandotmemorial.org>' -Subject 'Test email format' -Body $body -SmtpServer wmh-exch.wmh.com -Attachments '\\wmh-it\data$\Automation\AD\UnknownDept.xlsx'






