package fish.collection.game.poi
{
	import com.greensock.easing.Back;
	
	import fish.collection.configuration.FontNames;
	import fish.collection.game.GameInternalDelegate;
	import fish.collection.game.poi.configuration.PoiConfiguration;
	import fish.collection.game.poi.data.PoiData;
	import fish.collection.game.util.CustumEvent;
	import fish.collection.game.view.FishControlData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import pigglife.util.ButtonHelper;
	import pigglife.util.Executor;
	import pigglife.util.Tween;
	
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
		private var _poiBm:Bitmap;
		private var _poiMc:PoiMc;
		private const EXECUTE_NAME:String = "poi";
		private var initRot:Number;
		
		public var poiX:Number;
		public var poiY:Number;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		//public function get view():Sprite {return _container;}

		public function get poiMc():PoiMc
		{
			return _poiMc;
		}

		public function set poiMc(value:PoiMc):void
		{
			_poiMc = value;
		}

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
			return this.x;// + _poiBm.width / 2.0;// * Math.cos(Math.PI / 180 * this.rotation);
		}
		public function getPosY():Number
		{
			return this.y;// + _poiBm.width / 2.0;// * Math.sin(Math.PI / 180 * this.rotation);
		}
//		public function setPosX(_x:Number):void
//		{
//			this.x = _x - _poiBm.width / 2.0;// * Math.cos(Math.PI / 180 * this.rotation);
//		}
//		public function setPosY(_y:Number):void
//		{
//			this.y = _y - _poiBm.width / 2.0;// * Math.sin(Math.PI / 180 * this.rotation);
//		}
		public function getPoiSize():Number
		{
			//return _poiBm.width;
			return _poiMc.poiInner.width;
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
			//loadJson();
			initRot = 0.0;
		}
		
		/**
		 * ポイを表示 
		 */
		public function show(data:PoiData):void
		{
			_data = data;
			
			// ポイ本体の表示
			_poi = new Sprite();
			_poiBm = createPoiBitmap(1);
			//_poi.addChild(_poiBm);
			_poiMc = new PoiMc();
			_poi.addChild(_poiMc);
			addChild(_poi);
			
			// ユーザー名
			createName();
			
			// 「残り」
			//createLife();
			
			// ポイの残数
			updateLife();
			
			
			//_buttonHelper = new ButtonHelper(_poi).click(onClick);
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
		
		/**
		 *　ポイの死亡アニメーション 
		 * 
		 */		
		public function missAnimation():void
		{
			// 
			// ぽいが敗れる
			/*
			_poi.removeChild(_poiBm);
			_poiBm = createPoiBitmap(4);
			_poi.addChild(_poiBm);
			*/
			_poiMc.gotoAndStop('miss');
			// ミスアニメーション
			Tween.applyTo(this, 1.5, {alpha: 0.0, scaleX: 0.5, scaleY: 0.5, ease:Back.easeOut, onComplete: onMissAnimationEnd});
			
		}
		
		/**
		 * ポイの死亡アニメーション終了ハンドラ 
		 * 
		 */		
		private function onMissAnimationEnd():void
		{
			trace('ポイミス', _life);
			if (_life <= 0)
			{
				// 初期位置に戻る
				this.x = FishControlData.initPoiPos[0].x;
				this.y = FishControlData.initPoiPos[0].y;
				this.alpha = 1.0;
				this.scaleX = 1.0;
				this.scaleY = 1.0;
				// ライフ元に戻す
				_life = _life = PoiConfiguration.MAX_LIFE;;
			}
			else
			{
				this.alpha = 1.0;
				this.scaleX = 1.0;
				this.scaleY = 1.0;
			}
			// ぽいを元に戻す
			_poiMc.gotoAndStop('normal');
			/*
			_poi.removeChild(_poiBm);
			_poiBm = createPoiBitmap(1);
			_poi.addChild(_poiBm);
			*/
		}
		
		/**
		 * すくうアニメーション 
		 * 
		 */		
		public function scoopAnimation():void
		{
			Tween.applyTo(_poi, 0.5, {rotationX: -20, y: _poi.height * Math.sin(Math.PI/180 * -20) / 4, scaleX: 1.1, scaleY: 1.1, ease:Back.easeOut, onComplete: onScoopAnimationEnd});
		}
		/**
		 * すくうアニメーション終了ハンドラ 
		 * 
		 */		
		private function onScoopAnimationEnd():void
		{
			Tween.applyTo(_poi, 0.5, {rotationX: 0, y: 0.0, scaleX: 1.0, scaleY: 1.0, ease:Back.easeOut, onComplete: onScoopAnimationEnd});
		}
		/**
		 * ポイの回転初期化
		 * @param rotation
		 * 
		 */		
		public function initRotatePoi(rot:Number):void
		{
			initRot = rot;
		}
		/**
		 * ポイを回転させる 
		 * @param rotation
		 * 
		 */		
		public function rotatePoi(rot:Number):void
		{
			rot = -rot;
			var mtx:Matrix = new Matrix();
			mtx.identity();
			//mtx.rotate(0.0);
//			mtx.translate(-_poiBm.width / 2.0, -_poiBm.width / 2.0);
//			mtx.rotate(Math.PI / 180.0 * (rot - initRot));
//			mtx.translate(_poiBm.width / 2.0, _poiBm.width / 2.0);
			
			
		//	mtx.translate(this.x, this.y);
			//this.transform.matrix = mtx;
			this.rotation = rot;
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
		private function createPoiBitmap(poiNomber:int):Bitmap
		{
			var poi:Bitmap;
			if (poiNomber == 1)
				poi = new Bitmap(new Poi1);
			else if (poiNomber == 2)
				poi = new Bitmap(new Poi2);
			else if (poiNomber == 3)
				poi = new Bitmap(new Poi3);
			else if (poiNomber == 4)
				poi = new Bitmap(new Poi4);
			
			//poi.scaleX = poi.scaleY = 0.5;
			return poi
		}
		
		/**
		 * ユーザー名を表示 
		 */
		private function createName():void
		{
			/*
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
			
			addChild(_userName);
			*/
			
			_poiMc.userName.userName.text = _data.name;
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
			addChild(rest);
			
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
			/*
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
			addChild(_userLife);
			*/
			// ポイ残数
			if (_life >= 0 && _life <= 3)
				_poiMc.life.gotoAndStop('life_' + _life);
			
			/*
			// ポイも変更させる
			log('ライフアップデート', _life);
			if (_life == 3)
			{
				_poi.removeChild(_poiBm);
				_poiBm = createPoiBitmap(1);
				_poi.addChild(_poiBm);
			}
			else if (_life == 2)
			{
				_poi.removeChild(_poiBm);
				_poiBm = createPoiBitmap(2);
				_poi.addChild(_poiBm);
			}
			else if (_life == 1)
			{
				_poi.removeChild(_poiBm);
				_poiBm = createPoiBitmap(3);
				_poi.addChild(_poiBm);
			}
			else if (_life == 0)
			{
				_poi.removeChild(_poiBm);
				_poiBm = createPoiBitmap(4);
				_poi.addChild(_poiBm);
			}
			*/
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