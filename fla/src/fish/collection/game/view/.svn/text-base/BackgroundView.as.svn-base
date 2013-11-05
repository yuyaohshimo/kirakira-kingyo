package fish.collection.game.view
{
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import pigglife.util.Tween;

	public class BackgroundView extends Sprite
	{
		private var _container:Sprite;
		private var _bitmap:Bitmap;
		private var _id:int;
		private var BACK_BITMAPS:Array = [new Bitmap(new kirakira()), new Bitmap(new kirakira()), new Bitmap(new kirakira()), new Bitmap(new kirakira())];
		
		public function get backId():int {return _id;}
		
		public function BackgroundView()
		{
			_container = new Sprite();
			addChild(_container);
		}
		
		public function update():void
		{
			if (_bitmap)
				_container.removeChild(_bitmap);

			_id = Math.random()*BACK_BITMAPS.length;
			_bitmap = BACK_BITMAPS[_id];
			_container.addChild(_bitmap);
		}
		
		public function clean():void
		{
		}
	}
}