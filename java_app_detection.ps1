$jre = Get-WmiObject -Class Win32_Product -Filter "Name like '%Java%'"
if($jre.Name -ne $null)
{
Write-host “java found. Trigger Remediation script to uninstall”
Exit 1
}
if($jre.Name -eq $null)
{
Write-host “java not found. Computer is compliant”
Exit 0
}