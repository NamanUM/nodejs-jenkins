var express = require('express');
var app = express();

app.get('/', function (req, res) {
    res.send('{ "response": "Hello welcome to the cloud computing" }');
});

app.get('/will', function (req, res) {
    res.send('{ "response": "Hello World" }');
});
app.get('/ready', function (req, res) {
    res.send('{ "response": " hurray!, Its working fine!" }');
});
app.listen(process.env.PORT || 3500);
module.exports = app;

