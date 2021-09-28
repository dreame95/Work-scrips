reg add HKU\.DEFAULT\Software\Sysinternals\BGInfo /v EulaAccepted /t REG_DWORD /d 1 /f

\\wmh\netlogon\bginfo\Bginfo.exe \\wmh\netlogon\bginfo\config.bgi /TIMER:00 /nolicprompt