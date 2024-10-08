# Define the list of Azure resource providers
$resourceProviders = @(
    "Microsoft.Compute",
    "Microsoft.Storage",
    "Microsoft.Network",
    "Microsoft.Web",
    "Microsoft.Sql",
    "Microsoft.KeyVault",
    "Microsoft.ContainerRegistry",
    "Microsoft.ContainerService",
    "Microsft.Quota"
)

# Set variable for tenant ID

$tenantId = Read-Host -Prompt "Please enter a value for the tenant ID"

Write-Output "You entered: $tenantId"

# Connect to Azure account
Connect-AzAccount -Tenant $tenantId

# Get the list of available subscriptions
$subscriptions = Get-AzSubscription

# If multiple subscriptions are available, prompt the user to select one
if ($subscriptions.Count -gt 1) {
    $subscription = $subscriptions | Out-GridView -Title "Select an Azure Subscription" -PassThru
    Set-AzContext -SubscriptionId $subscription.Id
} elseif ($subscriptions.Count -eq 1) {
    Set-AzContext -SubscriptionId $subscriptions[0].Id
} else {
    Write-Output "No subscriptions found."
    exit
}

# Loop through each resource provider and register it
foreach ($provider in $resourceProviders) {
    Write-Output "Registering resource provider: $provider"
    Register-AzResourceProvider -ProviderNamespace $provider
    Write-Output "Registered resource provider: $provider"
}

Write-Output "All resource providers have been registered."

