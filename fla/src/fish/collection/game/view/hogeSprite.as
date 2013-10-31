package fish.collection.game.view 
{
	import starling.display.Sprite;
	import starling.display.Quad;
	import starling.events.Event;
	public class hogeSprite extends Sprite 
	{
		private var square:Quad;
		private var nUnit:Number = 50;
		
		public function hogeSprite() 
		{
			square = new Quad(nUnit, nUnit, 0x0000FF);
			addChild(square);
			square.x = nUnit;
			square.y = nUnit;
			addEventListener(Event.ENTER_FRAME, rotate);
		}
		
		private function rotate(eventObject:Event):void 
		{
			square.rotation += 0.1;
		}
	}
}