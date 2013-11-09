var express = require('express');
var http = require('http');
var app = express();
var path = require('path');
var basedir = path.join(__dirname, '..');
var util = require('util');
var WebSocketServer = require('ws').Server;
var mongodb = require("mongodb");
var mongoose = require("mongoose");
var httpServer = http.createServer(app);
var wss = new WebSocketServer({ server: httpServer });
var playerInfoDaoMap = []; // プレイヤー情報リストDao (socket -> http)
var log4js = require('log4js');
var twitter = require('twitter');

app.configure(function () {
	app.set('view engine', 'jade');
	app.set('views', path.join(basedir, '/template/jade'));
	app.use(express['static'](path.join(util.format('%s/public', basedir))));
	app.use(express.bodyParser());
	app.set('port', 8888);
});

///////////////////db設定////////////////////////
//dbの設定 (localhost:27017, db:kingyo)
var db = mongoose.connect('mongodb://localhost/kingyo');
// スキーマ宣言
var RankSchema = new mongoose.Schema({
	playerId: Number,
	name: String,
	score: Number
});

// モデルの宣言
var RankCol = db.model('rankCol', RankSchema);
//////////////////////////////////////////////////


//////////////////log設定//////////////////////////
log4js.configure({
  appenders: [
    { type: 'console' },
    { type: 'file', filename: '/usr/local/node/logs/kingyo.log', category: 'kingyo'},
  ]
});

var logger = log4js.getLogger('kingyo');
logger.setLevel('DEBUG');
////////////////////////////////////////////////////

/////////////////twitter設定//////////////////////
var bot = new twitter({
	consumer_key :'QcBScfTDEMwzVaie4F1qnw', 
	consumer_secret: 'Mi0SHzPmbwgneaaQQ8q9kUwtFHZ3ds6wceeK1Uao', 
	access_token_key: '2182251949-kWvFlaYSssmBYBbH2yVPEhbHrNoyrKIoDKpLjrI', 
	access_token_secret : '6b0AsRdBiOpAt7nOLpScgWSepGYkpEILnyeTqWfISW2En'
});
////////////////////////////////////////////////////

require('./web').register(app, playerInfoDaoMap, RankCol, logger, bot);
require('./socket').register(wss, playerInfoDaoMap, RankCol, logger);


// httpServer, websocketServerを起動する
httpServer.listen(app.get('port'), function(){
	logger.info('Express server listening on port', app.get('port'));
});