exports.register = function (wss) {
	var connects = [];
	var playerInfoMap = [];
	var flash_t_id = 10;

	// socketサーバーの処理
	wss.on('connection', function (ws, RankCol){
		console.log('established websocket connection');
		// ソケットをconnetsに格納します
		connects.push(ws);

		// ws.on('close', function (ws) {
		// 	connects = connects.filter(function (conns, i) {
		// 		return (conns === ws) ? false : true;
		// 	});
		// });

		// flashつなぎ込みdebug用
		broadcast('connect_success');

		// messageイベントの処理
		ws.on('message', function(data, flag){
			console.log('message ok');

			// messageデータをパースします
			var parsedData = JSON.parse(data);
			var dataId = parsedData.id;
			console.log(dataId);

			switch (dataId) {
				case 'game.prep':
					// 参加したプレイヤーのゲームの準備をし、フラッシュにゲーム開始の合図をおくります
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
					break;
				case 'game.locate':
					// 各端末の位置情報をflashに送ります
					console.log('in game.locate');
					unicast(flash_t_id, JSON.stringify(parsedData));
					break;
				case 'game.fish':
					// flashでの魚獲得情報をplayerInfoに格納し、さらに、獲得情報を端末に送ります。
					// 魚獲得情報がない場合はflashにエラー情報を返します。
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
					break;
				case 'game.life':
					// // ゲーム中にポイが破れた場合の処理です。
					// // 残りのポイがなくなった場合にその時点での獲得スコアをDBに登録します。
					// // TODO 動作テスト必要。flashつながってからでもいいかなぁ。
					// console.log('in game.life');
					// var t_id = parsedData.data.t_id;
					// var lastLife = parsedData.data.lastLife;
					// if (!lastLife) {
					// 	playerInfo = playerInfoMap[t_id];
					// 	if (playerInfo) {
					// 		var rankCol = new RankCol();
					// 		rankCol.playerId = rankInfo.playerId;
					// 		rankCol.name = rankInfo.name;
					// 		rankCol.score = rankInfo.score;
					// 		rankCol.save(function(err){
					// 	  		if(err){ 
					// 	  			console.log(err);
					// 	    		return; 
					// 	  		}
					// 	  		console.log("save done");
					// 		});
					// 	} else {
					// 		// TODO error処理 no playerInfo
					// 	}
					// }
					// unicast(t_id, JSON.stringify({'lastLife': lastLife}));
					// break;
				case 'test':
					break;
				default:
					// flashつなぎ込み用
					console.log('test success');
					broadcast('test_success');
					break;
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
		});
	}
};