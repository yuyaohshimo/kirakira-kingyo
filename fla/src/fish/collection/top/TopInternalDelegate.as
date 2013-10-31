package fish.collection.top
{
	import fish.collection.MainDelegate;

	public class TopInternalDelegate
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _model:TopModel;
		private var _delegate:MainDelegate;
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function TopInternalDelegate(model:TopModel, delegate:MainDelegate)
		{
			_model = model;
			_delegate = delegate;
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			_model.clean();
		}
		
		/**
		 * ゲーム画面表示 
		 */
		public function showGame():void
		{
			_delegate.showGame();
		}
	}
}