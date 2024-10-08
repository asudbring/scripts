#!/bin/bash

# Define the list of Azure resource providers
resourceProviders=(
    "Microsoft.Compute"
    "Microsoft.Storage"
    "Microsoft.Network"
    "Microsoft.Web"
    "Microsoft.Sql"
    "Microsoft.KeyVault"
    "Microsoft.ContainerRegistry"
    "Microsoft.ContainerService"
    "Microsoft.Quota"
)

# Set variable for tenant ID
read -p "Please enter a value for the tenant ID: " tenantId

echo "You entered: $tenantId"

# Connect to Azure account
az login --tenant $tenantId

# Get the list of available subscriptions
subscriptions=$(az account list --query "[].{name:name, id:id}" -o tsv)

# If multiple subscriptions are available, prompt the user to select one
subscriptionCount=$(echo "$subscriptions" | wc -l)
if [ $subscriptionCount -gt 1 ]; then
    echo "Select an Azure Subscription:"
    select subscription in $subscriptions; do
        subscriptionId=$(echo $subscription | awk '{print $2}')
        az account set --subscription $subscriptionId
        break
    done
elif [ $subscriptionCount -eq 1 ]; then
    subscriptionId=$(echo $subscriptions | awk '{print $2}')
    az account set --subscription $subscriptionId
else
    echo "No subscriptions found."
    exit 1
fi

# Loop through each resource provider and register it
for provider in "${resourceProviders[@]}"; do
    echo "Registering resource provider: $provider"
    az provider register --namespace $provider
    echo "Registered resource provider: $provider"
done

echo "All resource providers have been registered."