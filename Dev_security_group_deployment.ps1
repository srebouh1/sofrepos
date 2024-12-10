# Install the Azure PowerShell module if not already installed
# Install-Module -Name Az -AllowClobber

# Connect to your Azure subscription
Connect-AzAccount -Subscription "f8b06363-df38-4545-bf29-e293eeb00b4d"

# Set variables
$resourceGroupNames = "aze1-adap2int-dev3", "aze1-assetanlt-dev", "aze1-ais-dev", "aze1-assetmeta-dev", "aze1-betmapi-dev", "aze1-entutil-dev", "aze1-ftrtransform-dev", "aze1-fwdcure-dev", "aze1-infra-dev", "aze1-keerthan-d1",  "aze1-mktintel-dev", "aze1-mrktintg-dev", "aze1-operations-dev", "aze1-pjmallcall-dev", "aze1-prism-dev", "aze1-prtflioprtl-dev", "ze1-weather-dev", "aze1-whook-dev", "aze1-xpress1-dev", "aze1-xprmdnrpt-dev", "aze1-xpsflprcs-dev"
$securityGroupName = "SGC_AppServices_Contributor"
$securityGroupID = "1d6434a8-5005-44ce-8de9-1e2b0bd0643e"

# Get the resource group


# Get the security group

foreach ($resourceGroupName in $resourceGroupNames) {
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -errorAction SilentlyContinue
# Assign the "Reader" role to the security group for the resource group
New-AzRoleAssignment -ObjectId $securityGroupID -RoleDefinitionName "Logic Apps Standard Contributor (Preview)" -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue}


