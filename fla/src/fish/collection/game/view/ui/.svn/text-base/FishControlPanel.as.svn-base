package fish.collection.game.view.ui
{
	import com.bit101.components.ScrollBar;
	import com.bit101.components.Slider;
	import com.bit101.components.Text;
	
	import fish.collection.game.util.Util;
	import fish.collection.game.view.FishControlData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class FishControlPanel extends Sprite
	{
		private var _slider:Vector.<MySlider>;
		
		public function FishControlPanel()
		{
			super();
			_slider = new Vector.<MySlider>();
			var index:int = 0;
			for (var type:String in FishControlData.params)
			{
				for (var key:String in FishControlData.params[type])
				{
					if (key == 'SPEED_DECAY')
					{
						_slider.push(new MySlider(type, key, 6.0, 10.0, Slider.HORIZONTAL, this, 0, 20 * index, onSlide));
					}
					else
					{
						_slider.push(new MySlider(type, key, 0.0, 1.5, Slider.HORIZONTAL, this, 0, 20 * index, onSlide));
					}
					index++;
				}
			}
		}
		
		/**
		 * クリーン
		 */
		public function clean():void
		{
			for (var i:int = 0, len:int = _slider.length; i < len; i++)
			{
				_slider[i] = null;
			}
		}
		
		private function onSlide(e:Event):void
		{
			e.target.setTextVal();
			
			for (var type:String in FishControlData.params)
			{
				for (var key:String in FishControlData.params[type])
				{
					if (e.target.key == key && e.target.type == type)
					{
						FishControlData.params[type][key] = e.target.getValue();
						//trace('かえた', key, FishControlData.params[key]);
					}
				}
			}
//			for (var key:String in FishControlData.params)
//			{
//				if (e.target.key == key)
//				{
//					FishControlData.params[type][key] = e.target.getValue();
//					//trace('かえた', key, FishControlData.params[key]);
//				}
//			}
		}
	}
}
