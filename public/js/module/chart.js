var ws = new WebSocket("ws://localhost:8888"); // サーバーのIPを指定します
var barChartData = {
	labels: ["acX","acY","acZ","acgX","acgY","acgZ"],
	datasets: [
		{
			fillColor: "rgba(220,220,220,0.5)",
			strokeColor: "rgba(220,220,220,1)",
			data: [0,0,0,0,0,0]
		}
	]
}

var option = {
	// scaleShowLine: true,
	// scaleOverride: true,
	// scaleStartValue: -10,
	animation: false,
	scaleShowLabels : true, 
	pointLabelFontSize : 10, 
	scaleOverride : true, 
	scaleSteps : 50, //目盛の数
	scaleStepWidth : 1, //目盛間隔2
	scaleStartValue : -20 //目盛の最小値
};

var myLine = new Chart(document.getElementById("canvas").getContext("2d"))
myLine.Bar(barChartData, option);

// socket通信開始したらopenアラートを出します
ws.addEventListener('open' , function (e) {
	alert('open');
}, false);

ws.addEventListener('message', function (e) {
	var data = JSON.parse(e.data).data;
	barChartData.datasets[0].data = [data.ac.x, data.ac.y, data.ac.z, data.acg.x, data.acg.y, data.acg.z];
	myLine.Bar(barChartData, option);
});