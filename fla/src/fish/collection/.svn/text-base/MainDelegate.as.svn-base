package fish.collection
{
	/**
	 * main delegate
	 * @author A12697
	 */
	public class MainDelegate
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _model:MainModel;
		private var _mainFacade:MainFacade;
	
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set model(value:MainModel):void
		{
			_model = value;
		}
		
		public function set mainFacade(value:MainFacade):void
		{
			_mainFacade = value;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MainDelegate()
		{
		}
		
		/**
		 * ゲームビューを表示
		 */
		public function showGame():void
		{
			_model.showGame();
		}

		/**
		 * 金魚get成功時のデータ送信  
		 * @param data
		 */
		public function sendFish(data:Object):void
		{
			_model.sendFish(data);
		}
		
		/**
		 * 金魚get失敗時のデータ送信   
		 * @param data
		 */
		public function sendLife(data:Object):void
		{
			_model.sendLife(data);
		}
	}
}