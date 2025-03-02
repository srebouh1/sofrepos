param(
    [Parameter(Mandatory=$true)][string]$m,
    [string]$cmd_args,
    [string] $version
)
# test

 Write-Host "$m"
 Write-Host "$cmd_args"
 Write-Host $version
