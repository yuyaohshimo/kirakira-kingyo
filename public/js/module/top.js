(function (w) {
	// routing
	$.routes('top', {
		'/': {
			name: 'top',
			action: function (args) {
				var _view = $.view('top');
				_view.on({
					start: function (callback) {
						var name = $('input[name="nickname"]').value();
						var t_id = $.storage('t_id');
						if (name.indexOf('strg') !== -1) {
							t_id = name.split('_')[1];
							$.storage('t_id', t_id);
							callback({
								message: $.format('t_idを登録しました：{1}', t_id)
							});
						} else if (!name) {
							callback({
								message: 'ニックネームが入力されていません'
							});
						} else if (!t_id) {
							callback({
								message: 't_idが無いよ。hint: strg_1'
							});
						} else {
							$.storage('name', name);
							callback(null);
						}

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
						.tag('h1.title')
						.tag('img', { src: '../img/common_logo.png', width: '277px' }).gat()
						.gat()
						.tag('ol.procedure')
							.tag('li')
								.tag('p.text')
									.tag('span').text('1').gat()
									.appendText('スマートフォンを傾けてポイを動かそう')
								.gat()
								.tag('img', { src: '../img/top_procedure_1.png', width: 222, height: 130 }).gat()
							.gat()
							.tag('li')
								.tag('p.text')
									.tag('span').text('2').gat()
									.appendText('素早く手前に引いて金魚をすくおう')
								.gat()
								.tag('img', { src: '../img/top_procedure_2.png', width: 222, height: 130 }).gat()
							.gat()
						.gat()
						.tag('div.form_container')
							.tag('label')
								.tag('span.text').text('ニックネームを入力してください（任意）').gat()
								.tag('input', {
									type: 'text',
									name: 'nickname',
									maxlength: 7,
									value: $.storage('t_id') ? $.format('プレイヤー{1}', $.storage('t_id')) : ''
								})
								.gat()
							.gat()
							.tag('button')
								.tap(function () {
									self.trigger('start', function (err, _bool) {
										if (err) {
											alert(err.message);
											return;
										}
										kingyo.executeHash('play', 'top');
									});
								})
							.gat()
						.gat();
			}
		}
	});
})(window);