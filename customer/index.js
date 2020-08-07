var Connection = require('tedious').Connection;
var Request = require('tedious').Request
var TYPES = require('tedious').TYPES;

const executeSQL = (context, verb, entity, payload) => {
    var result = "";    
    const paramPayload = (payload != null) ? JSON.stringify(payload) : '';
    context.log(payload);

    // Create Connection object
    const connection = new Connection({
        server: process.env["db_server"],
        authentication: {
            type: 'default',
            options: {
                userName: process.env["db_user"],
                password: process.env["db_password"],
            }
        },
        options: {
            database: process.env["db_database"],
            encrypt: true
        }
    });

    // Create the command to be executed
    const request = new Request(`web.${verb}_${entity}`, (err) => {
        if (err) {
            context.log.error(err);            
            context.res.status = 500;
            context.res.body = "Error executing T-SQL command";
        } else {
            context.res = {
                body: result
            }   
        }
        context.done();
    });    
    if (payload)
        request.addParameter('Json', TYPES.NVarChar, paramPayload, Infinity);

    // Handle 'connect' event
    connection.on('connect', err => {
        if (err) {
            context.log.error(err);              
            context.res.status = 500;
            context.res.body = "Error connecting to Azure SQL query";
            context.done();
        }
        else {
            // Connection succeeded so execute T-SQL stored procedure
            // if you want to executer ad-hoc T-SQL code, use connection.execSql instead
            connection.callProcedure(request);
        }
    });

    // Handle result set sent back from Azure SQL
    request.on('row', columns => {
        columns.forEach(column => {
            result += column.value;                
        });
    });

    // Connect
    connection.connect();
}

module.exports = function (context, req) {    
    const method = req.method.toLowerCase();
    var payload = null;
    var entity = "";

    switch(method) {
        case "get":
            if (req.params.id) {
                entity = "customer"
                payload = { "CustomerID": req.params.id };            
            } else {
                entity = "customers"                
            }
            break;
        case "patch":
            entity = "customer"
            payload = req.body;  
            if (req.params.id) 
                payload.CustomerID = req.params.id;
            break;
        case "put":
            entity = "customer"
            payload = req.body;              
            break;
        case "delete":
            entity = "customer"
            if (req.params.id) {
                entity = "customer"
                payload = { "CustomerID": req.params.id };            
            }
            break;       
    }

    executeSQL(context, method, entity, payload)
}