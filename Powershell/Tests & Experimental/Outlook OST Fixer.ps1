$userName = Read-Host -Prompt "What is the username?"
$path1 = 'C:\Users\'
$path2 = '\AppData\Local\Microsoft\Outlook\'
$fullPath = $path1 + $userName + $path2
Write-Host $fullPath
Get-ChildItem -Path $fullPath -Recurse | Foreach-Object {Remove-item -Recurse -path $_.FullName}
Read-Host -Prompt "Process Complete: Press Enter to quit"
