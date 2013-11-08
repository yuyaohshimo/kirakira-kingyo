package fish.collection
{
	import fish.collection.game.GameModel;
	import fish.collection.net.FishClient;
	import fish.collection.top.TopModel;
	
	import flash.display.Stage;
	
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
			// ゲーム画面を表示
			if (!_gameModel)	// ゲームモデルがなければ作ってゲーム画面へ遷移する
			{
				_gameModel = new GameModel();
				_gameModel.initialize(_delegate, _container);
				_gameModel.showGame();
			}
			// トップモデル作成してトップ画面表示
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
			// トップ画面表示
			if (!_topModel)
				return;
			_topModel.showTitle();
		}
		/**
		 * ゲーム画面を表示 
		 * @param startData
		 * 
		 */		
		public function showGame(startData:Object = null):void
		{
			// トップをフェードアウトさせる
			if (_topModel)
				_topModel.fadeout(topFadeoutHandler);
			
			// ゲーム画面を表示
			if (!_gameModel)	// ゲームモデルがなければ作ってゲーム画面へ遷移する
			{
				_gameModel = new GameModel();
				_gameModel.initialize(_delegate, _container);
				_gameModel.showGame();
				_gameModel.addPoi(startData);
			}
			else	// ゲームモデルが存在すればポイを追加する
			{
				_gameModel.addPoi(startData);
			}
		}
		
		/**
		 * トップ画面がフェードアウトしたハンドラ 
		 * 
		 */		
		private function topFadeoutHandler():void
		{
			// トップを消す
			if (_topModel)
			{
				_topModel.clean();
				_topModel = null;
			}
		}
		
		/**
		 *ポイ回転の初期化 
		 * @param data
		 * 
		 */		
		public function initPoiRot(data:Object):void
		{
			_gameModel.initPoiRot(data);
		}
		/**
		 *ポイ回転 
		 * @param data
		 * 
		 */		
		public function setPoiRot(data:Object):void
		{
			_gameModel.setPoiRot(data);	
		}
		
		public function setRotateCorrection(data:Object):void
		{
			_gameModel.setRotateCorrection(data);
		}
		
		/**
		 * ポイを動かす
		 * @param data
		 */
		public function updatePoiPos(data:Object):void
		{
			if (!_gameModel)
				return;
			_gameModel.updatePoiPos(data);
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
		
		/**
		 * ぽいを止める 
		 * @param data
		 * 
		 */		
		public function stopPoi(data:Object):void
		{
			_gameModel.stopPoi(data);
		}
		
		/**
		 * コントロールパネルを開く
		 * 
		 */		
		public function openControlPanel():void
		{
			_gameModel.openControlPanel();
		}
	}
}