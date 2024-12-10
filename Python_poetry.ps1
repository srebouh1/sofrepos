# Define paths
$pythonInstallPath = "C:\Python\Python3_11_0"
$poetryInstallPath = "C:\Python_Poetry"

# Install Python silently for all users
# Download Python installer
$pythonInstallerUrl = "https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe"
$pythonInstallerPath = Join-Path $env:TEMP "python-installer.exe"
Invoke-WebRequest -Uri $pythonInstallerUrl -OutFile $pythonInstallerPath
# Install Python without user interaction
Start-Process -Wait -FilePath $pythonInstallerPath -ArgumentList "/quiet", "InstallAllUsers=1", "TargetDir=$pythonInstallPath", "PrependPath=1", "Include_test=0"
#Start-Process -Wait -FilePath "msiexec.exe" -ArgumentList "/i", "https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe", "/quiet", "TargetDir=$pythonInstallPath", "InstallAllUsers=1", "PrependPath=1", "Include_test=0"

# Add Python to system environment variables
[Environment]::SetEnvironmentVariable("Path", "$($env:Path);$pythonInstallPath", [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("PYTHON_HOME", $pythonInstallPath, [EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("PYTHON_PATH", "${pythonInstallPath}\python.exe", [EnvironmentVariableTarget]::Machine)

# Install Poetry
[Net.WebRequest]::Create("https://bootstrap.pypa.io")
$env:POETRY_HOME = "C:\Python_Poetry"
$env:POETRY_VERSION = "1.4.2"

(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | C:\Python\Python3_11_0\python.exe -

# Add Poetry to system environment variables
[Environment]::SetEnvironmentVariable("Path", "$($env:Path);$poetryInstallPath\bin", [EnvironmentVariableTarget]::Machine)
