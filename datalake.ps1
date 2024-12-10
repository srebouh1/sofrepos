Login-AzAccount -Tenant 7e572efb-19a0-444a-8425-45b37c50ef49 -Subscription f8b06363-df38-4545-bf29-e293eeb00b4d
$ctx = New-AzStorageContext -StorageAccountName 'xpressstgqueuedevtest' -UseConnectedAccount
$filesystemName = "myfilesystem"
New-AzStorageContainer -Context $ctx -Name $filesystemName

$dirname = "directory1"
New-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Path $dirname -Directory
$dir = New-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Path $dirname -Directory -Permission rwxrwxrwx -Umask ---rwx---  -Property @{"ContentEncoding" = "UDF8"; "CacheControl" = "READ"} -Metadata  @{"tag1" = "value1"; "tag2" = "value2" }
#$filesystemName = "my-file-system"
#$dirname = "my-directory/"
$dir =  Get-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Path $dirname
$dir.ACL
$dir.Permissions
$dir.Group
$dir.write
$dir.Properties
$dir.Properties.Metadata

############################################################################################
# Set variables for the data lake and the ACL
$accountName = "xpressstgqueuedevtest"
$resourceGroupName = "infra-testing-dev"
$location = "East US"
$filesystemName = "<your-filesystem-name>"
$folderPath = "<your-folder-path>"
$acl = "<your-acl-value>"

# Authenticate to Azure
Connect-AzAccount

# Create a new data lake storage account
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $accountName -Location $location -SkuName Standard_LRS -Kind StorageV2 -EnableHierarchicalNamespace $true

# Create a new file system within the data lake storage account
$filesystem = New-AzDataLakeGen2FileSystem -AccountName $accountName -ResourceGroupName $resourceGroupName -Name $filesystemName

# Create a new folder within the file system
New-AzDataLakeGen2Item -Context $filesystem.Context -Path $folderPath -Folder

# Set the ACL for the folder
Set-AzDataLakeGen2ItemAcl -Context $filesystem.Context -FileSystem $filesystemName -Path $folderPath -AceType User -Id "<your-user-id>" -Permissions $acl
