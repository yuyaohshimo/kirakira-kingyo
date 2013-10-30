package fish.collection.game.view.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class Nob extends Sprite
	{
		public var dragArea:Rectangle;
		
		private var tf:TextField;
		private var change:Event = new Event(Event.CHANGE);
		
		
		public function Nob(dragLength:Number) 
		{
			dragArea = new Rectangle(0, 0, dragLength,0);
			
			var g:Graphics = graphics;
			g.beginFill(0x999999, 0.7);
			g.lineStyle(3, 0x000000);
			g.drawCircle(0, 0, 10);
			
			buttonMode = true;
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		private function onAdd(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			addEventListener
			(
				MouseEvent.MOUSE_DOWN,
				mouseDrag
			);
		}
		
		private function mouseDrag(e:MouseEvent):void 
		{
			startDrag(false, dragArea);
			stage.addEventListener
				(
					MouseEvent.MOUSE_UP, 
					function(e:MouseEvent):void 
					{
						stage.removeEventListener(MouseEvent.MOUSE_UP, arguments.callee);
						stopDrag();
						dispatchEvent(change);
					}
				);
		}
		
		public function clean():void
		{
			if (tf)
				tf = null;
			if (dragArea)
				dragArea = null;
			if (change)
				change = null;
			
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			
			stage.removeEventListener	(
				MouseEvent.MOUSE_UP, 
				function(e:MouseEvent):void 
				{
					stage.removeEventListener(MouseEvent.MOUSE_UP, arguments.callee);
					stopDrag();
					dispatchEvent(change);
				}
			);
		}
	}
}
