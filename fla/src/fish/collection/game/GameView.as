package fish.collection.game
{
	import adobe.utils.CustomActions;
	
	import fish.collection.game.poi.PoiView;
	import fish.collection.game.poi.data.PoiData;
	import fish.collection.game.util.CustumEvent;
	import fish.collection.game.util.Util;
	import fish.collection.game.view.Boid;
	import fish.collection.game.view.ui.DoubleSlider;
	import fish.collection.game.view.ui.FishControlPanel;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import pigglife.util.Executor;
	
	
	
	public class GameView extends Sprite
	{
		private var _idelegate:GameInternalDelegate;
		private var _container:Sprite;
		
		private var _background:Bitmap;
		
		// Poi関連
		private var _poiLayer:Sprite;
		private var _pois:Vector.<PoiView>;
		private const POI_NUM:int = 4;
		
		// Boidの数
		private const NUMBOIDS:int = 60;
		// Boidクラス
		private var _boids:Vector.<Boid>;
		
		// 魚描画レイヤー
		private var _fishLayer:Sprite;
		
		private var _fishControlPanel:FishControlPanel;
		
		// アニメーション
		private var _getMc1:Vector.<getMc1>;
		private var _missMc1:Vector.<missMc1>;
		private var _missMc2:Vector.<missMc2>;
		private var _missMc3:Vector.<missMc3>;
		private var _missMc4:Vector.<missMc4>;
		private var _waveMc_s:Vector.<waveMc_s>;
		private var _waveMc_m:Vector.<waveMc_m>;
		private var _waveMc_l:Vector.<waveMc_l>;
		
		private var _scoreData:Object = {};
		private var _gotfishData:Object = {};

		public function get view():Sprite {return _container;}
		
		private const initPoiPos:Array = [
			new Point(100, 0),
			new Point(200, 0),
			new Point(300, 0),
			new Point(400, 0),
			new Point(500, 0),
			new Point(600, 0)
			];
		
		public function GameView()
		{
			super();
			
		}
		
		private var cnt:int = 0;
		
		/**
		 * clean
		 */
		public function clean():void
		{
			if (_container)
			{
				removeAllChild(_container);
				removeFromParent(_container);
				_container = null;
			}
			if (_fishLayer)
			{
				removeAllChild(_fishLayer);
				removeFromParent(_fishLayer);
				_fishLayer = null;
			}
			if (_fishControlPanel)
			{
				_fishControlPanel.clean();
				_fishControlPanel = null;
			}
			removeAllChild(this);
			removeFromParent(this);
		}
		
		/**
		 * 初期化
		 */
		public function initialize(idelegate:GameInternalDelegate):void
		{
			loadJson();
			
			
			_idelegate = idelegate;
			_container = new Sprite();
			addChild(_container);
			_background = new Bitmap(new kirakira());
			_container.addChild(_background);
			_poiLayer = new Sprite();
			_container.addChild(_poiLayer);
			
			
			// Boid初期設定
			var i:int;
			_boids = new Vector.<Boid>();
			_fishLayer = new Sprite();
			for (i = 0; i < NUMBOIDS; i++) 
			{
				// Boid設定
				var b:Boid = new Boid();
				const ph:Number = i * 2.0 * Math.PI / Number(NUMBOIDS);
				b.initialize( 
					Util.getRandom(0.0, 1600),
					Util.getRandom(0.0, 900),
					Util.getRandom(-1, 1),
					Util.getRandom(-1, 1),
					i,
					_idelegate
					);
				b.setFishCode('いまはなにも設定できない', 0.7);
				_fishLayer.addChild(b);
					
				_boids[i] = b;
			}
			_container.addChild(_fishLayer);
			
			// スライダー
			_fishControlPanel = new FishControlPanel();
			_container.addChild(_fishControlPanel);
			
			// PoiView初期設定
			_pois = new Vector.<PoiView>(POI_NUM, true);
			for (var j:int = 0, len:int = _pois.length; j < len; j++)
			{
				_pois[j] = new PoiView(_idelegate);
				_pois[j].initialize();
				_poiLayer.addChild(_pois[j]);
				// ダミーデータ
				var obj:Object ={
					t_id:"p1", 
					name:"なまえなまえ"
				};
				var data:PoiData = new PoiData(obj);
				_pois[j].show(data);
				_pois[j].x = initPoiPos[j].x;
				_pois[j].y = initPoiPos[j].y;
			}
			
			// アニメーション初期化
			_getMc1 = new Vector.<getMc1>(POI_NUM, true);
			_missMc1 = new Vector.<missMc1>(POI_NUM, true);
			_missMc2 = new Vector.<missMc2>(POI_NUM, true);
			_missMc3 = new Vector.<missMc3>(POI_NUM, true);
			_missMc4 = new Vector.<missMc4>(POI_NUM, true);
			for (var k:int = 0; k < POI_NUM; k++)
			{
				_getMc1[k] = new getMc1();
				_missMc1[k] = new missMc1();
				_missMc2[k] = new missMc2();
				_missMc3[k] = new missMc3();
				_missMc4[k] = new missMc4();
			}
			_waveMc_s = new Vector.<waveMc_s>();
			_waveMc_m = new Vector.<waveMc_m>();
			_waveMc_l = new Vector.<waveMc_l>();
			
			// 毎フレーム処理イベント設定
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 毎フレームイベントハンドラ
		 */
		public function onEnterFrame(ev:Event) : void 
		{ 
			// 毎フレーム関数
			updateBoids();
			for (var j:int = 0, len:int = _pois.length; j < len; j++)
			{
//				var obj:Object = {
//					xxx : _container.mouseX - _pois[j].width / 2.0,
//					yyy : _container.mouseY - 30.0,
//					data : {
//						t_id : 1,
//						doScoop : true
//					}
//				};
				//updatePoiPos(obj);
			}
		}
		
		public function updatePoiPos_debug(data:Object):void
		{
			var t_id:int = data.t_id - 1;
			
			var i:int;
			var b:Boid;
			for (i = 0; i < NUMBOIDS; i++) 
			{  
				b = _boids[i];
				var hit:Boolean = b.hitJudge(_pois[t_id].x + _pois[t_id].width / 2.0, _pois[t_id].y + 30);
				
				if (data.data.doScoop && hit)	// すくったときにヒットしてたら
				{
					//trace('すくった', i, b.fishData.code, b.fishData.name, b.fishData.type);
					deleteBoid(i);
					
					
					if (_scoreData.type1)
					{
						// ピチャピチャアニメ
						var waveGetMc:waveMc_get = new waveMc_get();
						waveGetMc.x = b.x;
						waveGetMc.y = b.y;
						waveGetMc.scaleX = waveGetMc.scaleY = 0.6;
						_container.addChild(waveGetMc);
						Executor.cancelByName('_getMc1' + t_id);
						Executor.executeAfterWithName( waveGetMc.totalFrames, 'waveMc_get' + t_id, onAnimationEnd, waveGetMc);
						// 魚捕獲アニメーション
						_getMc1[t_id].x = b.x;
						_getMc1[t_id].y = b.y;
						_getMc1[t_id].scaleX = _getMc1[t_id].scaleY = 0.5;
						_container.addChild(_getMc1[t_id]);
						_getMc1[t_id].gotoAndPlay(0);
						_getMc1[t_id].score.text.text = _scoreData[b.fishData.type].normal + '\r';
						Executor.cancelByName('_getMc1' + t_id);
						Executor.executeAfterWithName( _getMc1[t_id].totalFrames, '_getMc1' + t_id, onAnimationEnd, _getMc1[t_id]);
					}
					
					// 成功時
					if (_gotfishData.data.fishInfo)
					{
						
						cnt++;
						if (cnt > 5)
						{
							// 失敗時
							_pois[t_id].life = (_pois[t_id].life > 1) ? _pois[t_id].life - 1 : 0;
							if (_pois[t_id].life > 0)
							{
								_idelegate.sendLife({id:"game.life", data:{t_id:data.data.t_id , lastLife:_pois[t_id].life}});
								_pois[t_id].updateLife();
								// 失敗アニメーション
								_missMc3[t_id].x = _pois[t_id].x;
								_missMc3[t_id].y = _pois[t_id].y;
								_container.addChild(_missMc3[t_id]);
								_missMc3[t_id].gotoAndPlay(0);
								Executor.cancelByName('_missMc3' + t_id);
								Executor.executeAfterWithName( _missMc3[t_id].totalFrames, '_missMc3', onAnimationEnd, _missMc3[t_id]);
							}
						}
						else
						{
							// 成功時
							_gotfishData.data.t_id = data.data.t_id ;
							_gotfishData.data.fishInfo.size = "normal";
							_gotfishData.data.fishInfo.type = b.fishData.type;
							_gotfishData.data.fishInfo.score = _scoreData[b.fishData.type][_gotfishData.data.fishInfo.size];
							_idelegate.sendFish(_gotfishData);
						}
					}
				}
			}
			
			//			_pois[t_id].x += data.data.acg.x;
			//			_pois[t_id].y -= data.data.acg.y;
			
			_pois[t_id].x = data.xxx;
			_pois[t_id].y = data.yyy;
			if (_pois[t_id].x > _container.stage.stageWidth - _pois[t_id].width)
			{
				_pois[t_id].x = _container.stage.stageWidth - _pois[t_id].width;
			}
			else if (_pois[t_id].x < 0.0)
			{
				_pois[t_id].x = 0.0;
			}
			if (_pois[t_id].y > _container.stage.stageHeight - _pois[t_id].height / 2.0)
			{
				_pois[t_id].y = _container.stage.stageHeight - _pois[t_id].height / 2.0;
			}
			else if (_pois[t_id].y < 0.0)
			{
				_pois[t_id].y = 0.0;
			}
		}
		
		/**
		 * ポイを動かす
		 * @param data
		 */
		public function updatePoiPos(data:Object):void
		{
			var t_id:int = data.t_id - 1;
			var i:int;
			var b:Boid;
			var hit:Boolean = false;
			var distPoi:Number = 1000000000.0;
			for (i = 0; i < NUMBOIDS; i++) 
			{  
				b = _boids[i];
				var __hit:Boolean = b.hitJudge(_pois[t_id].x + _pois[t_id].width / 2.0, _pois[t_id].y + 30);
				if (__hit)
				{
					hit = true;
				}
				if (distPoi > b.distPoi)
				{
					distPoi = b.distPoi;
				}
				if (data.data.doScoop && __hit)	// すくったときにヒットしてたら
				{
					deleteBoid(i);
					// 成功時
					if (_gotfishData.data.fishInfo)
					{
						// 成功時
						_gotfishData.data.t_id = data.t_id ;
						_gotfishData.data.fishInfo.size = "normal";
						_gotfishData.data.fishInfo.type = b.fishData.type;
						_gotfishData.data.fishInfo.score = _scoreData[b.fishData.type][_gotfishData.data.fishInfo.size];
						_idelegate.sendFish(_gotfishData);
					}
					
					if (_scoreData.type1)
					{
						// ピチャピチャアニメ
						var waveGetMc:waveMc_get = new waveMc_get();
						waveGetMc.x = b.x;
						waveGetMc.y = b.y;
						_container.addChild(waveGetMc);
						// 魚捕獲アニメーション
						_getMc1[t_id].x = b.x;
						_getMc1[t_id].y = b.y;
						_getMc1[t_id].scaleX = _getMc1[t_id].scaleY = 0.5;
						_container.addChild(_getMc1[t_id]);
						_getMc1[t_id].gotoAndPlay(0);
						_getMc1[t_id].score.text.text = _scoreData[b.fishData.type].normal + '\r';
						Executor.cancelByName('_getMc1' + t_id);
						Executor.executeAfterWithName( _getMc1[t_id].totalFrames, '_getMc1' + t_id, onAnimationEnd, _getMc1[t_id]);
					}
				}
//				else if (data.data.doScoop && !hit)	// すくったときにヒットしてなかったら
//				{
//					trace('data.data.doShake', data.data.doShake);
//					trace('data.data.doScoop', data.data.doScoop);
//					// 失敗時
//					_pois[t_id].life = (_pois[t_id].life > 1) ? _pois[t_id].life - 1 : 0;
//					_idelegate.sendLife({id:"game.life", data:{t_id:data.t_id , lastLife:_pois[t_id].life}});
//					_pois[t_id].updateLife();
//					// 失敗アニメーション
//					_missMc3[t_id].x = _pois[t_id].x;
//					_missMc3[t_id].y = _pois[t_id].y;
//					_container.addChild(_missMc3[t_id]);
//					_missMc3[t_id].gotoAndPlay(0);
//					Executor.cancelByName('_missMc3' + t_id);
//					Executor.executeAfterWithName( _missMc3[t_id].totalFrames, '_missMc3', onAnimationEnd, _missMc3[t_id]);
//				}
			}
			trace('distPoi', distPoi);
			if (data.data.doScoop && !hit && distPoi < 100000)	// ヒットしてなくて一番近い魚の距離が○◯未満なら
			{
				// 失敗時
				_pois[t_id].life = _pois[t_id].life - 1;
				if (_pois[t_id].life > -1)
				{
					_idelegate.sendLife({id:"game.life", data:{t_id:data.t_id , lastLife:_pois[t_id].life}});
				}
				_pois[t_id].updateLife();
				// 失敗アニメーション
				_missMc3[t_id].x = _pois[t_id].x;
				_missMc3[t_id].y = _pois[t_id].y;
				_container.addChild(_missMc3[t_id]);
				_missMc3[t_id].gotoAndPlay(0);
				Executor.cancelByName('_missMc3' + t_id);
				Executor.executeAfterWithName( _missMc3[t_id].totalFrames, '_missMc3', onAnimationEnd, _missMc3[t_id]);
			}
			
			_pois[t_id].x += data.data.acg.x;
			_pois[t_id].y -= data.data.acg.y;
			if (_pois[t_id].x > _container.stage.stageWidth - _pois[t_id].width)
			{
				_pois[t_id].x = _container.stage.stageWidth - _pois[t_id].width;
			}
			else if (_pois[t_id].x < 0.0)
			{
				_pois[t_id].x = 0.0;
			}
			if (_pois[t_id].y > _container.stage.stageHeight - _pois[t_id].height / 2.0)
			{
				_pois[t_id].y = _container.stage.stageHeight - _pois[t_id].height / 2.0;
			}
			else if (_pois[t_id].y < 0.0)
			{
				_pois[t_id].y = 0.0;
			}
		}
		
		/**
		 *アニメーション終了ハンドラ 
		 * @param mc
		 */		
		private function onAnimationEnd(mc:MovieClip):void
		{
			removeFromParent(mc);
		}
		
		/**
		 *アニメーション終了後に消去する 
		 * @param mc
		 */		
		private function onAnimationEndAndDelete(mc:MovieClip):void
		{
			removeFromParent(mc);
			mc = null;
		}
		
		/**
		 * 波紋を出す
		 * @param x : 座標
		 * @param y : 座標
		 * @param size : サイズ('small', 'medium', 'large')
		 * @return 
		 */
		public function createWave(px:Number, py:Number, size:String):void 
		{
			var wave:MovieClip;
			switch(size)
			{
				case 'small':
					wave = new waveMc_s();
					break;
				case 'medium':
					wave = new waveMc_m();
					break;
				case 'large':
					wave = new waveMc_l();
					break;
				default:
					break;
			}
			wave.x = px;
			wave.y = py;
			wave.gotoAndPlay(0);
			_container.addChild(wave);
			Executor.executeAfterWithName(wave.totalFrames, 'waveMc', onAnimationEndAndDelete, wave);
		}
		
		/**
		 * 魚の毎フレーム関数
		 */
		public function updateBoids() : void 
		{
			var b:Boid;
			var i:int;
			for (i = 0; i < NUMBOIDS; i++) 
			{
				b = _boids[i];  
				b.force(_boids, i, _pois);
				b.update(i);
			}  
			/*
			for (i = 0; i < NUMBOIDS; i++) 
			{             
				b = _boids[i];
				b.update(i);
			}*/
		}
		
		/**
		 * 魚を消す
		 */
		private function deleteBoid(index:int):void
		{
//			_boids[index].initialize( 
//				0.0,
//				0.0,
//				Util.getRandom(-1, 1),
//				Util.getRandom(-1, 1),
//				index,
//				_idelegate
//			);
			_boids[index].catchedAnimation();
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
	}
}