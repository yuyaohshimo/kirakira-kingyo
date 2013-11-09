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
							.tag('p.title')
								.tag('img', { src: '../../img/score_title.png', width:'93px', height:'25px' }).gat()
							.gat()
							.tag('p.total_score')
								.tag('span.text').text(String(self.data.totalScore)).gat()
							.gat()
							.tag('ul.fish')
								.exec(function () {
									var that = this;
									for (var key in self.data.fishResult) {
										// debugger;
										that
										.tag('li')
											.tag('img', { src: $.format('../../img/common_fish_{1}.png', key), width: '31px', height: '46px' }).gat()
											.tag('p.fish_num').text('×{1}', self.data.fishResult[key].count).gat()
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