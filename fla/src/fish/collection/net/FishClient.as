package fish.collection.net
{
	import fish.collection.MainFacade;
	import fish.collection.MainModel;
	import fish.collection.net.websocket.WebSocketHandler;
	
	import pigglife.util.Callback;
	import pigglife.util.Messages;

	/**
	 * ネットワーククライアント
	 * WebSocket を使いソケット通信を実現します。
	 * @author atsumo
	 */
	public class FishClient implements WebSocketHandler
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _facade:MainFacade;
		private var _websocket:FishClientWebSocket;
		private var _tryCount:int;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function set facade(value:MainFacade):void
		{
			_facade = value;
		}
		
		//=========================================================
		// VARIABLES
		//=========================================================
		public function FishClient()
		{
		}
		
		/**
		 * クライアント接続をオープン
		 */
		public function open():void
		{
			_tryCount = 0;
			log("opening connection to");
			
			if (_websocket != null)
			{
				// 既に存在する接続はとじておく
				_websocket.close();
			}
			
			_websocket = new FishClientWebSocket(this);
			_websocket.open();
			// 試行カウントを１増やしておく
			_tryCount++;
		}
		
		/**
		 * クライアント接続をクローズ
		 */
		public function close():void
		{
			log("closing connection");
			if (_websocket != null)
			{
				_websocket.close();
			}
		}
		
		/**
		 * サーバーにデータを送信
		 */
		public function send(data:Object, callback:Callback = null):void
		{
			// WebSocketがオープンしていない場合は無視
			if (!_websocket.isOpen)
			{
				onSocketError(new Error(Messages.of('error.disconnected')));
				return;
			}

			var json:String = JSON.stringify(data);
			log(json);
			_websocket.send(json);
		}
		
		/**
		 * 接続オープン時
		 */
		public function onOpen():void
		{
			log();
			_tryCount = 0;
		}
		
		/**
		 * 接続クローズ時
		 */
		public function onClose():void
		{
			log('close');
		}
		
		/**
		 * メッセージ受信時
		 */
		public function onMessage(message:String):void
		{
			// メッセージの受信
			log(message);
			try
			{
				var json:Object = JSON.parse(message);//JSON.(jsonText);
				_facade.onData(json);
			}
			catch (e:Error)
			{
				log(e.getStackTrace());
				_onError({name:e.name, message:(e.message)? e.message: ''});
			}
		}
		
		/**
		 * ソケットエラー発生時
		 */
		public function onSocketError(e:Error):void
		{
			log(e.message);
		}
		
		/**
		 * ハンドラのエラー処理
		 */
		public function onHandleError(e:Error):void
		{
			log(e.message, e.getStackTrace());
			showError(e);
		}
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
		private function _onError(data:Object):void
		{
			log();
			var error:Error = new Error();
			error.name  = data.name;
			error.message = (data.messaeg)? data.message : Messages.of('error.'+data.name);
			showError(error);
		}
		
		private function showError(error:Error):void
		{
			log(error);
		}
	}
}