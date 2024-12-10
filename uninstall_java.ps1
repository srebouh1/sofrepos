$jre_installed = Get-WmiObject -Class Win32_Product -Filter "Name like '%Java%'"
$jre_installed.Uninstall()
Write-Output "Java_uninstalled"