package fish.collection
{
	import fish.collection.net.FishClient;
	import pigglife.util.Callback;

	/**
	 * データ送受信
	 * @author bamba misaki
	 */
	public class MainFacade
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _client:FishClient;
		private var _model:MainModel;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set client(value:FishClient):void 
		{
			_client = value; 
		}
		
		public function set model(value:MainModel):void 
		{ 
			_model = value; 
		}

		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function MainFacade()
		{
		}
		
		/**
		 * 金魚get成功時のデータ送信 
		 */
		public function sendFish(data:Object):void
		{
			log();
			_client.send(data, new Callback(onData));
		}
		
		/**
		 * 金魚get失敗時のデータ送信 
		 */
		public function sendLife(data:Object):void
		{
			log();
			_client.send(data, new Callback(onData));
		}
		
		/**
		 * データ受信 
		 * @param data
		 */
		public function onData(data:Object):void
		{
			log("onData", data.id);
			switch(data.id)
			{
				case 'open':
				{
					_model.showTitle();
					break;
				}
				case 'game.start':
				{
					_model.showPoi(data);
					break;
				}
				case 'game.locate':
				{
					_model.updatePoiPos(data);
					break;
				}
				default:
				{
					break;
				}
			}
		}
	}
}