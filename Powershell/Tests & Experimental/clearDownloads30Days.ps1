############################################
# Clears files from Downloads after 90 Days#
############################################


$users = @(Get-WmiObject -ClassName Win32_UserProfile | Select-Object -Property LocalPath)
$daysBack = "-90"
$currentDate = Get-Date
$dateToDelete = $currentDate.AddDays($daysBack)
foreach($i in $users){
    #Strip the weird formating that Powershell Gives
    $temp = $i -replace 'LocalPath='
    $temp = $temp -replace '[@{}]'
    $path = $temp +'\Downloads\'

    # check if file path exists
    if(Test-Path -Path $path){
        #Directory Exists
        Get-ChildItem $path -Recurse  | Where-Object {$_.LastWriteTime -lt $dateToDelete} | Remove-Item
    }else{
        #Do Nothing
    }
}