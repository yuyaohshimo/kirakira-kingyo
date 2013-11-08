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
			log("成功　成功　成功　成功　成功　成功　成功　");
			_client.send(data);
		}
		
		/**
		 * 金魚get失敗時のデータ送信 
		 */
		public function sendLife(data:Object):void
		{
			log("失敗　失敗　失敗　失敗　失敗　失敗　");
			_client.send(data);
		}
		
		/**
		 * データ受信 
		 * @param data
		 */
		public function onData(data:Object):void
		{
			//log("onData", data.id);
			switch(data.id)
			{
				case 'open':
				{
					_client.send({id:"game.flash"});
					_model.showTitle();
					break;
				}
				case 'game.start':
				{
					// ポイが接続された時
					_model.showGame(data);
					break;
				}
				case 'game.locate':
				{
					// ポイの重力加速度データ
					_model.updatePoiPos(data);
					break;
				}
				case 'game.stop':
				{
					// 切断　t_idがくる
					_model.stopPoi(data);
					break;
				}
				case 'game.orientation.init':
				{
					// 回転の初期値
					_model.initPoiRot(data);
					break;
				}
				case 'game.orientation':
				{
					/*
					this	fish.collection.MainFacade (@b9f88f9)	
					data	Object (@b9f82c9)	
					data	Object (@ece1a31)	
					alpha	"37.39"	
					beta	"0.81"	
					gamma	"0.36"	
					webkitCompassAccuracy	26 [0x1a]	
					webkitCompassHeading	"69.54"	
					id	"game.orientation"	
					t_id	"1"	
					*/
					// 回転の初期値
					_model.setPoiRot(data);
					break;
				}
				case 'maintenance.rotate':
				{
					_model.setRotateCorrection(data);
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