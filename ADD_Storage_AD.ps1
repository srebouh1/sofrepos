Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
 
.\CopyToPSPath.ps1 
 
Import-Module -Name AzFilesHybrid
 
Connect-AzAccount
 
$SubscriptionId = "09cf3e65-86ca-4b35-9060-c5d39b31d312"
Get-AzResourceGroup -name "aze1-awvd-prd"
$ResourceGroupName = "aze1-awvd-prd"
$StorageAccountName = "aze1crpwvdstrp1"
 
Select-AzSubscription -SubscriptionId $SubscriptionId
 
Join-AzStorageAccountForAuth `
        -ResourceGroupName $ResourceGroupName `
        -Name $StorageAccountName `
        -DomainAccountType "ComputerAccount" `
        -OrganizationalUnitName "Boston" 
        Debug-AzStorageAccountAuth -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName -Verbose
