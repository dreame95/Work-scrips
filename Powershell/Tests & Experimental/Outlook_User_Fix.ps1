# prompt for user input to get target computer
#prompt for users username
#concantenate filepath and remove the files

$target_host = Read-Host -Prompt "Enter Computer Name"
$target_user = Read-Host -Prompt "Enter the Target Username: "
$target_user_full = $target_user + '.wmh.com'
$target_path = 'C:\Users\' + $target_user_full + '\Appdata\Local\Microsoft\Outlook\'
$session = New-PSSession -ComputerName $target_host -Credential wmh\aeadmin

write-host $target_path

#Write-Host "Deleting Outlook Profile"
#Invoke-Command -Session $session -ScriptBlock {Get-ChildItem -Path $target_path -Recurse | Foreach-Object {Remove-item -Recurse -path $_.FullName}}
#Read-Host -Prompt "Process Complete: Press Enter to quit"


