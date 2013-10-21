package fish.collection
{
	import fish.collection.game.GameModel;
	import fish.collection.net.FishClient;
	import fish.collection.poi.PoiModel;
	import fish.collection.top.TopModel;
	
	import pigglife.view.ViewContainer;

	/**
	 * main model 
	 * @author A12697
	 */
	public class MainModel
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _client:FishClient;
		private var _config:Configuration;
		private var _delegate:MainDelegate;
		private var _facade:MainFacade;
		private var _container:ViewContainer;
		private var _topModel:TopModel;
		private var _poiModel:PoiModel;
		private var _gameModel:GameModel;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set client(value:FishClient):void
		{
			_client = value;
		}
		
		public function set delegate(value:MainDelegate):void
		{
			_delegate = value;
		}
		
		public function set facade(value:MainFacade):void
		{
			_facade = value;
		}
		
		public function set container(value:ViewContainer):void
		{
			_container = value;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MainModel()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize():void
		{
			showTop();
		}
		
		/**
		 * 接続開始 
		 */
		public function start():void
		{
			_client.open();
		}
		
		/**
		 * トップロゴを表示 
		 */
		public function showTop():void
		{
			if (!_topModel)
			{
				_topModel = new TopModel();
				_topModel.initialize(_delegate, _container);
			}
			_topModel.showTop();
		}
		
		/**
		 * トップタイトル画像を表示 
		 */
		public function showTitle():void
		{
			if (!_topModel)
				return;
			_topModel.showTitle();
		}
		
		/**
		 * ポイを表示 
		 */
		public function showPoi(data:Object):void
		{
			// トップを消す
			if (_topModel)
			{
				_topModel.clean();
				_topModel = null;
			}
			
			if (!_poiModel)
			{
				_poiModel = new PoiModel();
				_poiModel.initialize(_delegate, _container);
			}
			_poiModel.showPoi(data);
		}
		
		/**
		 * ポイを動かす
		 * @param data
		 */
		public function updatePoiPos(data:Object):void
		{
			if (!_poiModel)
				return;
			_poiModel.updatePoiPos(data);
		}
		
		/**
		 * ゲームモジュールを表示
		 */
		public function showGame():void
		{
			if (!_gameModel)
			{
				_gameModel = new GameModel();
				_gameModel.initialize(_delegate, _container);
			}
			_gameModel.showGame();
		}
		
		/**
		 * 金魚get成功時のデータ送信 
		 * @param data
		 */
		public function sendFish(data:Object):void
		{
			_facade.sendFish(data);
		}
		
		/**
		 * 金魚get失敗時のデータ送信  
		 * @param data
		 */
		public function sendLife(data:Object):void
		{
			_facade.sendLife(data);
		}
	}
}