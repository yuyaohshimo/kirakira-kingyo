exports.register = function (wss, playerInfoDaoMap, RankCol) {
	var connects = [];
	var playerInfoMap = [];
	var flash_t_id = 0;

	// socketサーバーの処理
	wss.on('connection', function (ws){
		console.log('established websocket connection');

		// オープン
		ws.send({id:"open", data:'this machine is succesed with connecting sockets'});

		// messageイベントの処理
		ws.on('message', function(data, flag){

			// messageデータをパースします
			var parsedData = JSON.parse(data);
			var dataId = parsedData.id;

			switch (dataId) {

				// flashのsocket通信にタグ付けする
				case 'game.flash':
					console.log('in game.flash');

					// 既にflash通信が存在している場合エラー
					if (ws.t_id && ws.t_id === flash_t_id) {
					 	console.log('flash connection aleady exits.');// TODO エラー処理
					 	break;
					}

					// タグ付け
					ws.t_id = flash_t_id;
					break;

				// 参加したプレイヤーのゲームの準備をし、フラッシュにゲーム開始の合図をおくります
				case 'game.prep': 
					console.log('in game.prep');
					var t_id = parsedData.data.t_id;

					// flashの存在判定必要かなぁ

					// すでにプレイヤーが存在する場合はエラーを返す。
					if (ws.t_id) {
						console.log('in already exist prep');
						unicast(t_id, JSON.stringify({id:'game.start', data:{error:'already exist t_id:' + t_id}}));
						break;
					}
					
					// ソケットにプレイヤー情報を格納し、flashにエラーを返す
					ws.t_id = t_id;
					ws.playerId = +new Date();
					ws.name = parsedData.data.name;
					unicast(flash_t_id, {id:'game.start', data:{t_id:t_id, name:ws.name}});
					break;

				// 端末の位置情報をflashに送ります
				case 'game.locate':
					
					// flashの存在判定必要かも

					unicast(flash_t_id, JSON.stringify(parsedData));
					// broadcast(JSON.stringify(parsedData)); // 動作確認用
					break;

				// flashでの魚獲得情報をプレイヤー情報に格納し、さらに、獲得情報を端末に送ります。
				// 魚獲得情報がない場合はflashにエラー情報を返します。
				case 'game.fish':
					console.log('in game.fish');
					var t_id = parsedData.data.t_id;
					var fishInfo = parsedData.data.fishInfo;
					var targetWs = getWs(t_id);
					
					// 魚情報が適切に送信されていない場合
					if (!fishInfo) {
						unicast(flash_t_id, JSON.stringify({id:'game.fish', data:{error:'no fish data at game.fish of t_id' + t_id}}));
						console.log("no fishInfo");
						break;
					}

					// プレイヤー情報が存在しない場合
					if (!targetWs) {
						unicast(flash_t_id, JSON.stringify({id:'game.fish', data:{error:'no targetWs with t_id' + t_id}}));
						console.log("no targetWs");
						break;
					}

					// fishInfoをプレイヤー情報に格納します
					targetWs.fishInfo = fishInfo;
					unicast(t_id, fishInfo);
					break;
				
				// ゲーム中にポイが破れた場合の処理です。
				// 残りのポイがなくなった場合にその時点での獲得スコアをDBに登録します。
				// また、プレイヤー情報をhttp通信で利用するため、playerInfoDaoに格納します。
				// TODO 動作テスト必要。flashつながってからでもいいかなぁ。
				case 'game.life':
					console.log('in game.life');
					var t_id = parsedData.data.t_id;
					var lastLife = parsedData.data.lastLife;
					// if (!lastLife) {
					// 	var targetWs = getWs(t_id);
					// 	if (targetWs) {
					// 		// playerInfoDaoに格納
					// 		deleteExistPlayerInfo(t_id);　// 既に存在しているplayerInfoは削除します
					// 		var playerInfoDao;
					// 		playerInfoDao.t_id = targetWs.t_id;
					// 		playerInfoDao.name = targetWs.name;
					// 		playerInfoDao.fishInfo = targetWs.fishInfo;
					// 		playerInfoDaoList.push(playerInfoDao);

					// 		// DBに格納
					// 		var rankInfo = getRankInfo(targetWs);
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
					unicast(t_id, JSON.stringify({id:game.life, data:{lastLife: lastLife}}));
					break;
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

	// リストに既に存在するt_idのプレイヤー情報を削除します
	function deleteExistPlayerInfo (t_id) {
		for (var i in playerInfoDaoList) {
			if (Number(playerInfoDaoList[i].t_id) === Number(t_id)) {
				playerInfoDaoList.pop(playerInfoDaoList[i]);
			}
		}

	}

	// ソケットを返します。ソケットが持つt_idはユニークになるよう設計されています。
	function getWs (t_id) {
		for (var i in wss.clients) {
			console.log(wss.clients[i].t_id);
			if (Number(wss.clients[i].t_id) === Number(t_id)) {
				return wss.clients[i];
			}
		}
	}

	// ソケットからランク情報を生成します。
	function getRankInfo (targetWs) {
		var totalScore = 0;
		for (var i in targetWs.fishInfo) {
			var score = targetWs.fishInfo[i].score;
			totalScore + Number(score);
		}
		return {playerId: targetWs.playerId, name: targetWs.name, score: totalScore};
	}

	// つないでいる端末すべてにデータを送ります
	function broadcast (message) {
		for(var i in wss.clients) {
        	wss.clients[i].send(message);
		}
	}

	// 指定した端末のみにデータを送ります
	function unicast (t_id, message) {
		for (var i in wss.clients) {
			if (Number(wss.clients[i].t_id) === Number(t_id)) {
				wss.clients[i].send(message);
			}
		}
	}
};