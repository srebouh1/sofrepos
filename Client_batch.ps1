#Disable user notification 
New-ItemProperty -Path HKLM:Software\Microsoft\Windows\CurrentVersion\policies\system -Name EnableLUA -PropertyType DWord -Value 0 -Force

Invoke-WebRequest -Uri "https://aze1fxvdi1.blob.core.windows.net/batch-client/deploy_pversion.ps1" -OutFile "C:\azure_batch_python_deployments\deploy_pversion.ps1"
Invoke-WebRequest -Uri "https://aze1fxvdi1.blob.core.windows.net/batch-client/deploy_pversion.bat" -OutFile "C:\azure_batch_python_deployments\deploy_pversion.bat"