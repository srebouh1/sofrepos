function Get-folder-name {
    param (
        [sting] $path,
        [sting] $patern
           )

           try {
            if (-not (test-path -path $path) ) {
            write-host "the $path doesn't exist"
            
            }
            $file_names= get-childitem  -path $path -directory -resursive | where-object {$_.name -like $patern}
           #output 
           return $file_names
        }
           catch {
            write-host "no directory with $path name"
            <#Do this if a terminating exception happens#>
           }
    








}