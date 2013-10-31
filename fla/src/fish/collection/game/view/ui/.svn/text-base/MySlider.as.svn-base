package fish.collection.game.view.ui
{
	import com.bit101.components.Slider;
	
	import fish.collection.game.util.Util;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	public class MySlider extends Slider
	{
		private var _tf:TextField;
		private var _type:String;
		private var _key:String;
		
		private var _minVal:Number;
		private var _maxVal:Number;
		
		public function MySlider(type:String, key:String, min:Number = 0.0, max:Number = 100.0, orientation:String="horizontal", parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function=null)
		{
			super(orientation, parent, xpos, ypos, defaultHandler);
			_key = key;
			_type = type;
			_tf = new TextField();
			_tf.text = _type + '::' + _key + String(getValue());
			_tf.x = 100;
			_tf.width = 500;
			addChild(_tf);
			
			_minVal = min;
			_maxVal = max;
		}
		
		
		public function get type():String
		{
			return _type;
		}

		public function get key():String
		{
			return _key;
		}
		
		public function setTextVal():void
		{
			_tf.text = '';
			_tf.text = _type + '::' + _key + String(getValue());
		}
		
		public function getValue():Number
		{
			var temp:Number = Util.map(value, 0.0, 100.0, _minVal, _maxVal);
			return temp;
		}
	}
}