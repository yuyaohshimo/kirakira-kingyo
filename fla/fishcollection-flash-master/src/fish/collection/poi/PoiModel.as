package fish.collection.poi
{
	import fish.collection.MainDelegate;
	import fish.collection.poi.data.LocateData;
	import fish.collection.poi.data.PoiData;
	
	import pigglife.view.ViewContainer;

	public class PoiModel
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _idelegate:PoiInternalDelegate;
		private var _container:ViewContainer;
		private var _poiView:PoiView;
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function PoiModel()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize(delegate:MainDelegate, container:ViewContainer):void
		{
			_idelegate = new PoiInternalDelegate(this, delegate);
			_container = container;
			
			_poiView = new PoiView(_idelegate);
			_poiView.initialize();
			_container.addUI(_poiView.view);
		}
		
		/**
		 * ポイを表示 
		 */
		public function showPoi(data:Object):void
		{
			var poiData:PoiData = new PoiData(data);
			_poiView.show(poiData)
		}
		
		/**
		 * ポイを動かす 
		 * @param data
		 */
		public function updatePoiPos(data:Object):void
		{
			var locateData:LocateData = new LocateData(data);
			_poiView.updatePoiPos(locateData);
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			_poiView.clean();
			_poiView = null;
		}
	}
}