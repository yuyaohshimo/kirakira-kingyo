package
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.StageDisplayState;
	
	import fish.collection.poi.mock.MockPoiDelegate;

	[SWF(width="900",height="700",frameRate="24",backgroundColor="#999999")]
	public class mock_fishcollection extends fishcollection
	{
		public function mock_fishcollection()
		{
			var rate:Number = 700/900;
			var height:int = 500;
			this.scaleX = this.scaleY = height/900;
			var shape:Shape = new Shape();
			var g:Graphics = shape.graphics;
			g.beginFill(0xff0000);
			g.drawRect(0, 0, height/rate, height);
			g.endFill();
			mask = shape;
			LogConfig.enabled = true;
			stage.displayState = StageDisplayState.NORMAL;
		}
		
		override protected function initApp():void
		{
			// 各モジュールのモックを一旦ここで出し分け
			//container.register(MockEntryDelegate);
			// 金魚の見た目確認
			//container.register(MockFishDelegate);
			// ポイ
			container.register(MockPoiDelegate);
			super.initApp();
		}
	}
}