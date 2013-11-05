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
		
		/**
		 * ゲーム画面を表示する 
		 * @param startData
		 * 
		 */		
		public function showGame():void
		{
			_gameView = new GameView();
			_gameView.initialize(_idelegate);
			updateBackground();
			_gameView.initBoids();
			_container.addUI(_gameView.view);
		}
		
		/**
		 * 背景を更新 
		 */
		public function updateBackground():void
		{
			_gameView.updateBackground();
		}
		/**
		 * 魚のカラーバリエーションを更新 
		 */
		public function updateFishColor():void
		{
			_gameView.updateFishColor();
		}
		
		
		/**
		 * ポイを追加する 
		 * @param startData
		 * 
		 */		
		public function addPoi(startData:Object):void
		{
			_gameView.addPoi(startData);
		}
		
		/**
		 *ポイ回転初期化 
		 * @param rotData
		 * 
		 */		
		public function initPoiRot(rotData:Object = null):void
		{
			_gameView.initPoiRot(rotData);
		}
		/**
		 *ポイ回転
		 * @param rotData
		 * 
		 */		
		public function setPoiRot(rotData:Object = null):void
		{
			_gameView.setPoiRot(rotData);
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
		 * ポイを止める
		 * @param data
		 */
		public function stopPoi(data:Object):void
		{
			_gameView.stopPoi(data);
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