package fish.collection.game.poi
{
	import fish.collection.configuration.FontNames;
	import fish.collection.game.GameInternalDelegate;
	import fish.collection.game.poi.configuration.PoiConfiguration;
	import fish.collection.game.poi.data.PoiData;
	import fish.collection.game.util.CustumEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import pigglife.util.ButtonHelper;
	import pigglife.util.Executor;
	
	/**
	 * ポイ 
	 * @author bamba misaki
	 */
	public class PoiView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _idelegate:GameInternalDelegate;
		//private var _container:Sprite;
		private var _data:PoiData;
		private var _buttonHelper:ButtonHelper;
		private var _scoreData:Object;
		private var _gotfishData:Object;
		private var _poi:Sprite;
		private var _userName:TextField;
		private var _userLife:Sprite;
		private var _life:int;
		
		private const EXECUTE_NAME:String = "poi";
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		//public function get view():Sprite {return _container;}

		public function set life(value:int):void
		{
			_life = value;
		}

		public function get life():int
		{
			return _life;
		}

		public function getPosX():Number
		{
			return _poi.x + this.width / 2.0;
		}
		public function getPosY():Number
		{
			return _poi.y + 30.0;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function PoiView(idelegate:GameInternalDelegate)
		{
			super();
			_idelegate = idelegate;
		}
		
		/**
		 * 初期化 
		 */
		public function initialize():void
		{
//			_container = new Sprite();
//			addChild(_container);
			
			// ポイ残数初期化
			_life = PoiConfiguration.MAX_LIFE;
			
			// JSON読み込み
			loadJson();
		}
		
		/**
		 * ポイを表示 
		 */
		public function show(data:PoiData):void
		{
			_data = data;
			
			// ポイ本体の表示
			_poi = new Sprite();
			_poi.addChild(createPoiBitmap());
			addChild(_poi);
			
			// ユーザー名
			createName();
			
			// 「残り」
			createLife();
			
			// ポイの残数
			updateLife();
			
			
			_buttonHelper = new ButtonHelper(_poi).click(onClick);
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			Executor.cancelByName(EXECUTE_NAME);
			removeAllChild(this);
//			if (_container)
//			{
//				removeAllChild(_container);
//				removeFromParent(_container);
//			}
//			_container = null;
			if (_buttonHelper)
				_buttonHelper.clean();
			_buttonHelper = null;
		}
		
		
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
		private function onClick():void
		{
			// 成功時
			//_gotfishData.data.t_id = "p1";
			//_gotfishData.data.fish_info.size = "small";
			//_gotfishData.data.fish_info.score = _scoreData["type1"];
			_idelegate.sendFish(_gotfishData);
			
			// 失敗時
			_life = (_life > 1) ? _life - 1 : 0;	
			_idelegate.sendLife({id:"game.life", data:{t_id:"1", lastLife:_life}});
			
			// ポイを一時的に消す
			hidePoi();
		}
		
		// ここをgameViewでやる
		/**
		 * JSON読み込み 
		 * @param event
		 */
		private function loadJson():void
		{
			// スコアJSON読み込み
			var scoreLoader:URLLoader = new URLLoader();
			scoreLoader.dataFormat = URLLoaderDataFormat.TEXT;
			scoreLoader.addEventListener(Event.COMPLETE, onLoadScore);
			scoreLoader.load(new URLRequest("fish/collection/json/scorelist.json"));
			
			// 成功時送信JSON読み込み
			var sendfishLoader:URLLoader = new URLLoader();
			sendfishLoader.dataFormat = URLLoaderDataFormat.TEXT;
			sendfishLoader.addEventListener(Event.COMPLETE, onLoadSendfish);
			sendfishLoader.load(new URLRequest("fish/collection/json/sendfish.json"));
		}
		
		/**
		 * スコアデータJSON読み込み完了 
		 * @param event
		 */
		private function onLoadScore(event:Event):void
		{
			var json:String = URLLoader(event.currentTarget).data;
			_scoreData = JSON.parse(json);
			trace(_scoreData["type1"].normal, _scoreData["type2"].normal, _scoreData["type3"].normal, _scoreData["type4"].normal);
		}
		
		/**
		 * 成功時送信データ読み込み完了 
		 * @param event
		 */
		private function onLoadSendfish(event:Event):void
		{
			var json:String = URLLoader(event.currentTarget).data;
			_gotfishData = JSON.parse(json);
		}
		
		/**
		 * タイプに応じたポイのbitmapを生成 
		 * @return 
		 */
		private function createPoiBitmap():Bitmap
		{
			var poi:Bitmap;
			poi = new Bitmap(new Poi1);
			poi.scaleX = poi.scaleY = 0.5;
			return poi
		}
		
		/**
		 * ユーザー名を表示 
		 */
		private function createName():void
		{
			// TextFormat
			var format:TextFormat = new TextFormat();
			format.size = 24;
			format.font = FontNames.HELVETICA;
			format.align = TextFormatAlign.CENTER;
			
			// TextField
			_userName = new TextField();
			_userName.defaultTextFormat = format;
			_userName.text = _data.name;
			_userName.width = 200;
			
			_userName.x = _poi.x;
			_userName.y = _poi.y - 60;
			_userName.scaleX = _userName.scaleY = 0.5;
			
			// テキストフィールドをビットマップ化
			var nameBm:Bitmap = tf2Bm(_userName);
			nameBm.x = _poi.x;//int((_poi.width - nameBm.width) *.5);
			nameBm.y = _poi.y - 60;
			// テキストフィールドを非使用に
			//_userName.visible = false;
			
			_poi.addChild(_userName);
		}
		
		
		
		/**
		 * ポイの残数表示 
		 */
		private function createLife():void
		{
			var uin:uin_font = new uin_font();
			// TextFormat
			var format:TextFormat = new TextFormat();
			format.size = 20;
			format.font = FontNames.HELVETICA;
			
			// TextField
			var rest:TextField = new TextField();
			rest.defaultTextFormat = format;
			rest.text = "残り";
			
			rest.x = _poi.x;
			rest.y = _poi.y - 30;
			rest.scaleX = rest.scaleY = 0.5;
			// テキストフィールドをビットマップ化
			var restBm:Bitmap = tf2Bm(rest);
			restBm.x = _poi.x;
			restBm.y = _poi.y - 30;
			//rest.visible = false;
			_poi.addChild(rest);
			
			// ポイの残数表示位置
			_userLife = new Sprite();
			_userLife.x = rest.width;
			_userLife.y = rest.y;
		}
		
		/**
		 * ポイの残数更新 
		 */
		public function updateLife():void
		{
			if (_userLife)
				removeAllChild(_userLife);
			
			// ポイ残数
			var lifes:Sprite = new Sprite();
			for (var i:int = 0; i < _life; i++) 
			{
				var life:Bitmap = new Bitmap(new Life);
				life.scaleX = life.scaleY = 0.5;
				life.x = life.width*i;
				lifes.addChild(life);
			}
			_userLife.addChild(lifes);
			_poi.addChild(_userLife);
		}
		
		private function hidePoi():void
		{
			_poi.visible = false;
			Executor.executeAfterWithName(18, EXECUTE_NAME, showPoi);
		}
		
		private function showPoi():void
		{
			_poi.visible = true;
		}
		
		/**
		 * テキストフィールドをビットマップに
		 * @param tf : TextFieald
		 * @return Bitmap
		 */
		private function tf2Bm(tf:TextField):Bitmap 
		{
			// テキストフィールドをビットマップ化
			var bmData:BitmapData = new BitmapData(tf.width, tf.height, true, 0x000000);
			bmData.draw(tf);
			var bm:Bitmap = new Bitmap(bmData);
			return bm;
		}
	}
}