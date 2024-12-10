
Login-AzAccount -Tenant 7e572efb-19a0-444a-8425-45b37c50ef49 -Subscription 09cf3e65-86ca-4b35-9060-c5d39b31d312

$resourcegroupName="aze1-datf-prd"
$accountName="nautilusedl"
$account= Get-AzStorageAccount -ResourceGroupName $resourcegroupName -Name $accountName
$ctx = $account.Context

$filesystemName = "azurecostexports"
$dirname="monthlyexportmtddev/"
$sgc= Get-AzADGroup -Filter "DisplayName eq 'BETM IT SECURITY'"
$sgcOId = $sgc.Id
$Id = $sgc.Id
$dir=Get-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Path $dirname

#$acl = New-AzDataLakeGen2ItemAclObject -AccessControlType group -EntityId $id -Permission "rw-" -InputObject $dir.ACL
# set permition by inheritance 
$acl = set-AzDataLakeGen2ItemAclObject -AccessControlType user -EntityId $userID -Permission "rw-" -DefaultScope
Update-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Path $dirname -Acl $acl
Set-AzDataLakeGen2AclRecursive -Context $ctx -FileSystem $filesystemName -Path $dirname -Acl $acl

$dir=Get-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Path $dirname 
$dir.AC
$dir.Permissions