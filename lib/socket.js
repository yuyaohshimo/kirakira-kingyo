exports.register = function (wss, playerInfoDaoMap, RankCol, logger) {
	var connects = [];
	var playerInfoMap = [];
	var flash_t_id = 0;

	// socketサーバーの処理
	wss.on('connection', function (ws){
		logger.info('established websocket connection');

		// オープン
		ws.send(JSON.stringify({id:"open", data:""}));

		// messageイベントの処理
		ws.on('message', function(data, flag){

			// messageデータをパースします
			var parsedData = JSON.parse(data);
			var dataId = parsedData.id;

			switch (dataId) {

				// flashのsocket通信にタグ付けします
				case 'game.flash':
					logger.debug('in game.flash');

					// 既にflash通信が存在している場合エラー
					if (ws.t_id && ws.t_id === flash_t_id) {
						unicast(t_id, JSON.stringify({id:'game.flash', data:{error:'flash connection already exists.'}}));
					 	logger.warn('at game.flash, flash connection aleady exits.');
					 	break;
					}

					// タグ付け
					ws.t_id = flash_t_id;
					logger.debug("flash tag done");
					break;

				// 参加したプレイヤーのゲームの準備をし、フラッシュにゲーム開始の合図をおくります
				case 'game.prep': 
					logger.debug('in game.prep');
					var t_id = parsedData.data.t_id;

					// flashの存在判定必要かなぁ

					// for (var i in wss.clients) {
					// 	var wssT_id = wss.clients[i].t_id;
					// 	if(wssT_id) {
					// 		console.log('ws.t_id');
					// 		console.log(wssT_id);
					// 		console.log('parsedData');
					// 		console.log(parsedData.data.t_id);
					// 		if (Number(wssT_id) === Number(t_id) ) {
					// 			// ws.terminate();
					// 			wss.clients[i].terminate();
					// 			console.log('terminate ws');
					// 		}
					// 	}
					// }
					
					// ソケットにプレイヤー情報を格納し、flashに開始の合図を送ります。またSPにplayerIdを返します。
					ws.t_id = t_id;
					ws.playerId = +new Date();
					ws.name = parsedData.data.name;
					ws.send(JSON.stringify({id:'game.prep', data:{ playerId: ws.playerId}}));
					unicast(flash_t_id, JSON.stringify({id:'game.start', data:{t_id:t_id, name:ws.name}}));
					logger.debug("unicast game.start into flash");
					break;

				// send initial orientation
				case 'game.orientation.init':
				// send orientation
				case 'game.orientation':
				// 端末の位置情報をflashに送ります
				case 'game.locate':

					// flashの存在判定必要かも

					unicast(flash_t_id, JSON.stringify(parsedData));
					break;

				// flashでの魚獲得情報をプレイヤー情報に格納し、さらに、獲得情報を端末に送ります。
				// 魚獲得情報がない場合はflashにエラー情報を返します。
				case 'game.fish':
					logger.debug('in game.fish');
					var t_id = parsedData.data.t_id;
					var fishInfo = parsedData.data.fishInfo;
					var targetWs = getWs(t_id);

					// 魚情報が適切に送信されていない場合
					if (fishInfo.length === 0) {
						unicast(flash_t_id, JSON.stringify({id:'game.fish', data:{error:'no fish data at game.fish of t_id' + t_id}}));
						logger.warn('at game.fish, fishInfo didnt sent properly');
						break;
					}

					// プレイヤー情報が存在しない場合
					if (!targetWs) {
						unicast(flash_t_id, JSON.stringify({id:'game.fish', data:{error:'no targetWs with t_id' + t_id}}));
						logger.warn('at game.fish, no targetWs with t_id: ' + t_id);
						break;
					}

					// プレイヤー情報にfishInfoがない場合は作成します
					if (!targetWs.fishInfo) {
						targetWs.fishInfo = [];
					}

					// fishInfoをプレイヤー情報に格納します
					targetWs.fishInfo.push(fishInfo);
					unicast(t_id, JSON.stringify({id:'game.fish', data:fishInfo}));
					logger.debug('at game.fish, unicast fishInfo into t_id: ' + t_id);
					break;
				
				// ゲーム中にポイが破れた場合の処理です。
				// 残りのポイがなくなった場合にその時点での獲得スコアをDBに登録します。
				// また、プレイヤー情報をhttp通信で利用するため、playerInfoDaoに格納します。
				case 'game.life':
					logger.debug('in game.life');
					var t_id = parsedData.data.t_id;
					var lastLife = parsedData.data.lastLife;

					// プレイヤーが死んだ場合の処理です
					if (!lastLife) {
						var targetWs = getWs(t_id);
						if (targetWs) {
							// playerInfoDaoに格納
							deleteExistPlayerInfo(t_id);　// 既に存在しているplayerInfoは削除します
							var playerInfoDao = {};
							playerInfoDao.name = targetWs.name;
							playerInfoDao.fishInfo = targetWs.fishInfo;
							playerInfoDaoMap[targetWs.t_id] = playerInfoDao;

							// DBに格納
							var rankInfo = getRankInfo(targetWs);
							var rankCol = new RankCol();
							rankCol.playerId = rankInfo.playerId;
							rankCol.name = rankInfo.name;
							rankCol.score = Number(rankInfo.score);
							rankCol.save(function(err){
						  		if(err){ 
						  			unicast(flash_t_id, JSON.stringify({id:'game.life', data:{error: 'DB error'}}));
						  			logger.error(err);
						    		return; 
						  		}
						  		logger.debug("at game.life, rankInfo saved with playerId:" + rankInfo.playerId);
							});
						} else {
							unicast(flash_t_id, JSON.stringify({id:'game.life', data:{error:'no targetWs with t_id' + t_id}}));
							logger.error("at game.life, targetWs isn't exists. t_id:" + t_id);
						}
					}

					unicast(t_id, JSON.stringify({id:'game.life', data:{lastLife: lastLife}}));
					logger.debug("at game.life, unicast life into t_id: " + t_id + '. lastLife: ' + lastLife);
					break;

				// 中断処理です
				case 'game.stop':
					logger.debug("in game.stop");
					var t_id = parsedData.data.t_id;
					ws.terminate();
					unicast(flash_t_id, JSON.stringify({id:'game.stop', data: {t_id:t_id}}));
					logger.debug('at game.stop, unicast game.stop into t_id: ' + t_id);
					break;
					
				default:
					logger.warn('unexpected id sent' + dataId);
					broadcast({data:{error:'unexpected message id: ' + dataId}});
					break;
			}
		});
	});

	// リストに既に存在するt_idのプレイヤー情報を削除します
	function deleteExistPlayerInfo (t_id) {
		for (var i in playerInfoDaoMap) {
			if (Number(i) === Number(t_id)) {
				playerInfoDaoMap.pop(playerInfoDaoMap[i]);
			}
		}
	}

	// ソケットを返します。ソケットが持つt_idはユニークになるよう設計されています。
	// wsがない場合はnullを返します。
	function getWs (t_id) {
		for (var i in wss.clients) {
			if (Number(wss.clients[i].t_id) === Number(t_id)) {
				return wss.clients[i];
			}
		}
		return null;
	}

	// ソケットからランク情報を生成します。
	function getRankInfo (targetWs) {
		var totalScore = 0;
		for (var i in targetWs.fishInfo) {
			var score = targetWs.fishInfo[i].score;
			totalScore = Number(totalScore) + Number(score);
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