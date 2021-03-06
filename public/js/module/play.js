(function (w) {
	// routing
	$.routes('play', {
		'/': {
			name: 'top',
			action: function (args) {
				var _view = $.view('play');
				// websocket
				var socket = new kingyo.Socket(_view);
				_view.on({
					close: function () {
						socket.send({ id: 'game.stop', data: { t_id: $.storage('t_id') } });
					},
					message: function (dataId, data) {
						switch (dataId) {
							case 'game.life':
								_view.updateLife(data.lastLife);
								break;
							case 'game.fish':
								console.log(data);
							default:
								break;
						}
					}
				});
				kingyo.pageReplace(_view);

				socket.devicemotion();

				// for debug
				// var test = $.view('play.test');
				// $('body').append(test.content);
				// socket.devicemotion(function (obj) {
				// 	test.update(obj);
				// });
			}
		}
	});
	$.views({
		'play': {
			init: function () {
			},
			render: function () {
				var self = this;
				return tag('div#play')
						.tag('button')
							.tap(function () {
								self.trigger('close');
								kingyo.executeHash('top', 'top');
							})
						.gat()
						.tag('p.player_info')
							.tag('span.num').text('P{1}', $.storage('t_id')).gat()
							.tag('span.name').text('パジェロ').gat()
						.gat()
						.tag('div.main')
							.tag('div.poi')
								.tag('ul')
									.tag('li').text('残り3').gat()
									.tag('li').gat()
									.tag('li').gat()
								.gat()
							.gat()
							.tag('div.fish')
								.tag('ul')
									.tag('li.fish_thumb').gat()
									.tag('li.fish_thumb').gat()
									.tag('li.fish_thumb').gat()
								.gat()
							.gat()
						.gat();
			},
			updateLife: function (lastLife) {
				var self = this;
				var poi = self.content.find('.poi');
				// $(poi.get(poi.length()).remove();
				if (lastLife === 0) {
					self.trigger('close');
				}
			},
			updateFish: function () {
				
			}
		},
		'play.test': {
			render: function () {
				var self = this;
				return tag('div.device_test')
						.tag('p').text('acceleration').gat()
						.tag('ul')
							.tag('li.acX').text('x')
								.tag('span.text')
								.exec(function () {
									self.acX = this;
								})
								.gat()
							.gat()
							.tag('li.acY').text('y')
								.tag('span.text')
								.exec(function () {
									self.acY = this;
								})
								.gat()
							.gat()
							.tag('li.acZ').text('z')
								.tag('span.text')
								.exec(function () {
									self.acZ = this;
								})
								.gat()
							.gat()
						.gat()
						.tag('p').text('accelerationIncludingGravity').gat()
						.tag('ul')
							.tag('li.acgX').text('x')
								.tag('span.text')
								.exec(function () {
									self.acgX = this;
								})
								.gat()
							.gat()
							.tag('li.acgY').text('y')
								.tag('span.text')
								.exec(function () {
									self.acgY = this;
								})
								.gat()
							.gat()
							.tag('li.acgZ').text('z')
								.tag('span.text')
								.exec(function () {
									self.acgZ = this;
								})
								.gat()
							.gat()
						.gat()
						.tag('p').text('rotationRate').gat()
						.tag('ul')
							.tag('li.rrA').text('alpha')
								.tag('span.text')
								.exec(function () {
									self.rrA = this;
								})
								.gat()
							.gat()
							.tag('li.rrB').text('beta')
								.tag('span.text')
								.exec(function () {
									self.rrB = this;
								})
								.gat()
							.gat()
							.tag('li.rrG').text('gamma')
								.tag('span.text')
								.exec(function () {
									self.rrG = this;
								})
								.gat()
							.gat()
						.gat()
			},
			update: function (obj) {
				var self = this;
				self.acX.text(obj.data.ac.x);
				self.acY.text(obj.data.ac.y);
				self.acZ.text(obj.data.ac.z);

				self.acgX.text(obj.data.acg.x);
				self.acgY.text(obj.data.acg.y);
				self.acgZ.text(obj.data.acg.z);

				self.rrA.text(obj.data.rr.alpha);
				self.rrB.text(obj.data.rr.beta);
				self.rrG.text(obj.data.rr.gamma);
			}
		}
	});
})(window);