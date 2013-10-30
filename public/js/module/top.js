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
						if (name.indexOf('amebastorage') !== -1) {
							t_id = name.split('_')[1];
							$.storage('t_id', t_id);
						}
						if (!name) {
							callback({
								message: 'ニックネームが入力されていません'
							});
						} else if (!t_id) {
							callback({
								message: 't_idが無いよ。hint: amebastorage_1'
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
						.tag('h1.title').text('KIRAKIRA KINGYO').gat()
						.tag('ol.procedure')
							.tag('li')
								.tag('p.text')
									.tag('span').text('1').gat()
									.appendText('スマートフォンを傾けてポイを動かそう')
								.gat()
								.tag('img', { src: '../img/top_procedure_1.png' }).gat()
							.gat()
							.tag('li')
								.tag('p.text')
									.tag('span').text('2').gat()
									.appendText('素早く手前に引いて金魚をすくおう')
								.gat()
								.tag('img', { src: '../img/top_procedure_2.png' }).gat()
							.gat()
						.gat()
						.tag('div.form_container')
							.tag('label').text('ニックネームを入力してください')
								.tag('input', {
									type: 'text',
									name: 'nickname',
									maxlength: 15,
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
										kingyo.executeHash('play');
									});
								})
							.gat()
						.gat();
			}
		}
	});
})(window);