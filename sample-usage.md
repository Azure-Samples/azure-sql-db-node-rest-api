# Sample REST API usage with cUrl

Start local Azure Function host with

```bash
func start
```

if you are using [Azure Functions Core Tools](https://www.npmjs.com/package/azure-functions-core-tools) or using [Visual Studio Code Azure Function extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions )

For more info on other options to run Azure Function locally look here:

[Code and test Azure Functions locally](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-local)

## Get a customer

```bash
curl -s -X GET http://localhost:7071/api/customer/123
```

## Create new customer

```bash
curl -s -X PUT  http://localhost:7071/api/customer --header 'content-type: application/json' --data '{"CustomerName": "John Doe", "PhoneNumber": "123-234-5678", "FaxNumber": "123-234-5678", "WebsiteURL": "http://www.something.com", "Delivery": { "AddressLine1": "One Microsoft Way", "PostalCode": 98052 }}'
```

## Update customer

```bash
curl -s -X PATCH http://localhost:7071/customer/1050 --header 'content-type: application/json' --data '{"CustomerName": "Jane Dean", "PhoneNumber": "231-778-5678" }'
```

## Delete a customer

```bash
curl -s -X DELETE http://localhost:7071/customer/1050
```
