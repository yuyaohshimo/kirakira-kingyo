package fish.collection.game.view.ui
{
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class DoubleSlider extends Sprite
	{
		private var _min:Number;
		private var _max:Number;
		
		private var _bar:Sprite;
		private var _barLength:Number;
		private var change:Event = new Event(Event.CHANGE);
		
		private var _smallerValue:Number;
		public function get smallerValue():Number 
		{ 
			return _smallerValue; 
		}
		public function set smallerValue(value:Number):void 
		{
			_smallerValue = value;
			dispatchEvent(change);
		}
		
		private var _largerValue:Number;
		public function get largerValue():Number 
		{ 
			return _largerValue; 
		}
		public function set largerValue(value:Number):void 
		{
			_largerValue = value;
			dispatchEvent(change);
		}
		
		
		public function DoubleSlider($min:Number, $max:Number, $smallerValue:Number, $largerValue:Number, $barLength:Number = 200) 
		{
			_min = $min;
			_max = $max;
			_smallerValue = $smallerValue;
			_largerValue = $largerValue;
			_barLength = $barLength;
			
			_bar = new Sprite();
			drawBar(_bar);
			addChild(_bar);
			
			var _smallerNob:Nob = new Nob(_barLength);
			_bar.addChild(_smallerNob);
			_smallerNob.x = smallerValue / _max * _barLength;
			
			var _sText:TextField = createTextField(-20, 5);
			_sText.text = "min:" + String(Math.floor(_smallerValue));
			_smallerNob.addChild(_sText);
			
			_smallerNob.addEventListener(Event.CHANGE, function(e:Event):void 
			{
				smallerValue = _smallerNob.x / _barLength * _max;
				if (_smallerValue > _largerValue) 
				{
					smallerValue = _largerValue;
					_smallerNob.x = _largerNob.x;
				}
				_sText.text = "min:" + String(Math.floor(_smallerValue));
			});
			
			
			var _largerNob:Nob = new Nob(_barLength);
			_bar.addChild(_largerNob);
			_largerNob.x = _largerValue / _max * _barLength;
			
			var _lText:TextField = createTextField(-20, -32);
			_lText.text = "max:" + String(Math.floor(_largerValue));
			_largerNob.addChild(_lText);
			
			_largerNob.addEventListener(Event.CHANGE, function(e:Event):void 
			{
				largerValue = _largerNob.x / _barLength * _max;
				if (_largerValue < _smallerValue) 
				{
					largerValue = _smallerValue;
					_largerNob.x = _smallerNob.x;
				}
				_lText.text = "max:" + String(Math.floor(_largerValue));
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
			tf.x = $x; tf.y = $y;
			tf.width = 55; tf.height = 18;
			tf.scaleX = tf.scaleY = 1.3;
			tf.mouseEnabled = false;
			return tf;
		}
	}
}