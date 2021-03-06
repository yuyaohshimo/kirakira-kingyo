$.ready(function () {
	var w = window;
	w.kingyo = {};
	w.tag = $.tag;
	w.log = $.log;

	$.views({
		'error': {
			render: function () {
				return tag('div#error')
						.tag('p.title').text('ERROR').gat()
						.tag('p.msg')
							.appendText('通信エラーが発生しました。')
							.append(tag('br'))
							.appendText('もう一度はじめからやり直してください。')
						.gat()
						.tag('img', { src: '../img/common_error.png', width: '97', height: '120'}).gat()
						.tag('button')
							.tap(function () {
								kingyo.executeHash('top', 'top');
							})
						.gat()
			}
		}
	});

	(function (kingyo) {
		function loadModule(module, callback) {
			log.info('loading module', module);
			if ($.dispatcher.hasController(module)) {
				return callback();
			}
			var jsurl = $.format('./js/module/{1}.js', module);
			if ($.loaded(jsurl)) {
				return callback();
			} else {
				$.load(
					jsurl,
					function (type) {
						if (type === 'error') {
							return;
						}
						callback();
					}
				);
			}
		}
		kingyo.executeHash = function (hash, action) {
			log.info('executeHash', hash);
			var controller = $.dispatcher.controllerName(hash);
			loadModule(controller, function () {
				$.dispatcher.execute(hash, action);
				location.hash = hash;
			});
		}
		kingyo.pageReplace = function (view) {
			log.info('page replace');
			$('body')
			.empty()
			.append(view.content);
		}
		kingyo.Socket = function (view) {
			var self = this;
			self.ws = new WebSocket('ws://localhost:8888'); // need to override
			// self.ws = new WebSocket('ws://172.22.242.251:8888'); // need to override
			// self.ws = new WebSocket('ws://172.22.247.45:8888');
			// onを使おうかな
			self.isOpen = false;
			self.ws.addEventListener('open', function (e) {
				self.isOpen = true;
				console.log('-------------------------------------')
				var t_id = $.storage('t_id');
				var name = $.storage('name');
				log.debug('open web socket');
				self.ws.send(JSON.stringify({ id:'game.prep', data:{ t_id: t_id, name: name }}));
			});
			self.ws.addEventListener('close', function (e) {
				log.debug('close web socket');
				$(w).off('devicemotion');
				self.isOpen = false;
				self.ws.close();
			});
			// trigger view
			if (view) {
				self.ws.addEventListener('message', function (data) {
					console.log(data);
					var parsedData = JSON.parse(data.data);
					var dataId = parsedData.id;
					view.trigger('message', dataId, parsedData.data);
				});
			}
		};
		kingyo.Socket.prototype = {
			devicemotion: function (callback) {
				var self = this;
				// flags
				var doShake = false;
				var doScoop = false;
				var doEvent = false;
				// store last accelerationIncludingGravity
				var lastAcgX = 0;
				var lastAcgY = 0;
				var lastAcgZ = 0;

				var sendObj = {};

				function evalShake(x, y, z) {
					var threshold = 15;
					var deltaX = Math.abs(x - lastAcgX);
					var deltaY = Math.abs(y - lastAcgY);
					var deltaZ = Math.abs(z - lastAcgZ);

					if (((deltaX > threshold) && (deltaY > threshold)) || ((deltaX > threshold) && (deltaZ > threshold)) || ((deltaY > threshold) && (deltaZ > threshold))) {
						return true;
					} else {
						return false;
					}
				}

				function evalScoop(y, z) {
					var threshold = 3;
					var deltaY = Math.abs(y - lastAcgY);
					var deltaZ = Math.abs(z - lastAcgZ);

					if ((Math.floor(y) < Math.floor(lastAcgY)) && (Math.floor(deltaY) > Math.floor(threshold)) && (z > lastAcgZ + 1) && (deltaY > threshold)) {
						return true;
					} else {
						return false;
					}
				}

				// 加速度センサーがセンシングされたときの処理です（0.05秒くらい←超適当）
				$(w).on('devicemotion', function (e) {
					if (doEvent || !self.isOpen) { return; }
					console.log('devicemotion');
					doEvent = true;
					setTimeout(function () {
						var ac = e.acceleration;
						var acg = e.accelerationIncludingGravity;
						var rr = e.rotationRate;

						// shake
						doShake = evalShake(acg.x, acg.y, acg.z);
						// scoop
						doScoop = evalScoop(acg.y, acg.z);

						lastAcgX = acg.x;
						lastAcgY = acg.y;
						lastAcgZ = acg.z;

						// サーバーにデータ送ります
						sendObj = {
							id: 'game.locate',
							t_id: $.storage('t_id'),
							data: {
								ac: ac,
								acg: acg,
								rr: rr,
								doShake: doShake,
								doScoop: doScoop
							}
						};
						self.send(sendObj);

						if (doScoop || doShake) {
							setTimeout(function () {
								doEvent = false;
							}, 1000);
						} else {
							doEvent = false;
						}
					}, 50);
				});
			},
			send: function (obj) {
				var self = this;
				self.ws.send(JSON.stringify(obj));
			}
		}
	})(w.kingyo);

	function init() {
		var hash = location.hash;
		if (!hash) {
			hash = 'top';
		}
		kingyo.executeHash(hash);
	}

	init();

});