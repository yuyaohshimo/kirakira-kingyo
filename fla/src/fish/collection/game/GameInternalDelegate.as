package fish.collection.game
{
	import fish.collection.MainDelegate;

	public class GameInternalDelegate
	{
		private var _model:GameModel;
		private var _delegate:MainDelegate;
		
		public function GameInternalDelegate()
		{
		}
		
		/**
		 * 初期化
		 */
		public function initialize(model:GameModel, delegate:MainDelegate):void
		{
			_model = model;
			_delegate = delegate;
		}
		
		/**
		 * クリーン
		 */
		public function clean():void
		{
			_model.clean();
		}
		
		/**
		 * 金魚get成功時のデータ送信 
		 * @param data
		 */
		public function sendFish(data:Object):void
		{
			_delegate.sendFish(data);
		}
		
		/**
		 * 金魚get失敗時のデータ送信 
		 * @param data
		 */
		public function sendLife(data:Object):void
		{
			_delegate.sendLife(data);
		}
		
		/**
		 * 金魚の波紋アニメーション 
		 */		
		public function createWave(px:Number, py:Number, size:String):void 
		{
			_model.createWave(px, py, size);
		}
		
		/**
		 * トップ画面を表示させる 
		 */		
		public function showTopView():void
		{
			_delegate.showTop();
			_model.updateBackground();
			_model.updateFishColor();
		}
	}
}