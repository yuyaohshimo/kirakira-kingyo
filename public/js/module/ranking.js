(function (w) {
	// routing
	$.routes('ranking', {
		'/': {
			name: 'top',
			action: function (args) {
				kingyo.pageReplace($.view('ranking'));
			}
		}
	});
	$.views({
		'ranking': {
			init: function () {
			},
			render: function () {
				return tag('div#ranking')
							.tag('ol')
								.tag('li')
									.tag('p.text')
										.tag('span.name').gat()
										.tag('span.pt').gat()
									.gat()
								.gat()
								.tag('li')
									.tag('p.text')
										.tag('span.name').gat()
										.tag('span.pt').gat()
									.gat()
								.gat()
								.tag('li')
									.tag('p.text')
										.tag('span.name').gat()
										.tag('span.pt').gat()
									.gat()
								.gat()
								.tag('li')
									.tag('p.text')
										.tag('span.name').gat()
										.tag('span.pt').gat()
									.gat()
								.gat()
							.gat()
							.tag('button').text('スタート画面に戻る')
								.tap(function () {
									kingyo.executeHash('top', 'top');
								})
							.gat();
			}
		}
	});
})(window);