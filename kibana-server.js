var connect = require('connect');
var serveStatic = require('serve-static');
connect().use(serveStatic(__dirname + '/kibana-3.1.2')).listen(9080);
