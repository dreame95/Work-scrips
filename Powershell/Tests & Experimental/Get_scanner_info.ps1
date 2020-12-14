<#
    Script to create file with Model Number of scanner
    if a scanner is found.

    Idea is to have case run this on every computer and then check
    if file exists and report that info back

    #TODO maybe use Send-MailMessage cmdlet to email the contents of the file
#>
try{
    Write-Host "Scanners Found: Writing to file"
    Get-PnpDevice -Class Image | Out-File "C:\scanners.txt"
    Write-Host "Writing to file complete"
    $fileContent = Get-Content "C:\scanners.txt"
   
    Send-MailMessage -To austinessinger@gmail.com -From austinessinger@gmail.com -Subject $env:computername -Body $fileContent -Credential (Get-Credential) -SmtpServer "smtp.gmail.com" -Port 465
}
Catch{
    Write-Host "No Scanners Found: or Error Occured"
}