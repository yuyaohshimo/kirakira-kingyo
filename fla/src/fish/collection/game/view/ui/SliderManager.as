package fish.collection.game.view.ui
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class SliderManager extends Sprite
	{
		private var _sliders:Vector.<SingleSlider>;
		
		public function SliderManager()
		{
			super();
		}
		public function initialize():void
		{
			_sliders = new Vector.<SingleSlider>();
		}
		public function clean():void
		{
			if (_sliders)
			{
				for (var i:int = 0, len:int = _sliders.length; i < len; i++)
				{
					if (_sliders[i])
					{
						_sliders[i].clean();
						if (_sliders[i])
						{
							removeAllChild(_sliders[i]);
							removeFromParent(_sliders[i]);
							_sliders[i] = null;
						}
					}
				}
				_sliders = null;
			}
			
			removeAllChild(this);
			removeFromParent(this);
		}
		
		/**
		 * スライダーの追加
		 */
		public function addSlider($min:Number, $max:Number, $smallerValue:Number, $barLength:Number = 200):void
		{
			var s:SingleSlider = new SingleSlider($min, $max, $smallerValue, $barLength);
			s.x = _sliders.length * 50;
			s.y = _sliders.length * 50;
			_sliders.push(s);
		}
	}
}