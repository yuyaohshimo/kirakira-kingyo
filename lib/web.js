exports.register = function (app, playerInfoDaoMap, RankCol, logger) {
	// routing
	app.get('/', function (req, res) {
		res.render('index.jade');
	});

	// // エントリー画面
	// app.post('/api/top', function (req, res) {
	// 	var t_id = req.body.t_id;
	// 	var name = req.body.name;
	// 	console.log(req.body);
	// 	console.log(t_id);
	// 	console.log(name);
	// 	// TODO t_idとnameを格納して該当するjsをレンダリングしてください
	// 	// req.render('hoge', {'t_id': t_id, 'name':name});
	// 	res.json({ success: true});
	// });

	// 個人成績を返します
	app.get('/api/result', function (req, res) {
		var playerInfoDao = playerInfoDaoMap[req.query.t_id];
		if (!playerInfoDao) {
			res.send(500, {'data': 'no game result for t_id:' + req.query.t_id});
			logger.error('/api/result didnt reply proper result with t_id: ' + req.query.t_id);
		} else {
			res.send(200, playerInfoDao);
			playerInfoDaoMap.pop(playerInfoDao);
			logger.debug('/api/result returns result with t_id' + req.query.t_id);
		}
	});

	// ランキング情報を返します
	app.get('/api/ranking', function (req, res) {
		var sendRankInfos = [];
		var playerId = req.query.playerId;
		// scoreで降順になったランキング情報を取得します
		RankCol.find({}, null, {sort: {score: -1}}, function(err, rankInfos){
  			if(err){
    			logger.error(err);
  			}

  			// リクエストユーザーのランキング情報を生成します
  			var rankNum = 0;
  			var formersScore = 0; // 一つ前の順位のスコア
  			var sameScoreCounter = 0; // 同順位カウンター
  			for (var i in rankInfos) {
  				rankNum++;
  				var info = rankInfos[i];

  				// 一つ前の順位のランカーのスコアと同じならば同順位カウンターを増加させる。そうでない場合は同順位カウンターは0。
				if (Number(formersScore) === Number(info.score)) {
					sameScoreCounter++;
				} else {
					sameScoreCounter = 0;
				}

				// 同順位カウンターを影響をさせたものを順位として格納する
  				if (Number(info.playerId) === Number(playerId)) {
  					var rank = Number(rankNum) - Number(sameScoreCounter);
  					sendRankInfos.push({name: info.name, score: info.score, rank: rank});
  					break;
  				}

  				// スコアの格納
  				formersScore = info.score;
  			}

  			// ない場合はエラーを返す
  			if (sendRankInfos.length === 0) {
  				res.send(500, {'data': 'no ranking data for playerId:' + req.query.playerId});
				logger.error('/api/ranking no ranking data with playerId:' + req.query.playerId);
				return;
  			}

  			// top10ランキング情報を生成します
  			var counterByTen = 0;
  			var formersScoreTen = 0; // 一つ前の順位のスコア
  			var sameScoreCounterTen = 0; // 同順位カウンター
			for (var i in rankInfos) {
				counterByTen++;
				var info = rankInfos[i];

				// 一つ前の順位のランカーのスコアと同じならば同順位カウンターを増加させる。そうでない場合は同順位カウンターは0。
				if (Number(formersScoreTen) === Number(info.score)) {
					sameScoreCounterTen++;
				} else {
					sameScoreCounterTen = 0;
				}

				// 同順位カウンターを影響させたものを順位として格納する
				var rank = Number(counterByTen) - Number(sameScoreCounterTen);
				sendRankInfos.push({name: info.name, score: info.score, rank: rank});
				
				// スコアを格納
				formersScoreTen = info.score;
				if (counterByTen === 10) break;
			}	  		
		


			// ランキング情報を送ります
  			if (!sendRankInfos) {
				res.send(500, {'data': 'no ranking data for playerId:' + req.query.playerId});
				logger.error('/api/ranking no top rankInfos with playerId' + req.query.playerId);
			} else {
				res.send(200, sendRankInfos);
				logger.debug('/api/ranking sent result.');
			}

					// // dummy data
		// var dummy = [
		// 	{
		// 		name: '自分',
		// 		score: 100,
		// 		rank: 30
		// 	},
		// 	{
		// 		name: '１位の人',
		// 		score: 100,
		// 		rank: 1
		// 	},
		// 	{
		// 		name: '２位の人',
		// 		score: 100,
		// 		rank: 2
		// 	},
		// 	{
		// 		name: '３位の人',
		// 		score: 100,
		// 		rank: 3
		// 	},
		// 	{
		// 		name: '４位の人',
		// 		score: 100,
		// 		rank: 4
		// 	},
		// 	{
		// 		name: '５位の人',
		// 		score: 100,
		// 		rank: 5
		// 	},
		// 	{
		// 		name: '６位の人',
		// 		score: 100,
		// 		rank: 6
		// 	},
		// 	{
		// 		name: '７位の人',
		// 		score: 100,
		// 		rank: 7
		// 	},
		// 	{
		// 		name: '８位の人',
		// 		score: 100,
		// 		rank: 8
		// 	},
		// 	{
		// 		name: '９位の人',
		// 		score: 100,
		// 		rank: 9
		// 	},
		// 	{
		// 		name: '１０位の人',
		// 		score: 100,
		// 		rank: 9
		// 	}
		// ];
		// res.json(dummy);
		});
	});
};