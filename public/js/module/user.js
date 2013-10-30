var ws = new WebSocket("ws://localhost:8888");// need to override
//var ws = new WebSocket("ws://172.22.247.45:8888");
var acX = $('.acX').find('.text');
var acY = $('.acY').find('.text');
var acZ = $('.acZ').find('.text');
var acgX = $('.acgX').find('.text');
var acgY = $('.acgY').find('.text');
var acgZ = $('.acgZ').find('.text');
var rrA = $('.rrA').find('.text');
var rrB = $('.rrB').find('.text');
var rrG = $('.rrG').find('.text');

// flags
var doEvent = false;
var doShake = false;
var doScoop = false;

// store last accelerationIncludingGravity
var lastAcgX = 0;
var lastAcgY = 0;
var lastAcgZ = 0;

var sendObj = {};

function evalShake(x, y, z) {
	var threshold = 15;
	var deltaX = Math.abs(x - lastAcgX);
	var deltaY = Math.abs(y - lastAcgY);
	var deltaZ = Math.abs(z - lastAcgZ);

	if (((deltaX > threshold) && (deltaY > threshold)) || ((deltaX > threshold) && (deltaZ > threshold)) || ((deltaY > threshold) && (deltaZ > threshold))) {
		return true;
	} else {
		return false;
	}
}

function evalScoop(y, z) {
	var threshold = 3;
	var deltaY = Math.abs(y - lastAcgY);
	var deltaZ = Math.abs(z - lastAcgZ);

	if ((Math.floor(y) < Math.floor(lastAcgY)) && (Math.floor(deltaY) > Math.floor(threshold)) && (z > lastAcgZ + 1) && (deltaY > threshold)) {
		return true;
	} else {
		return false;
	}
}

// socket通信が開始されたらアラートが出ます
ws.addEventListener("open" , function(e){
	alert("open");
	ws.send(JSON.stringify({id:'game.prep', data:{t_id:1}})); // t_id:1 を参加させる。動作確認用。
},false);

// // 動作確認用。
// ws.addEventListener('message', function(e){
// 	alert(e.data);
// }, false);

// 加速度センサーがセンシングされたときの処理です（0.05秒くらい←超適当）
window.addEventListener('devicemotion', function (e) {
	if (doEvent) { return; }
	doEvent = true;
	setTimeout(function () {
		var ac = e.acceleration;
		acX.text(ac.x); //x方向の傾き加速度
		acY.text(ac.y); //y方向の傾き加速度
		acZ.text(ac.z); //z方向の傾き加速度

		// direction
		// direction = getDirection(ac.x, ac.y, ac.z);

		var acg = e.accelerationIncludingGravity;
		acgX.text(acg.x); //x方向の傾き重力加速度
		acgY.text(acg.y); //y方向の傾き重力加速度
		acgZ.text(acg.z); //z方向の傾き重力加速度

		// shake
		doShake = evalShake(acg.x, acg.y, acg.z);

		// scoop
		doScoop = evalScoop(acg.y, acg.z);

		lastAcgX = acg.x;
		lastAcgY = acg.y;
		lastAcgZ = acg.z;

		var rr = e.rotationRate;
		rrA.text(rr.alpha); //z軸の回転加速度
		rrB.text(rr.beta); //x軸の回転加速度
		rrG.text(rr.gamma); //y軸の回転加速度

		// サーバーにデータ送ります
		sendObj = {
			id: 'game.locate',
			data: {
				ac: ac,
				acg: acg,
				rr: rr,
				doShake: doShake,
				doScoop: doScoop
			}
		};
		ws.send(JSON.stringify(sendObj));
		doEvent = false;
	}, 10);
});