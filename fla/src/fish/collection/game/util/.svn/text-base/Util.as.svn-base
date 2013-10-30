package fish.collection.game.util
{
	public class Util
	{
		public function Util()
		{
		}
		
		
		/**
		 * スムースムーブ関数
		 * @param changeVal 変更した値
		 * @param zoomVal 目標値
		 * @param smoothVal スムースの変化度合い
		 * @return 変化後の値
		 */
		public static function smoothMoveFunc(changeVal:Number, zoomVal:Number, smoothVal:Number):Number
		{
			var resultVal:Number = 0;
			var margin:Number = zoomVal - changeVal;
			if(Math.abs(margin) < 1.0) {
				resultVal = zoomVal;
			} else {
				resultVal = changeVal + margin * smoothVal;
			}
			return resultVal;
		}
		
		public static function getRandom(low:Number,high:Number):Number
		{
			return low+Math.floor(Math.random()*((high-low)));
		}
		
		public static function map(value:Number, inMin:Number, inMax:Number, outMin:Number, outMax:Number):Number
		{
			var mapVal:Number = 0.0;
			
			if (inMax - inMin != 0.0)
			{
				mapVal = (inMax * outMin - value * outMin + value * outMax - inMin * outMax) / (inMax - inMin);
			}
			else
			{
				trace('Util.map::不正な値が入力されました', inMax - inMin);
			}
			
			return mapVal;
		}
	}
}