gwmi Win32_Product -filter "name like 'Java%' " | % { $_.Uninstall() }

gwmi Win32_Product -filter "name like 'Java%' " | % { if (Get-Member -In $_ -Name "Uninstall" -Mem Method) { Write-Host "Uninstalling $($_.Name)"; $_.Uninstall().ReturnValue; } }
gwmi Win32_Product -filter "name like 'Java%' " | % { if (Get-Member -In $_ -Name "Uninstall" -Mem Method) { Write-Host "Uninstalling $($_.Name)" } }



Invoke-WebRequest -Uri 'https://aze1script.blob.core.windows.net/scripts/jre-8u311-windows-x64.exe' -OutFile 'c:\temp\jre-8u311-windows-x64.exe'
Invoke-Expression -Command 'c:\temp\jre-8u311-windows-x64.exe /s'
