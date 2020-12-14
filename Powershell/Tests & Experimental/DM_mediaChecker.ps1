$deviceName = $env:COMPUTERNAME
$filePath = 'C:\' + $deviceName + '.txt'

Get-PnpDevice -Class 'media' | Out-File -FilePath $filePath