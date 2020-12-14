(New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\wmh-print\MR-Copier")

(New-Object -ComObject WScript.Network).SetDefaultPrinter('\\wmh-print\MR-Copier')