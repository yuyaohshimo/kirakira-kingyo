package
{
	import com.bit101.components.TextArea;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import fish.collection.net.FishClientWebSocket;
	import fish.collection.net.websocket.WebSocketHandler;

	/**
	 * websocket通信テスト
	 * @author bamba
	 */
	public class mock_socket extends Sprite implements WebSocketHandler
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _websocket:FishClientWebSocket;
		private var _logArea:TextArea;
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function mock_socket()
		{
			initialize();
		}
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
		/**
		 * 初期化 
		 */
		private function initialize():void
		{
			log('initialize');
			bootstrap();
			createStage();
		}
		
		/**
		 * ソケットサーバーとのつなぎ込み 
		 */		
		private function bootstrap():void
		{
			log('open');
			_websocket = new FishClientWebSocket(this);
			_websocket.open();
		}
		
		/**
		 * 画面表示 
		 */
		private function createStage():void
		{
			log();
			stage.addEventListener(MouseEvent.CLICK, handleStageClick);
			_logArea = new TextArea(this, stage.stageWidth-200, 20);
			_logArea.width = 200;
			_logArea.height = stage.stageHeight - _logArea.y - 10;
		}
		
		private function handleStageClick(e:MouseEvent):void
		{
			log(e);
			var data:Object = {
				x: e.stageX,
					y: e.stageY
			};
			
			var str:String = JSON.stringify(data);
			//_websocket.send('test');
		}
		
		private function _log(... messages):void
		{
			//topLabel.text = messages.join(' ');
			_logArea.textField.appendText(messages.join(' ') + '\n');
			// scroll to bottom
			_logArea.textField.scrollV = _logArea.textField.maxScrollV;
		}
		
		//===========================================================
		// IMPLEMENTATION METHODS
		//===========================================================
		public function onClose():void
		{
			// TODO Auto Generated method stub
			log();
		}
		
		public function onData(frame:int, data:ByteArray):void
		{
			// TODO Auto Generated method stub
			log();
		}
		
		public function onHandleError(e:Error):void
		{
			// TODO Auto Generated method stub
			log(e);
		}
		
		public function onMessage(data:String):void
		{
			// TODO Auto Generated method stub
			log(data);
			_log(data);
		}
		
		public function onOpen():void
		{
			// TODO Auto Generated method stub
			log();
		}
		
		public function onSocketError(e:Error):void
		{
			// TODO Auto Generated method stub
			log(e);
		}
	}
}