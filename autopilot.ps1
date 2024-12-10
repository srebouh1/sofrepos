cd\
md Autopilot1
cd AutoPilot1
powershell.exe
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
save-script -name get-WindowsAutoPilotInfo -Path C:\AutoPilot1
.\Get-WindowsAutoPilotInfo.ps1 -outputfile C:\AutoPilot1\AutoPilot.csv
.\Get-WindowsAutoPilotInfo.ps1 -outputfile E:\AutoPilot.csv
