#!/bin/bash

set -euo pipefail

# Make sure these values are correct for your environment
resourceGroup="dm-api-04"
appName="dm-api-04"
storageName="dmapi04"
location="WestUS2" 

# Change this if you are using your own github repository
gitSource="https://github.com/Azure-Samples/azure-sql-db-node-rest-api.git"

# Make sure variables are sent in local.settings.json
if [[ -z "${db_server:-}" ]]; then
	echo "Please export Azure SQL server to use:";
    echo "export db_server=\"your-database-name-here\".database.windows.net";
	exit 1;
fi
if [[ -z "${db_database:-}" ]]; then
	echo "Please export Azure SQL database to use:";
    echo "export db_database=\"your-database-name-here\"";
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
    --settings 'db_user=NodeFuncApp'     

az functionapp config appsettings set \
    -g $resourceGroup \
    -n $appName \
    --settings 'db_password=aN0ThErREALLY#$%TRONGpa44w0rd!'     

echo "Done."