param(
    [parameter(Mandatory=$true, Position=0)][string]$m,  
    [string]$cmd_args = "",   # Ensure cmd_args can be optional
    [string]$pversion = $null # Ensure pversion can be optional
)
#map drives
net use X: '\\aze1fsrvstrp2.file.core.windows.net\xdrive\Prodshare'  VFHzu0IQX/phUrpmumi1KMr3AM4h16cU0AjpdoeNhbpxZCcGUQLa410vHgiNzy3zXG1m0KZJsKeyS0IbUHicMQ== /user:'Arure\aze1fsrvstrp2' /persistent:Yes 
net use G: '\\aze1fsrvstrp2.file.core.windows.net\gdrive\share'  VFHzu0IQX/phUrpmumi1KMr3AM4h16cU0AjpdoeNhbpxZCcGUQLa410vHgiNzy3zXG1m0KZJsKeyS0IbUHicMQ== /user:'Arure\aze1fsrvstrp2' /persistent:Yes 
net use S: '\\aze1fsrvstrp2.file.core.windows.net\gdrive\share\shared'  VFHzu0IQX/phUrpmumi1KMr3AM4h16cU0AjpdoeNhbpxZCcGUQLa410vHgiNzy3zXG1m0KZJsKeyS0IbUHicMQ== /user:'Arure\aze1fsrvstrp2' /persistent:Yes 
net use T: '\\aze1fsrvstrp2.file.core.windows.net\tdrive\analytics'  VFHzu0IQX/phUrpmumi1KMr3AM4h16cU0AjpdoeNhbpxZCcGUQLa410vHgiNzy3zXG1m0KZJsKeyS0IbUHicMQ== /user:'Arure\aze1fsrvstrp2' /persistent:Yes 
# Output the received parameters for verification
Write-Host "Package Name: $m"
Write-Host "Command Args: $cmd_args"
Write-Host "Version: $pversion"

# Example logic using the passed arguments
if ($pversion) {
    Write-Host "Deploying $m with arguments: $cmd_args and version: $pversion"
} else {
    Write-Host "Deploying $m with arguments: $cmd_args with the latest version."
}


# Write-Host "$m"
# Write-Host "$cmd_args"

# Configure $user_directory
Set-StrictMode -Version 3.0
if (!$?) {
    throw "Set-StrictMode FAILED: Could not set to Version 3.0 (SHOULD BE settable as PowerShell 5.1 is being used)"
}
$ErrorActionPreference = "Stop"

# $local_machine_info = @(Get-ComputerInfo)

# $username = $local_machine_info.CsUserName # for example, BETM\Livio.Fetahu
# if (($NULL -eq $username) -OR ($username.equals(""))) {
#     $username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
# }
# Write-Host -ForegroundColor DarkCyan "username = $username"
# Write-Host -ForegroundColor White "`n"

# $username = $Matches.username.ToLower()

# Write-Host -ForegroundColor DarkMagenta "Checking the user directory ..."
# if (-NOT(Test-Path -Path "C:\Users")) {
#     throw "Configuration check FAILED: C:\Users doesn't exist (SHOULD BE a directory)"
# }

# if (Test-Path -Path "C:\Users\$username") {
#     if ($env:USERPROFILE -ne "C:\Users\$username") {
#         throw "Configuration check FAILED: USERPROFILE = $env:USERPROFILE (SHOULD BE C:\Users\$username)"
#     }
# }
# else {
# if (-NOT(($env:USERPROFILE).StartsWith("C:\Users\"))) {
#     throw "Configuration check FAILED: USERPROFILE = $env:USERPROFILE (SHOULD BE C:\Users\<rest>)"
# }
# }
# $user_directory = $env:USERPROFILE
$user_directory = "C:\azure_batch_python_deployments"
# Write-Host -ForegroundColor DarkCyan "user_directory = $user_directory"

# Create app deployment directory and cd into it
# Write-Host "pkg_name=$m"
# Write-Host "cmd_args=$cmd_args"
# Write-Host "pversion=$pversion"

$feed_pkg_name = "$m"
if ($m.Contains(".")) {
    $subpkgs = $feed_pkg_name -Split "\."
    $feed_pkg_name = $subpkgs[0]
}
Write-Host "feed_pkg_name=$feed_pkg_name"
$deployment_directory_name = "deploy_$feed_pkg_name$(Get-Random)"
$deployment_directory_path = "$user_directory\$deployment_directory_name"
mkdir "$deployment_directory_path"
cd "$deployment_directory_path"

# Create Poetry environment
$ErrorActionPreference = "SilentlyContinue"
poetry init --name "$deployment_directory_name" --author "Livio Fetahu <livio.fetahu@betm.com>" --python 3.11.3 -n 2>&1 | %{ "$_" }
# $venv_info = @(poetry env use python)
$venv_info = poetry env use python 2>&1 | %{ "$_" }
$ErrorActionPreference = "Stop"
$venv_info = @($venv_info)[-1]
$venv_dir = $venv_info.substring(18)
. $venv_dir\Scripts\activate.ps1
poetry config http-basic.ftr_pypi livio.fetahu pwr4nw5jfmilgiqfuyscxor4cgitydqgtul7h7go4lmtkm2n6yma
poetry source add --secondary ftr_pypi https://pkgs.dev.azure.com/BETM/Ace/_packaging/ftr_pypi/pypi/simple
poetry add --source ftr_pypi "$feed_pkg_name==$pversion"

# TODO: Here we should map the fileshares S, G, T, X via Sofiane's code, so that the client Python process can see them.
# Sofiane will either include his Powershell logic directly here, or will make a call to his .ps1 script like we do in
# line 68 above (where we run the activate script). If the script is a .bat script, it needs to be executed differently.

# Run client process
Start-Process -FilePath "python" -ArgumentList "-m $m $cmd_args" -NoNewWindow -Wait

# Clean up
Start-Process -FilePath "poetry" -ArgumentList "env remove $venv_dir\Scripts\python" -NoNewWindow -Wait
cd ..
Remove-Item "$deployment_directory_path" -Recurse -Force
