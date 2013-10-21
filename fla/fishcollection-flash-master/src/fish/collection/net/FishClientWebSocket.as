package fish.collection.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import fish.collection.net.websocket.WebSocket;
	import fish.collection.net.websocket.WebSocketErrorEvent;
	import fish.collection.net.websocket.WebSocketEvent;
	import fish.collection.net.websocket.WebSocketHandler;

	public class FishClientWebSocket
	{
		private var _websocket:WebSocket;
		private var _handler:WebSocketHandler;
		private var pings:Object = {};
		private var dumbIncrementValue:int = 0;
		
		public function FishClientWebSocket(handler:WebSocketHandler)
		{
			_handler = handler;
		}
		
		/**
		 * 通信開始 
		 * @param url
		 * @param origin
		 */
		public function open():void
		{
			if (_websocket != null)
			{
				_websocket.close();
			}
			_websocket = new WebSocket("ws://localhost:8888", "*", "lws-mirror-protocol", 5000);
			_websocket.debug = true;
			_websocket.connect();
			_websocket.addEventListener(WebSocketEvent.CLOSED, handleWebSocketClosed);
			_websocket.addEventListener(WebSocketEvent.OPEN, handleWebSocketOpen);
			_websocket.addEventListener(WebSocketEvent.MESSAGE, handleWebSocketMessage);
			_websocket.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			_websocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			_websocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, handleConnectionFail);
		}
		
		private function handleWebSocketClosed(event:WebSocketEvent):void 
		{
			WebSocket.logger("Websocket closed.");
		}
		
		private function handleWebSocketOpen(event:WebSocketEvent):void 
		{
			WebSocket.logger("Websocket Connected");
		}
		
		/**
		 * データ受信 
		 * @param event
		 */
		private function handleWebSocketMessage(event:WebSocketEvent):void 
		{
			if (_handler !== null)
			{
				_handler.onMessage(event.message.utf8Data);
			}
		}
		
		private function handleIOError(event:IOErrorEvent):void 
		{
			log();
		}
		
		private function handleSecurityError(event:SecurityErrorEvent):void 
		{
		}
		
		private function handleConnectionFail(event:WebSocketErrorEvent):void 
		{
			WebSocket.logger("Connection Failure: " + event.text);
		}
		
		public function get isOpen():Boolean
		{
			return _websocket != null;
		}
		
		/**
		 * データ送信 
		 * @param message
		 */
		public function send(message:String):void
		{
			_websocket.sendUTF(message);
		}
		
		public function close():void
		{
			_websocket.close();
		}
		
		private function handleOpen(e:Event):void
		{
			if (_handler !== null)
			{
				_handler.onOpen();
			}
		}
		
		private function handleClose(e:Event):void
		{
			if (_handler !== null)
			{
				_handler.onClose();
			}
		}
	}
}