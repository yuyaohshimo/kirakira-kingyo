var express = require('express');
var http = require('http');
var app = express();
var path = require('path');
var basedir = path.join(__dirname, '..');
var util = require('util');
var WebSocketServer = require('ws').Server;
// var mongodb = require("mongodb");
// var mongoose = require("mongoose");
var httpServer = http.createServer(app);
var wss = new WebSocketServer({ server: httpServer });
var playerInfoDaoMap = []; // プレイヤー情報リストDao (socket -> http)

app.configure(function () {
	app.set('view engine', 'jade');
	app.set('views', path.join(basedir, '/template/jade'));
	app.use(express['static'](path.join(util.format('%s/public', basedir))));
	app.use(express.bodyParser());
	app.set('port', 8888);
});

/////////////////////db設定////////////////////////
// //dbの設定 (localhost:27017, db:kingyo)
// var db = mongoose.connect('mongodb://localhost/kingyo');
// // スキーマ宣言
// var RankSchema = new mongoose.Schema({
//   playerId: Number,
//   name: String,
//   score: Number
// });

// // モデルの宣言
// var RankCol = db.model('rankCol', RankSchema);
////////////////////////////////////////////////////
 var RankCol = ""; // 空モック
require('./web').register(app, playerInfoDaoMap, RankCol);
require('./socket').register(wss, playerInfoDaoMap, RankCol);


// httpServer, websocketServerを起動する
httpServer.listen(app.get('port'), function(){
	console.log('Express server listening on port', app.get('port'));
});