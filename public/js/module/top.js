(function (w) {
	// routing
	$.routes('top', {
		'/': {
			name: 'top',
			action: function (args) {
				kingyo.pageReplace($.view('top'));
			}
		}
	});
	$.views({
		'top': {
			init: function () {
			},
			render: function () {
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
									.tag('input', { type: 'text', name: 'name' }).gat()
								.gat()
								.tag('button').text('START')
								.tap(function () {
									kingyo.executeHash('play')
								})
								.gat()
							.gat()
						.gat();
			}
		}
	});
})(window);