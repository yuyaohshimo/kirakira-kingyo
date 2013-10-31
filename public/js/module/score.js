(function (w) {
	// routing
	$.routes('score', {
		'/': {
			name: 'top',
			action: function (args) {
				$.http.get($.format('/api/result?t_id={1}', $.storage('t_id'))).on({
					complete: function (data) {
						kingyo.pageReplace($.view('score', data));
					},
					error: function (err) {
						kingyo.pageReplace($.view('error'));
					}
				});
			}
		}
	});
	$.views({
		'score': {
			init: function (data) {
				var self = this;
				self.data = data;
			},
			render: function () {
				var self = this;
				return tag('div#score')
							.tag('p.title').text('SCORE').gat()
							.tag('p.text')
								.tag('span.total_score').text(self.data.totalScore).gat()
							.gat()
							.tag('ul.fish')
								.exec(function () {
									var that = this;
									for (var key in self.data.fishResult) {
										that
										.tag('li')
											.tag('img').gat()
											.tag('p.num').text('×{1}', self.data.fishResult[key].count).gat()
											.tag('p.pt').text(self.data.fishResult[key].score).gat()
										.gat()
									}
								})
							.gat()
							.tag('button')
								.tap(function () {
									kingyo.executeHash('ranking', 'top');
								})
							.gat();
			}
		}
	});
})(window);