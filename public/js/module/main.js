var ws = new WebSocket("ws://localhost:8888"); // サーバーのIPを指定します
var poi = $('.poi');
var pX = 0;
var pY = 0;
var vp = $.viewport();
var cX = (vp.window.width / 2) - parseInt(poi.css('width')) / 2;
var cY = (vp.window.height / 2) - parseInt(poi.css('height')) / 2;
var deg = '0deg';

// initialize
poi.css({ left: cX + 'px', top: cY + 'px' });
pX = cX;
pY = cY;

// flags
var doShake = false;
var doScoop = false;

// socket通信開始したらopenアラートを出します。
ws.addEventListener('open' , function (e) {
	alert('open');
	ws.send(JSON.stringify({id:'game.flash', data:{t_id:0}}));　// flashとして通信する。動作確認用。
//	ws.send(JSON.stringify({id:'game.fish', data:{t_id:1, fishInfo:"fishType1"}}));
});



// メッセージをサーバーから受け取った時の処理
ws.addEventListener('message' , function (e) {
//	alert(e.data); // 通信確認用
	try {
		var data = JSON.parse(e.data).data;
	}
	catch (e) {
		console.log(e);
		return;
	}
	if (doShake || doScoop) { return; }
	if (data.doScoop) {
		doScoop = true;
		console.log('scoop!!!!');
		poi.transition({duration: 0.4, ease: 'ease-in'}, function () {
			poi.transition({duration: 0.4, ease: 'ease-in'}, function () {
				poi.css({
					'-webkit-transition': 'none',
					'transition': 'none'
				});
				doScoop = false;
			}).css({'-webkit-transform': 'rotateX(0)'});
		}).css({'-webkit-transform': 'rotateX(-80deg)'});
	} else if (doShake) {
		doShake = true;
		console.log('shake!!!!');
		pX += data.acg.x * 5;
		pY -= data.acg.y * 5;
		poi.css({ left: pX + 'px', top: pY + 'px', '-webkit-transform': $.format('rotateY({1}deg)', data.acg.x * 8)});
		doShake = false;
	} else {
		pX += data.acg.x * 2;
		pY -= data.acg.y * 3;
		poi.css({ left: pX + 'px', top: pY + 'px', '-webkit-transform': $.format('rotateY({1}deg)', data.acg.x * 8)});
	}
}, false);