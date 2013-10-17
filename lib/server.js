var express = require('express');
var http = require('http');
var app = express();
var path = require('path');
var basedir = path.join(__dirname, '..');
var util = require('util');
var WebSocketServer = require("ws").Server;

var httpServer = http.createServer(app);
var wss = new WebSocketServer({server:httpServer});
var connects = [];

app.configure(function () {
	app.set('view engine', 'jade');
	app.set('views', path.join(basedir, '/template/jade'));
	app.use(express['static'](path.join(basedir + '/public')));
	app.set('port', 8888);
});

// git test4
// git test5

// routing
app.get('/', function (req, res) {
	res.render('user');
});

app.get('/main', function (req, res) {
	res.render('main');
});

app.get('/chart', function (req, res) {
	res.render('chart');
});

// socketサーバーの処理
wss.on("connection", function(ws){
	console.log("established websocket connection");
	// ソケットをconnetsに格納します
	connects.push(ws);

	// flashつなぎ込みdebug用
	broadcast("connect_success");

	// messageイベントの処理
	ws.on("message", function(data, flag){
	console.log("message ok");

	// messageデータをパースします
	var parsedData = JSON.parse(data);
	var dataId = parsedData.id;
	console.log(dataId);

	// messageデータのidがgame.locateの場合
	if (dataId === "game.locate") {
		console.log(parsedData);
		broadcast(JSON.stringify(parsedData));
	}

	// flashつなぎ込み用
	if (dataId === "test") {
		console.log("test success");
		broadcast("test_success");
	}


	});
});

// つないでいる端末すべてにデータを送ります
function broadcast (message) {
	connects.forEach(function (socket, i) {
		socket.send(message);
	});
}

// 指定した端末のみにデータを送ります
function unicast (t_id, message) {
	connects.forEach(function (socket, i) {
		console.log(socket.t_id);
		if (socket.t_id === t_id) {
			socket.send(message);
		} 
	})
}

// httpServer, websocketServerを起動する
httpServer.listen(app.get("port"), function(){
	console.log("Express server listening on port" + app.get("port"));
});