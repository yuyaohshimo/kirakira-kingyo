package fish.collection.poi
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import fish.collection.configuration.FontNames;
	import fish.collection.poi.configuration.PoiConfiguration;
	import fish.collection.poi.data.LocateData;
	import fish.collection.poi.data.PoiData;
	
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
		private var _idelegate:PoiInternalDelegate;
		private var _container:Sprite;
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
		public function get view():Sprite {return _container;}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function PoiView(idelegate:PoiInternalDelegate)
		{
			_idelegate = idelegate;
		}
		
		/**
		 * 初期化 
		 */
		public function initialize():void
		{
			_container = new Sprite();
			addChild(_container);
			
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
			_container.addChild(_poi);
			
			// ユーザー名
			createName();
			
			// 「残り」
			createLife();
			
			// ポイの残数
			updateLife();
			
			_buttonHelper = new ButtonHelper(_container).click(onClick);
		}
		
		/**
		 * ポイを動かす 
		 * @param data
		 */
		public function updatePoiPos(data:LocateData):void
		{
			//log(data);
			_poi.x = data.ac;
			_poi.y = data.acg;
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			Executor.cancelByName(EXECUTE_NAME);
			removeAllChild(this);
			if (_container)
			{
				removeAllChild(_container);
				removeFromParent(_container);
			}
			_container = null;
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
			_gotfishData.t_id = "p1";
			_gotfishData.fish_info.size = "small";
			_gotfishData.fish_info.score = _scoreData["type1"];
			_idelegate.sendFish(_gotfishData);
			
			// 失敗時
			//_life = (_life > 1) ? _life - 1 : 0;	
			//_idelegate.sendLife({id:"game.life", t_id:"p1", life:_life});		
			//updateLife();
			
			// ポイを一時的に消す
			//hidePoi();
		}
		
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
			scoreLoader.load(new URLRequest("scorelist.json"));
			
			// 成功時送信JSON読み込み
			var sendfishLoader:URLLoader = new URLLoader();
			sendfishLoader.dataFormat = URLLoaderDataFormat.TEXT;
			sendfishLoader.addEventListener(Event.COMPLETE, onLoadSendfish);
			sendfishLoader.load(new URLRequest("sendfish.json"));
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
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			
			// TextField
			_userName = new TextField();
			_userName.defaultTextFormat = format;
			_userName.text = _data.t_id + " " + _data.name;
			_userName.width = 200;
			
			_userName.x = int((_poi.width - _userName.width) *.5);
			_userName.y = _poi.y - 60;
			
			_poi.addChild(_userName);
		}
		
		/**
		 * ポイの残数表示 
		 */
		private function createLife():void
		{
			// TextFormat
			var format:TextFormat = new TextFormat();
			format.size = 20;
			format.font = FontNames.HELVETICA;
			format.bold = true;
			
			// TextField
			var rest:TextField = new TextField();
			rest.defaultTextFormat = format;
			rest.text = "残り";

			rest.x = _poi.x + 40;
			rest.y = _poi.y - 30;
			_poi.addChild(rest);
			
			// ポイの残数表示位置
			_userLife = new Sprite();
			_userLife.x = rest.width;
			_userLife.y = rest.y;
		}
		
		/**
		 * ポイの残数更新 
		 */
		private function updateLife():void
		{
			if (_userLife)
				removeAllChild(_userLife);
			
			// ポイ残数
			var lifes:Sprite = new Sprite();
			for (var i:int = 0; i < _life; i++) 
			{
				var life:Bitmap = new Bitmap(new Life);
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
	}
}