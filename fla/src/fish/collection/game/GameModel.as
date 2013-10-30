package fish.collection.game
{
	import fish.collection.MainDelegate;
	import fish.collection.game.poi.PoiView;
	import fish.collection.game.poi.data.PoiData;
	
	import flash.events.Event;
	
	import pigglife.view.ViewContainer;

	public class GameModel
	{
		private var _idelegate:GameInternalDelegate;
		private var _container:ViewContainer;
		private var _gameView:GameView;
		
		public function GameModel()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize(delegate:MainDelegate, container:ViewContainer):void
		{
			_idelegate = new GameInternalDelegate();
			_idelegate.initialize(this, delegate);
			_container = container;
		}
		
		/**
		 * クリーン
		 */
		public function clean():void
		{
			_gameView.clean();
			_gameView = null;
		}
		
		public function showGame():void
		{
			_gameView = new GameView();
			_gameView.initialize(_idelegate);
			_container.addUI(_gameView.view);
			
			trace('ゲーム開始');
		}
		
		/**
		 * ポイを表示(ポイが投入された時に呼び出される) 
		 */
		public function showPoi(data:Object):void
		{
			
		}
			
		/**
		 * ポイを動かす
		 * @param data
		 */
		public function updatePoiPos(data:Object):void
		{
			_gameView.updatePoiPos(data);
		}
		
		/**
		 * 金魚の波紋アニメーション 
		 */		
		public function createWave(px:Number, py:Number, size:String):void 
		{
			_gameView.createWave(px, py, size);
		}
	}
}