package fish.collection.fish.mock
{
	import fish.collection.fish.FishView;
	import fish.collection.fish.data.FishData;
	
	import pigglife.font.FontNames;
	import pigglife.view.RootStage;
	import pigglife.view.ViewContainer;
	import pigglife.view.button.PiggButton;

	/**
	 * 金魚生成のモック 金魚の見た目確認用
	 * @author bamba misaki
	 */
	public class MockFishDelegate
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _container:ViewContainer;
		private var _fishView:FishView;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set container(value:ViewContainer):void
		{
			_container = value;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MockFishDelegate()
		{
		}
		
		/**
		 * 初期化 
		 */
		public function initialize():void
		{
			_fishView = new FishView();
			_fishView.initialize(createFishData());
			_fishView.view.x = _fishView.view.y = 100;
			_fishView.show();
			_container.addUI(_fishView.view);
			
			new PiggButton(12, FontNames.Sans).text('DEME').size(100, 30).position(0, 0).onClick(showDeme).appendTo(RootStage.stage);
		}
		
		private function showDeme():void
		{
		}
		
		/**
		 * テストデータ 
		 * @return 
		 */
		private function createFishData():FishData
		{
			var obj:Object ={
				code:"fish1", 
				name:"わたしだ", 
				type:"deme" 
			};
			var data:FishData = new FishData(obj);
			
			return data;
		}
	}
}