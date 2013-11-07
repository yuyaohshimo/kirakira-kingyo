(function (w) {
	// routing
	$.routes('maintenance', {
		'/rotate': {
			name: 'rotate',
			action: function (args) {
				var ws = new WebSocket('ws://localhost:8888');
				var isOpen = false;
				var _view = $.view('maintenance.rotate');
				_view.on({
					close: function () {
						ws.send(JSON.stringify({id: 'maintenance.close'}));
					},
					send: function (type, t_id) {
						var val = 0;
						var obj = {};
						if (type === 'up') {
							val = 1;
						} else if (type === 'down') {
							val = -1;
						}
						obj = {
							id: 'maintenance.rotate',
							t_id: t_id,
							data: {
								val: val
							}
						}
						ws.send(JSON.stringify(obj));
					}
				});
				ws.addEventListener('open', function (e) {
					isOpen = true;
					log.debug('open web socket');
				});
				ws.addEventListener('close', function (e) {
					isOpen = false;
					log.debug('close web socket');
				});
				kingyo.pageReplace(_view);
			}
		}
	});
	$.views({
		'maintenance.rotate': {
			init: function () {
			},
			render: function () {
				var self = this;
				return tag('div#maintenance_rotate')
						.tag('div.button')
							.click(function () {
								self.trigger('close');
							})
							.text('Close Web Socket')
						.gat()
						.tag('select.select_t_id')
							.tag('option', { value: 1 }).text('t_id: 1').gat()
							.tag('option', { value: 2 }).text('t_id: 2').gat()
							.tag('option', { value: 3 }).text('t_id: 3').gat()
							.tag('option', { value: 4 }).text('t_id: 4').gat()
						.gat()
						.tag('div.send_btn')
							.tag('div.button')
							.on('mousedown', function () {
								var target = $(this);
								var t_id = $('.select_t_id').value();
								var timer = setInterval(function () {
									self.trigger('send', 'down', t_id);
								}, 25);
								target.on('mouseup', function () {
									clearInterval(timer);
									target.off(arguments.callee);
								});
							})
							.text('ー')
							.gat()
							.tag('div.button')
							.on('mousedown', function () {
								var target = $(this);
								var t_id = $('.select_t_id').value();
								var timer = setInterval(function () {
									self.trigger('send', 'up', t_id);
								}, 25);
								target.on('mouseup', function () {
									clearInterval(timer);
									target.off(arguments.callee);
								});
							})
							.text('＋')
							.gat()
						.gat()
			}
		}
	});
})(window);