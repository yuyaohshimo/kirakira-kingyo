package fish.collection.top
{
	import fish.collection.MainDelegate;
	
	import pigglife.view.ViewContainer;

	/**
	 *　top画面
	 * @author bamba misaki
	 */
	public class TopModel
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _idelegate:TopInternalDelegate;
		private var _container:ViewContainer;
		private var _topView:TopView;
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function TopModel()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize(delegate:MainDelegate, container:ViewContainer):void
		{
			_idelegate = new TopInternalDelegate(this, delegate);
			_container = container;
			
			_topView = new TopView(_idelegate);
			_topView.initialize();
			_container.addUI(_topView.view);
		}
		
		/**
		 * トップを表示 
		 */
		public function showTop():void
		{
			_topView.show();
		}
		
		/**
		 * サーバーとつながってる場合金魚を表示 
		 */
		public function showTitle():void
		{
			_topView.showTitle();
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			_topView.clean();
			_topView = null;
		}
	}
}