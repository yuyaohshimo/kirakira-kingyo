package fish.collection.poi.mock
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import fish.collection.MainDelegate;
	import fish.collection.poi.PoiModel;
	import fish.collection.poi.data.PoiData;
	
	import pigglife.view.ViewContainer;

	/**
	 * ポイのモック 
	 * @author bamba misaki
	 */
	public class MockPoiDelegate extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _delegate:MainDelegate;
		private var _container:ViewContainer;
		private var _poiModel:PoiModel;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set delegate(value:MainDelegate):void
		{
			_delegate = value;
		}
		
		public function set container(value:ViewContainer):void
		{
			_container = value;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MockPoiDelegate()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize():void
		{
			_poiModel = new PoiModel();
			_poiModel.initialize(_delegate, _container);
			_poiModel.showPoi(createPoiData());
			
			var stage:Sprite = new Sprite();
			
			addChild(stage);
			
			// ポイの位置データ
			addEventListener(Event.ENTER_FRAME,function (e:Event):void
			{
				var obj:Object;
				// スプライト上のマウスカーソルの位置を取得
				var mouse_x:Number = stage.mouseX *30;
				var mouse_y:Number = stage.mouseY *30;
				
				obj ={
					t_id:"p1", 
					locate_info:
					{
						ac:mouse_x,
						acg:mouse_y,
						rr:0,
						doShake:false,
						doScoop:false
					}
				};
				
				_poiModel.updatePoiPos(obj);
			});
		}
		
		/**
		 * テストデータ 
		 * @return 
		 */
		private function createPoiData():PoiData
		{
			var obj:Object ={
				t_id:"p1", 
				name:"小栗旬"
			};
			var data:PoiData = new PoiData(obj);
			
			return data;
		}
	}
}