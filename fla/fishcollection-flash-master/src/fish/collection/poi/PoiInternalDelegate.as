package fish.collection.poi
{
	import fish.collection.MainDelegate;

	public class PoiInternalDelegate
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _model:PoiModel;
		private var _delegate:MainDelegate;
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function PoiInternalDelegate(model:PoiModel, delegate:MainDelegate)
		{
			_model = model;
			_delegate = delegate;
		}
		
		/**
		 * ポイを削除 
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
	}
}