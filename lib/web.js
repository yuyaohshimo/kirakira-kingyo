exports.register = function (app, playerInfoDaoMap, RankCol) {
	// routing
	app.get('/', function (req, res) {
		res.render('index.jade');
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
	// TODO 動作確認必要
	app.get('/api/result', function (req, res) {
		console.log(req.query.t_id);
		var playerInfo = playerInfoDaoMap[req.query.t_id];
		console.log('result_info');
		console.log(playerInfo);
		if (!playerInfo) {
			res.send(500, {'data': 'no game result for t_id:' + req.query.t_id});
		} else {
			res.send(200, playerInfo);
		}
	});

	// ランキング情報を返します
	app.get('/api/ranking', function (req, res) {
		var sendRankInfos = [];
		var playerId = req.query.playerId;
		// // scoreで降順になったランキング情報を取得します
		// RankCol.find({}, null, {sort: {score: -1}}, function(err, rankInfos){
  // 			if(err){
  //   			console.log(err);
  // 			}

  // 			// リクエストユーザーのランキング情報を生成します
  // 			// TODO 同じscoreの場合、早くプレイした人のが上位になっていまう問題
  // 			var rankNum = 0;
  // 			for (var i in rankInfos) {
  // 				rankNum++;
  // 				var info = rankInfos[i];
  // 				if (Number(info.playerId) === Number(playerId)) {
  // 					sendRankInfos.push({name: info.name, score: info.score, rank: rankNum});
  // 					break;
  // 				}
  // 			}

  // 			// top10ランキング情報を生成します
  // 			var counterByTen = 0;
		// 	for (var i in rankInfos) {
		// 		counterByTen++;
		// 		var info = rankInfos[i];
		// 		sendRankInfos.push({name: info.name, score: info.score, rank: counterByTen});
		// 		if (counterByTen === 10) break;
		// 	}	  		

		// 	// ランキング情報を送ります
  // 			if (!sendRankInfos) {
		// 		res.send(500, {'data': 'no ranking data for playerId:' + req.query.playerId});
		// 	} else {
		// 		res.send(200, sendRankInfos);
		// 	}
		// });
	});
};