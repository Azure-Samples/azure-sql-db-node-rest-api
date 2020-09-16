---
page_type: sample
languages:
- nodejs
- javascript
- tsql
- sql
products:
- azure
- vs-code
- azure-sql-database
- azure-functions
description: "Creating a modern REST API with Python and Azure SQL, using Flask and Visual Studio Code"
urlFragment: "azure-sql-db-node-rest-api"
---

# Serverless REST API with Azure Functions, Node and Azure SQL

![License](https://img.shields.io/badge/license-MIT-green.svg)

<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

Thanks to native JSON support, creating a serverless REST API with Azure Functions, Azure SQL and Node is really a matter of a few lines of code. Take a look at `customer/index.js` to see how easy it is!

Wondering what's the magic behind? Azure Functions takes care of running the NodeJS code, so all is needed is to get the incoming HTTP request, handle it, send the data as we receive it - a JSON - to Azure SQL and we're done. Thanks to the [native JSON support that Azure SQL provides](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-json-features), it does all the heavy lifting for as so sending data back and forth to the database is as easy as sending a JSON message.

## Install Sample Database

In order to run this sample, the WideWorldImporters database is needed. Install WideWorldImporters sample database:

[Restore WideWorldImporters Database](https://github.com/yorek/azure-sql-db-samples#restore-wideworldimporters-database)

## Add Database Objects

Once the sample database has been installed, you need to add some stored procedure that will be called from Javascript. The SQL code is available here:

`./sql/WideWorldImportersUpdates.sql`

If you need any help in executing the SQL script, you can find a Quickstart here: [Quickstart: Use Azure Data Studio to connect and query Azure SQL database](https://docs.microsoft.com/en-us/sql/azure-data-studio/quickstart-sql-database)

## Run sample locally

Make sure you add the information needed to connect to the desired Azure SQL database in the `local.settings.json`. Create it in the root folder of the sample using the `.template` file, if there isn't one already. After editing the file should look like the following:

```json
{
  "IsEncrypted": false,
  "Values": {
    "FUNCTIONS_WORKER_RUNTIME": "node",
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "db_server": "<server>.database.windows.net",
    "db_database": "<database>",
    "db_user": "NodeFuncApp",
    "db_password": "aN0ThErREALLY#$%TRONGpa44w0rd!"
  }
}
```

where `<server>` and `<database>` have been replaced with the correct values for your environment. Once done that, start local Azure Function host with

```bash
func start
```

if you are using [Azure Functions Core Tools](https://www.npmjs.com/package/azure-functions-core-tools) or using [Visual Studio Code Azure Function extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions)

For more info on other options to run Azure Function locally look here:

[Code and test Azure Functions locally](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-local)

Once the Azure Function HTTP  is up and running you'll see something like

```text
Now listening on: http://0.0.0.0:7071
Application started. Press Ctrl+C to shut down.

Http Functions:

        customer: [GET,PUT,PATCH,DELETE] http://localhost:7071/api/customer/{id:int?}
```

Using a REST Client (like [Insomnia](https://insomnia.rest/), [Postman](https://www.getpostman.com/) or curl), you can now call your API, for example:

```bash
curl -X GET http://localhost:7071/customer/123
```

and you'll get info on Customer 123:

```json
[
    {
        "CustomerID": 123,
        "CustomerName": "Tailspin Toys (Roe Park, NY)",
        "PhoneNumber": "(212) 555-0100",
        "FaxNumber": "(212) 555-0101",
        "WebsiteURL": "http://www.tailspintoys.com/RoePark",
        "Delivery": {
            "AddressLine1": "Shop 219",
            "AddressLine2": "528 Persson Road",
            "PostalCode": "90775"
        }
    }
]
```

Check out more samples to test all implemented verbs here:

[cUrl Samples](./sample-usage.md)

## Debug from Visual Studio Code

Debugging from Visual Studio Code is fully supported, thanks to the [Visual Studio Code Azure Function extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions)

## Deploy to Azure

Now that your REST API solution is ready, it's time to deploy it on Azure so that anyone can take advantage of it. A script `azure-deploy.sh` that uses AZ CLI (so it needs to be executed from a Linux shell. If you don't have one on your machine you can use [Azure Cloud Shell](https://azure.microsoft.com/en-us/features/cloud-shell)) is available within the repo. Just make sure you fill the needed settings into the `local.settings.json` as mentioned before as the script will read the values from there.

```bash
./azure-deploy.sh
```

It will care of everything for you:

- Creating a Resource Group (you can set the name you want by changing it directly in the .sh file)
- Creating a Storage Account
- Creating Azure Application Insights
- Create an Azure Function app
- Deploying repo code to Azure Function

Enjoy!

# Contributing 

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

More details in the full [Contributing](./CONTRIBUTING.md) page.