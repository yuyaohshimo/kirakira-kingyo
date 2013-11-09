(function (w) {
	// routing
	$.routes('ranking', {
		'/': {
			name: 'top',
			action: function (args) {
				$.http.get($.format('/api/ranking?playerId={1}', $.storage('playerId'))).on({
					complete: function (array) {
						kingyo.pageReplace($.view('ranking', array));
					},
					error: function (err) {
						kingyo.pageReplace($.view('error'));
					}
				});
			}
		}
	});
	$.views({
		'ranking': {
			init: function (array) {
				var self = this;
				var me = array.shift();
				if (me.rank > 10) {
					self.extra = me;
				}
				self.array = array;
			},
			render: function () {
				var self = this;
				return tag('div#ranking')
							.tag('p.title')
								.tag('img', { src: '../../img/ranking_title.png', width:'118px', height:'25px' }).gat()
							.gat()
							.tag('ol')
								.exec(function () {
									for (var i = 0; i < self.array.length; i++) {
										this
										.tag('li')
											.exec(function () {
												if (self.array[i].playerId === $.storage('playerId')) {
													this.cls({ me: 1 });
												}
											})
											.tag('p.text')
												.tag('span.rank').text(self.array[i].rank).gat()
												.tag('span.name').text(self.array[i].name).gat()
												.tag('span.pt').text(String(self.array[i].score)).gat()
											.gat()
										.gat()
									}
								})
							.gat()
							.exec(function () {
								if (self.extra) {
									this
									.tag('div.extra')
										.tag('p.text')
											.tag('span.rank').text(self.extra.rank).gat()
											.tag('span.name').text(self.extra.name).gat()
											.tag('span.pt').text(String(self.extra.score)).gat()
										.gat()
									.gat()
								}
							})
							.tag('button')
								.tap(function () {
									kingyo.executeHash('top', 'top');
								})
							.gat();
			}
		}
	});
})(window);