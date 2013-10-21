$.ready(function () {
	var w = window;
	w.kingyo = {};
	w.tag = $.tag;
	w.log = $.log;

	$.views({
		'error': {
			render: function () {
				return tag('div#error')
						.tag('p.text').text('ERROR').gat()
						.tag('img').gat()
						.tag('button').text('スタート画面に戻る').gat()
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
		kingyo.executeHash = function (hash) {
			log.info('executeHash', hash);
			var controller = $.dispatcher.controllerName(hash);
			loadModule(controller, function () {
				$.dispatcher.execute(hash);
				location.hash = hash;
			});
		}
		kingyo.pageReplace = function (view) {
			log.info('page replace');
			$('body')
			.empty()
			.append(view.content);
		}
		kingyo.Socket = function () {
			var self = this;
			self.ws = new WebSocket('ws://localhost:8888'); // need to override
			self.ws.addEventListener('open', function (e) {
				log.debug('open web socket');
			});
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
					if (doEvent) { return; }
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
							data: {
								ac: ac,
								acg: acg,
								rr: rr,
								doShake: doShake,
								doScoop: doScoop
							}
						};
						callback(sendObj);
						self.send(sendObj);
						doEvent = false;
					}, 10);
				});
			},
			send: function (obj) {
				var self = this;
				self.ws.send(JSON.stringify(obj));
			},
			off: function (eventName) {
				$(w).off(eventName);
			}
		}
	})(w.kingyo);

	var hash = location.hash;
	if (!hash) {
		hash = 'top';
	}
	kingyo.executeHash(hash);
});