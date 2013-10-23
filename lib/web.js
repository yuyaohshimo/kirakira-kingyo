exports.register = function (app, playerInfoDaoMap, RankCol) {
	// routing
	app.get('/', function (req, res) {
		res.render('index.jade');
	});

	// エントリー画面
	app.post('/api/top', function (req, res) {
		var t_id = req.body.t_id;
		var name = req.body.name;
		console.log(req.body);
		console.log(t_id);
		console.log(name);
		// TODO t_idとnameを格納して該当するjsをレンダリングしてください
		// req.render('hoge', {'t_id': t_id, 'name':name});
		res.json({ success: true});
	});

	// 個人成績を返します
	app.get('/api/result', function (req, res) {
		console.log(req.query.t_id);
		var playerInfoDao = playerInfoDaoMap[req.query.t_id];
		console.log('result_info');
		console.log(playerInfoDao);
		if (!playerInfoDao) {
			res.send(500, {'data': 'no game result for t_id:' + req.query.t_id});
		} else {
			res.send(200, playerInfoDao);
			playerInfoDaoMap.pop(playerInfoDao);
			console.log("result data pope:" );
		}
	});

	// ランキング情報を返します
	app.get('/api/ranking', function (req, res) {
		var sendRankInfos = [];
		var playerId = req.query.playerId;
		// scoreで降順になったランキング情報を取得します
		RankCol.find({}, null, {sort: {score: -1}}, function(err, rankInfos){
  			if(err){
    			console.log(err);
  			}

  			// リクエストユーザーのランキング情報を生成します
  			// TODO 同じscoreの場合、早くプレイした人のが上位になっていまう問題
  			var rankNum = 0;
  			for (var i in rankInfos) {
  				rankNum++;
  				var info = rankInfos[i];
  				if (Number(info.playerId) === Number(playerId)) {
  					sendRankInfos.push({name: info.name, score: info.score, rank: rankNum});
  					break;
  				}
  			}

  			// top10ランキング情報を生成します
  			var counterByTen = 0;
			for (var i in rankInfos) {
				counterByTen++;
				var info = rankInfos[i];
				sendRankInfos.push({name: info.name, score: info.score, rank: counterByTen});
				if (counterByTen === 10) break;
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

			// ランキング情報を送ります
  			if (!sendRankInfos) {
				res.send(500, {'data': 'no ranking data for playerId:' + req.query.playerId});
			} else {
				res.send(200, sendRankInfos);
			}
		});
	});
};