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

app.configure(function () {
	app.set('view engine', 'jade');
	app.set('views', path.join(basedir, '/template/jade'));
	app.use(express['static'](path.join(util.format('%s/public', basedir))));
	app.use(express.bodyParser());
	app.set('port', 8888);
});

require('./web').register(app);
require('./socket').register(wss);

/////////////////////db設定////////////////////////

// //dbの設定 (localhost:27017, db:kingyo)
// var db = mongoose.connect('mongodb://localhost/kingyo');
// // スキーマ宣言
// var RankInfoSchema = new mongoose.Schema({
//   playerId: Number,
//   name: String,
//   score: Number
// });

// // モデルの宣言
// var RankInfo = db.model('rankInfo', RankInfoSchema);
////////////////////////////////////////////////////




//////////////////////////////////////////////////////////

// // ランキング情報をDBに保存します
// function saveRankInfo (rankInfo) {
// 	var parsedRankInfo = JSON.parse(rankInfo);
// 	var rankInfo = new RankInfo();
// 	rankInfo.playerId = rankInfo.playerId;
// 	rankInfo.name = rankInfo.name;
// 	rankInfo.score = rankInfo.score;
// 	// save
// 	rankInfo.save(function(err){
//   		if(err){ 
//   			console.log(err);
//     		return; 
//   		}
//   		console.log("save done");
// 	});
// }

// // DBからフェッチしたランキング情報を返します
// function fetchRankInfoList () {
// 	RankInfo.find(function(err, items){
//   	if(err){
//     	console.log(err);
//   	}
//   	console.log("find success");
//   	console.log(items);
//   	return items;
// });
// }

// // scoreでソートしまたリストを返します
// function scoreSortedRankInfoList (RankInfoList) {

// }

// // 上位10人を情報を返します
// function getTopTenRankers (scoreSortedRankInfoList) {

// }

// // 指定したプレイヤーのランクを取得します
// function getRank(playerId) {

// }

// httpServer, websocketServerを起動する
httpServer.listen(app.get('port'), function(){
	console.log('Express server listening on port', app.get('port'));
});