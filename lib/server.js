var express = require('express');
var http = require('http');
var app = express();
var path = require('path');
var basedir = path.join(__dirname, '..');
var util = require('util');
var WebSocketServer = require('ws').Server;
// var mongodb = require("mongodb");
// var mongoose = require("mongoose");


var flash_t_id = 10;
var httpServer = http.createServer(app);
var wss = new WebSocketServer({server:httpServer});
var connects = [];
var playerInfoMap = [];

app.configure(function () {
	app.set('view engine', 'jade');
	app.set('views', path.join(basedir, '/template/jade'));
	app.use(express['static'](path.join(basedir + '/public')));
	app.use(express.bodyParser());
	app.set('port', 8888);
});

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
// var rankInfo = new RankInfo();
// rankInfo.playerId = 001;
// rankInfo.name = 'test001';
// rankInfo.score = 0;
// // save
// rankInfo.save(function(err){
//   if(err){ 
//     return; 
//   }
//   console.log("save success");
// });

// // find
// RankInfo.find(function(err, items){
//   if(err){
//     console.log(err);
//   }
//   console.log("find success");
//   console.log(items);
// });

//////////////////////////////////////////////////////////

// routing
// スタート画面
app.get('/', function (req, res) {
	res.render('user');
});

// エントリー画面
app.post('/entry', function (req, res) {
	var t_id = res.body.t_id;
	var name = res.body.name;
	// TODO t_idとnameを格納して該当するjsをレンダリングしてください
	// req.render('hoge', {'t_id': t_id, 'name':name});
});

// 個人成績画面
app.get('/result', function (req, res) {
	// req.render('hoge'); // TODO 該当するjsをレンダリングしてください
});

// ランキング画面
app.get('/ranking', function (req, res) {
	// req.render('hoge'); // TODO 該当するjsをレンダリングしてください
}); 

// 個人成績を返します
app.get('/api/result', function (req, res) {
	console.log(req.query.t_id);
	var playerInfo = playerInfoMap[req.query.t_id];
	console.log('result_info');
	console.log(playerInfo);
	if (!playerInfo) {
		res.send(500, {'data': 'no game result for t_id:' + req.query.t_id});
	} else {
		res.send(200, playerInfo);
	}
});

// ↑動作確認用
app.get('/api/test_entry', function (req, res) {
	var t_id = req.query.t_id;
	var checkPlayerInfo = playerInfoMap[t_id];
	var playInfo;
	if (!checkPlayerInfo) {
		playerInfo = {'t_id': t_id, 'fishInfoList': ['fishType1', 'fishType2']};
		playerInfoMap[t_id] = playerInfo;
		console.log('map');
		console.log(playerInfoMap);
	}
	console.log('playerInfo');
	console.log(playerInfo);
	res.send(200, playerInfo);
}) 

// ランキング情報を返します
app.get('/api/ranking', function (req, res) {
	var rankInfo = getRankInfo(req.query.playerId);
	if (rankInfo) {
		res.send(500, {'data': 'no ranking data for playerId:' + req.query.playerId});
	} else {
		res.send(200, rankInfo);
	}
});

// function savePlayerInfo (playerInfo) {

// }

// // 
// function getRankInfo (playerId) {

// }

// 疎通確認用。本番では使いません。
 app.get('/main', function (req, res) {
 	res.render('main');
 });

// 動作確認用。本番では使いません。
app.get('/chart', function (req, res) {
	res.render('chart');
});



// socketサーバーの処理
wss.on('connection', function(ws){
	console.log('established websocket connection');
	// ソケットをconnetsに格納します
	connects.push(ws);

	// flashつなぎ込みdebug用
	broadcast('connect_success');

	// messageイベントの処理
	ws.on('message', function(data, flag){
		console.log('message ok');

		// messageデータをパースします
		var parsedData = JSON.parse(data);
		var dataId = parsedData.id;
		console.log(dataId);

		// ゲームの準備をし、フラッシュにゲーム開始の合図を送ります
		if (dataId === 'game.prep') {
			console.log('in game.prep');
			var t_id = parsedData.data.t_id;
			var name = parsedData.data.name;
			var playerId = new Date().time; // TODO 適当なので直す

			// 端末IDからプレイヤー情報を生成してフラッシュに送ります。すでにプレイヤーが存在する場合はエラーを返します。
			var checkPlayerInfo = playerInfoMap[t_id];
			if (!checkPlayerInfo) {
				unicast(t_id, JSON.stringify({'data': 'already exist t_id:' + t_id}));
			} else {
				playerInfoMap[t_id] = {'playerId': playerId, 't_id': t_id, 'name': name };
				// game.startです
				unicast(flash_t_id, {'t_id':t_id, 'name':name});
			}
		}

		// 各端末の位置情報を送ります
		if (dataId === 'game.locate') {
			console.log('in game.locate');
			unicast(flash_t_id, JSON.stringify(parsedData));
		}

		// flashでの魚獲得情報をplayerInfoに格納し、さらに、獲得情報を端末に送ります。
		// 魚獲得情報がない場合はflashにエラー情報を返します。
		if (dataId === 'game.fish') {
			console.log('in game.fish');
			// 釣った魚情報をplayerInfoに格納します
			var t_id = parsedData.data.t_id;
			var fishInfo = parsedData = parsedData.data.fishInfo;
			if (fishInfo) {
				putFish(t_id, parsedData.data.fishInfo);
				unicast(t_id, fishInfo);
			} else {
				unicast(flash_t_id, JSON.stringify({'data':'no fish data at game.fish of t_id' + t_id}));
			}
		}

		if (dataId === 'game.life') {
			console.log('in game.life');
			var t_id = parsedData.data.t_id;
			var lastLife = parsedData.data.lastLife;
			if (!lastLife) {
				playerInfo = playerInfoMap[t_id];
				if (playerInfo) {
					savePlayerInfo(playerInfo);
				} else {
					// TODO error処理 no playerInfo
				}
			}
			unicast(t_id, JSON.stringify({'lastLife': lastLife}));
		}

		// flashつなぎ込み用
		if (dataId === 'test') {
			console.log('test success');
			broadcast('test_success');
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
httpServer.listen(app.get('port'), function(){
	console.log('Express server listening on port' + app.get('port'));
});