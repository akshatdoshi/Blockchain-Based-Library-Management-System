var express = require('express');
var path = require('path');
var bodyParser = require('body-parser');
var app = express();

var routes = require('./routers/pages.js');
var modules = require('./routers/module.js');

var port = process.env.PORT || 5000;
app.use(express.static(path.join(__dirname, 'public')));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded());

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
app.set('port', process.env.PORT || port);


app.get('/addLibrarian',modules.addLibrarianGet);
app.post('/addLibrarian',modules.addLibrarian);

app.get('/viewBook',modules.viewBookget);

app.get('/addMember',modules.addMemberGet);
app.post('/addMember',modules.addMemberPost);

app.get('/addBook',modules.addBookGet);
app.post('/addBook',modules.addBookPost);

app.get('/addMultipleBook',modules.addMultipleBookGet);
app.post('/addMultipleBook',modules.addMultipleBookPost);

app.get('/addStock',modules.addStockGet);
app.post('/addStock',modules.addStockPost);

app.get('/issueBook',modules.issueBookGet);
app.post('/issueBook',modules.issueBookPost);

app.get('/returnBook',modules.returnBookGet);
app.post('/returnBook',modules.returnBookPost);


app.listen(port, function() {
  console.log("Listening on " + port);

});
