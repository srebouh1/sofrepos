$MyApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "PowerWorld Simulator 22"}
  if ( $MyApp.name -eq  "PowerWorld Simulator 23") 
{
$MyApp.Uninstall()
Write-Host "uninstalled"
} 
else
{Write-Host "uninstalled" }

