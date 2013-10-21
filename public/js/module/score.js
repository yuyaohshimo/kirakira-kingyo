(function (w) {
	// routing
	$.routes('score', {
		'/': {
			name: 'top',
			action: function (args) {
				kingyo.pageReplace($.view('score'));
			}
		}
	});
	$.views({
		'score': {
			init: function () {
			},
			render: function () {
				return tag('div#score')
							.tag('p.text')
								.tag('span.label').text('SCORE').gat()
								.tag('span.pt').text('3500').gat()
							.gat()
							.tag('ul.fish')
								.tag('li')
									.tag('img').gat()
									.tag('p.num').gat()
									.tag('p.pt').gat()
								.gat()
								.tag('li')
									.tag('img').gat()
									.tag('p.num').gat()
									.tag('p.pt').gat()
								.gat()
							.gat()
							.tag('button').text('ランキングを見る')
								.tap(function () {
									kingyo.executeHash('ranking', 'top');
								})
							.gat();
			}
		}
	});
})(window);