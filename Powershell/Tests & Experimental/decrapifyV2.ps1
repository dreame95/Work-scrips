$excludedApps = '.*photos.*|.*calculator.*|.*sticky.*'

$unwantedApps = Get-AppxPackage -PackageTypeFilter Bundle | Where-Object {$_.Name -notmatch $excludedApps}

If ($unwantedApps) {

    $unwantedApps | Remove-AppxPackage
}