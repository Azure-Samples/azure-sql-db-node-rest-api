#!/bin/bash

set -euo pipefail

# Make sure these values are correct for your environment
resourceGroup="dm-api-04"
appName="dm-api-04"
storageName="dmapi04"
location="WestUS2" 

# Change this if you are using your own github repository
gitSource="https://github.com/Azure-Samples/azure-sql-db-node-rest-api.git"

# Read values from local.settings.json
export db_server=`cat local.settings.json | jq .Values.db_server -r`
if [[ -z "${db_server:-}" ]]; then
	echo "Please make sure you have 'db_server' set in your local.settings.json file";
	exit 1;
fi

export db_database=`cat local.settings.json | jq .Values.db_database -r`
if [[ -z "${db_database:-}" ]]; then
	echo "Please make sure you have 'db_database' set in your local.settings.json file";
	exit 1;
fi

export db_user=`cat local.settings.json | jq .Values.db_user -r`
if [[ -z "${db_user:-}" ]]; then
	echo "Please make sure you have 'db_user' set in your local.settings.json file";
	exit 1;
fi

export db_password=`cat local.settings.json | jq .Values.db_password -r`
if [[ -z "${db_password:-}" ]]; then
	echo "Please make sure you have 'db_password' set in your local.settings.json file";
	exit 1;
fi

echo "Creating Resource Group...";
az group create \
    -n $resourceGroup \
    -l $location

echo "Creating Application Insight..."
az resource create \
    -g $resourceGroup \
    -n $appName-ai \
    --resource-type "Microsoft.Insights/components" \
    --properties '{"Application_Type":"web"}'

echo "Reading Application Insight Key..."
aikey=`az resource show -g $resourceGroup -n $appName-ai --resource-type "Microsoft.Insights/components" --query properties.InstrumentationKey -o tsv`

echo "Creating Storage Account...";
az storage account create \
    -g $resourceGroup \
    -l $location \
    -n $storageName \
    --sku Standard_LRS

echo "Creating Function App...";
az functionapp create \
    -g $resourceGroup \
    -n $appName \
    --storage-account $storageName \
    --app-insights-key $aikey \
    --consumption-plan-location $location \
    --deployment-source-url $gitSource \
    --deployment-source-branch main \
    --functions-version 2 \
    --os-type Windows \
    --runtime node \
    --runtime-version 10 \


echo "Configuring Connection String...";
az functionapp config appsettings set \
    -g $resourceGroup \
    -n $appName \
    --settings "db_server=$db_server"
    
az functionapp config appsettings set \
    -g $resourceGroup \
    -n $appName \
    --settings "db_database=$db_database"

az functionapp config appsettings set \
    -g $resourceGroup \
    -n $appName \
    --settings "db_user=$db_user"

az functionapp config appsettings set \
    -g $resourceGroup \
    -n $appName \
    --settings "db_password=$db_password"

echo "Done."