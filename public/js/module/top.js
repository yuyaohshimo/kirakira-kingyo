(function (w) {
	// routing
	$.routes('top', {
		'/': {
			name: 'top',
			action: function (args) {
				var _view = $.view('top')
				_view.on({
					start: function (callback) {
						var name = $('input[name="nickname"]').value();
						var t_id = $.storage('t_id') || 0;
						$.http.post('/api/top', { name: name, t_id: t_id }).on({
							complete: function () {
								$.storage('name', name);
								callback(null, true);
							},
							error: function (err) {
								callback(err);
							}
						});
					}
				});
				kingyo.pageReplace(_view);
			}
		}
	});
	$.views({
		'top': {
			init: function () {
			},
			render: function () {
				var self = this;
				return tag('div#top')
						.tag('h1.title').text('KIRAKIRA KINGYO')
							.tag('ol.procedure')
								.tag('li')
									.tag('p.text').text('スマートフォンを傾けてポイを動かそう').gat()
								.gat()
								.tag('li')
									.tag('p.text').text('素早く手前に引いて金魚をすくおう').gat()
								.gat()
							.gat()
							.tag('div.form_container')
								.tag('label').text('ニックネームを入力してください')
									.tag('input', { type: 'text', name: 'nickname', maxlength: 15 }).gat()
								.gat()
								.tag('button').text('START')
									.tap(function () {
										self.trigger('start', function (err, _bool) {
											if (err) { return; }
											kingyo.executeHash('play');
										});
									})
								.gat()
							.gat()
						.gat();
			}
		}
	});
})(window);