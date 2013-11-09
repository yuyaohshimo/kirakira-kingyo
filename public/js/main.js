$.ready(function () {
	var w = window;
	w.kingyo = {};
	w.tag = $.tag;
	w.log = $.log;

	$.views({
		'error': {
			render: function () {
				return tag('div#error')
						.tag('p.title')
							.tag('img', { src: '../img/error_title.png', width:174, height:45 }).gat()
						.gat()
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
			self.ws = new WebSocket('ws://10.166.7.154:8888'); // need to override
			// self.ws = new WebSocket('ws://172.22.242.251:8888'); // need to override
			// self.ws = new WebSocket('ws://172.22.247.45:8888');
			// onを使おうかな
			self.isOpen = false;
			self.ws.addEventListener('open', function (e) {
				self.isOpen = true;
				var t_id = $.storage('t_id');
				var name = $.storage('name');
				log.debug('open web socket');
				self.ws.send(JSON.stringify({ id:'game.prep', data:{ t_id: t_id, name: name }}));

				// for debug
				// self.ws.send(JSON.stringify({ id: 'game.fish', data: { t_id :t_id, fishInfo: { type: "1", score: "100" } } }));
				// self.ws.send(JSON.stringify({ id: 'game.fish', data: { t_id :t_id, fishInfo: { type: "2", score: "200" } } }));
				// self.ws.send(JSON.stringify({ id: 'game.fish', data: { t_id :t_id, fishInfo: { type: "3", score: "300" } } }));
				// self.ws.send(JSON.stringify({ id: 'game.fish', data: { t_id :t_id, fishInfo: { type: "4", score: "400" } } }));
				// self.ws.send(JSON.stringify({ id: 'game.fish', data: { t_id :t_id, fishInfo: { type: "5", score: "500" } } }));
				// self.ws.send(JSON.stringify({ id: 'game.fish', data: { t_id :t_id, fishInfo: { type: "6", score: "600" } } }));

				// self.ws.send(JSON.stringify({ id: 'game.life', data: { t_id :t_id, lastLife: 2 } }));
				// self.ws.send(JSON.stringify({ id: 'game.life', data: { t_id :t_id, lastLife: 1 } }));
				// self.ws.send(JSON.stringify({ id: 'game.life', data: { t_id :t_id, lastLife: 0 } }));
			});
			self.ws.addEventListener('close', function (e) {
				log.debug('close web socket');
				$(w).off('devicemotion');
				$(w).off('deviceorientation');
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
			deviceorientation: function (callback) {
				var self = this;
				var alpha = 0;
				var webkitCompassAccuracy = 0;
				var webkitCompassHeading = 0;
				var sendObj = {};


				$(w).on('deviceorientation', function (e) {
					if (!self.isOpen) { return; }
					alpha  = e.alpha.toFixed(2);
					// var beta = e.beta.toFixed(2);
					// var gamma = e.gamma.toFixed(2);
					webkitCompassAccuracy = e.webkitCompassAccuracy;
					if (webkitCompassAccuracy < 0) {
						return;
					}
					webkitCompassHeading = e.webkitCompassHeading.toFixed(2);
					sendObj = {
						id: 'game.orientation',
						t_id: $.storage('t_id'),
						data: {
							alpha: alpha,
							// beta: beta,
							// gamma: gamma,
							webkitCompassAccuracy: webkitCompassAccuracy,
							webkitCompassHeading: webkitCompassHeading
						}
					};

					self.send(sendObj);

					// for debug
					// callback(sendObj);
				});
			},
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

				function truncateNum (obj) {
					var _obj = {};
					for (var key in obj) {
						_obj[key] = obj[key].toFixed(2);
					}
					return _obj;
				}

				// 加速度センサーがセンシングされたときの処理です（0.05秒くらい←超適当）
				$(w).on('devicemotion', function (e) {
					if (doEvent || !self.isOpen) { return; }
					doEvent = true;
					// var ac = truncateNum(e.acceleration);
					var acg = truncateNum(e.accelerationIncludingGravity);
					// var rr = truncateNum(e.rotationRate);

					// shake
					// doShake = evalShake(acg.x, acg.y, acg.z);

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
							// ac: ac,
							acg: acg,
							// rr: rr,
							doShake: doShake,
							doScoop: doScoop
						}
					};
					self.send(sendObj);

					// for debug
					// callback(sendObj);

					if (doScoop || doShake) {
						setTimeout(function () {
							doEvent = false;
						}, 1000);
					} else {
						doEvent = false;
					}
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