package fish.collection.game.util
{
	import flash.events.Event;
	
	public class CustumEvent extends Event
	{
		// イベントの種類を定義(静的なプロパティ)
		public static const CATCH_FISH:String = "catshFish";
		public static const POI_SCOOP:String = "poiScoop";
		
		public function CustumEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			// 継承元のEventクラスのコンストラクタを呼び出す
			super(type, bubbles, cancelable);
		}
		// EventDispacherを呼び出すためのオーバーライド
		override public function clone():Event 
		{
			return new CustumEvent(type, bubbles, cancelable);
		}
		// toString()出力用
		override public function toString():String 
		{
			return formatToString("CustumEvent", "type", "bubbles", "cancelable");
		}
	}
}