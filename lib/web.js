exports.register = function (app) {
	// routing
	// 疎通確認用。本番では使いません。
	 app.get('/main', function (req, res) {
	 	res.render('main');
	 });

	// 動作確認用。本番では使いません。
	app.get('/chart', function (req, res) {
		res.render('chart');
	});
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
	});

	// ランキング情報を返します
	app.get('/api/ranking', function (req, res) {
		var rankInfo = getRankInfo(req.query.playerId);
		if (rankInfo) {
			res.send(500, {'data': 'no ranking data for playerId:' + req.query.playerId});
		} else {
			res.send(200, rankInfo);
		}
	});
};