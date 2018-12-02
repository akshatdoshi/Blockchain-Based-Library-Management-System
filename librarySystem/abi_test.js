var fs = require('fs');
var jsonFile = "LMS.json";
var parsed= JSON.parse(fs.readFileSync(jsonFile));
var abi = parsed.abi;
console.log(abi);