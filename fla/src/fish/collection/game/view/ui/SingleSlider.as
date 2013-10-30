package fish.collection.game.view.ui
{
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SingleSlider extends Sprite
	{
		private var _min:Number;
		private var _max:Number;
		
		private var _bar:Sprite;
		private var _barLength:Number;
		private var change:Event = new Event(Event.CHANGE);
		private var _smallerNob:Nob;
		
		private var _value:Number;
		public function get value():Number 
		{ 
			return _value; 
		}
		public function set value(value:Number):void 
		{
			_value = value;
			dispatchEvent(change);
		}
		
		public function clean():void
		{
			if (change)
				change = null;
			if (_bar)
			{
				removeAllChild(_bar);
				removeFromParent(_bar);
				_bar = null;
			}
			if (_smallerNob)
			{
				_smallerNob.clean();
				removeAllChild(_smallerNob);
				removeFromParent(_smallerNob);
				_smallerNob = null;
			}
		}
		
		
		
		public function SingleSlider($min:Number, $max:Number, $smallerValue:Number, label:String = '', $barLength:Number = 200) 
		{
			_min = $min;
			_max = $max;
			_value = $smallerValue;
			_barLength = $barLength;
			
			_bar = new Sprite();
			drawBar(_bar);
			addChild(_bar);
			
			_smallerNob = new Nob(_barLength);
			_bar.addChild(_smallerNob);
			_smallerNob.x = _value / _max * _barLength;
			
			var _sText:TextField = createTextField(-20, 5);
			_sText.text = label + ':' + String(Math.floor(_value));
			_smallerNob.addChild(_sText);
			
			_smallerNob.addEventListener(Event.CHANGE, function(e:Event):void 
			{
				value = _smallerNob.x / _barLength * _max;
				_sText.text = label + ':' + String(Math.floor(_value));
			});
			
			
		}
		
		protected function drawBar(sp:Sprite):void 
		{
			var barHeight:Number = 5;
			var g:Graphics = sp.graphics;
			g.beginFill(0x000000);
			g.drawRect(0, -barHeight / 2, _barLength, barHeight);
		}
		
		private function createTextField($x:Number, $y:Number):TextField 
		{
			var tf:TextField = new TextField();
			tf.x = $x;
			tf.y = $y;
			tf.multiline = true;
			tf.width = 550; 
			tf.height = 30;
			//tf.scaleX = tf.scaleY = 1.3;
			tf.mouseEnabled = false;
			return tf;
		}
	}
}