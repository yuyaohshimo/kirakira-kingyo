package fish.collection.game
{
	import adobe.utils.CustomActions;
	
	import fish.collection.game.poi.PoiView;
	import fish.collection.game.poi.data.PoiData;
	import fish.collection.game.util.CustumEvent;
	import fish.collection.game.util.Util;
	import fish.collection.game.view.Boid;
	import fish.collection.game.view.FishControlData;
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
		// ポイの大きさからの差
		private const HIT_DIST_VALUE:Number = 0.5;
		private const MISS_DIST_VALUE:Number = 1.0;	
		
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
		
		
		private var _scoop:Boolean;

		public function get view():Sprite {return _container;}
		
		
		
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
		public function initialize(idelegate:GameInternalDelegate, startData:Object):void
		{
			_scoop = false;
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
				b.setFishCode();
				_fishLayer.addChild(b);
					
				_boids[i] = b;
			}
			_container.addChild(_fishLayer);
			
			// スライダー
//			_fishControlPanel = new FishControlPanel();
//			_container.addChild(_fishControlPanel);
			
			// PoiView初期設定
			_pois = new Vector.<PoiView>(POI_NUM, true);
			trace('ゲームスタートデータ', startData);
			
			for (var j:int = 0, len:int = _pois.length; j < len; j++)
			{
				_pois[j] = new PoiView(_idelegate);
				_pois[j].initialize();
				_poiLayer.addChild(_pois[j]);
				// ダミーデータ
				var obj:Object ={
					data: {
						t_id:"1", 
						name:"なまえなまえ"
					}
				};
				/*-------------------------------------------
				デバッグ用
				-------------------------------------------*/
				var data:PoiData = new PoiData(startData);
				//var data:PoiData = new PoiData(obj);
				_pois[j].show(data);
				_pois[j].x = FishControlData.initPoiPos[j].x;
				_pois[j].y = FishControlData.initPoiPos[j].y;
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
			/*-------------------------------------------
			ここはデバッグ用
			-------------------------------------------*/
//			_container.mouseChildren = true;
//			_container.mouseEnabled = true;
//			_container.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//
//			var obj:Object = {
//				data : {
//					t_id : 1,
//					doScoop : _scoop,
//					acg: {
//						x : _container.mouseX,
//						y : _container.mouseY
////						x : Util.map(_container.mouseX, 0.0, 800.0, -5.0, 5.0),
////						y : -Util.map(_container.mouseY, 0.0, 800.0, -5.0, 5.0)
//					}
//				}
//			};
//			
//			if (_pois[obj.data.t_id-1].life <= 0)
//				stopPoi(obj);
//			else
//				updatePoiPos(obj);
//			_scoop = false; 
			/*-------------------------------------------
			ここまでデバッグ用コード
			GameModelのupdatePoiPosをコメント解除するの忘れないように
			-------------------------------------------*/
		}
		private function onMouseUp(e:Event):void
		{
			_scoop = true;
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
			// もっとも近い魚との距離
			var distPoiMin:Number = 1000000000.0;
			if (data.data.doScoop)
			{
				// すくうアニメーション入れる
				_pois[t_id].scoopAnimation();
			}
			/*-------------------------------------------
			ポイの更新			
			-------------------------------------------*/
			for (i = 0; i < NUMBOIDS; i++) 
			{  
				b = _boids[i];
				
				// 魚とポイの距離
				var boidDist:Number = b.getDist(_pois[t_id].getPosX(), _pois[t_id].getPosY());
				if (distPoiMin > boidDist)
				{
					// もっとも近い魚との距離を算出
					distPoiMin = boidDist;
				}
				
				/*-------------------------------------------
				当たり判定
				-------------------------------------------*/
				//var __hit:Boolean = b.hitJudge(_pois[t_id].x + _pois[t_id].width / 2.0, _pois[t_id].y + 30);
				var __hit:Boolean = false;
				if (boidDist < _pois[t_id].getPoiSize() * HIT_DIST_VALUE)	// 魚とポイの距離でヒット判定
					__hit = true; 
				if (__hit)	// 一匹はヒットした魚がいる状態
					hit = true;
				
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
						Executor.executeAfterWithName(waveGetMc.totalFrames, 'waveMc_get' + t_id, onAnimationEnd, waveGetMc);
						// 魚捕獲アニメーション
						var getMc:getMc1 = new getMc1();
						getMc.x = b.x;
						getMc.y = b.y;
						getMc.scaleX = getMc.scaleY = 0.5;
						_container.addChild(getMc);
						getMc.gotoAndPlay(0);
						getMc.score.text.text = _scoreData[b.fishData.type].normal + '\r';
						Executor.executeAfterWithName( getMc.totalFrames, 'getMc' + t_id, onAnimationEnd, getMc);
					}
				}
			}
			/*-------------------------------------------
			ミス処理
			-------------------------------------------*/
			if (data.data.doScoop && !hit && distPoiMin < _pois[t_id].getPoiSize() * MISS_DIST_VALUE)	// ヒットしてなくて一番近い魚の距離が○◯未満なら
			{
				trace('distPoi', distPoiMin);
				// 失敗時
				_pois[t_id].life--;
				_pois[t_id].updateLife();
				// ポイの失敗アニメーション
				_pois[t_id].missAnimation();
				// 失敗アニメーション
				var missMc:missMc3 = new missMc3();
				missMc.x = _pois[t_id].getPosX();
				missMc.y = _pois[t_id].getPosY();
				_container.addChild(missMc);
				missMc.gotoAndPlay(0);
				Executor.executeAfterWithName( missMc.totalFrames, '_missMc3', onAnimationEnd, missMc);
				
//				_missMc3[t_id].x = _pois[t_id].getPosX();
//				_missMc3[t_id].y = _pois[t_id].getPosY();
//				_container.addChild(_missMc3[t_id]);
//				_missMc3[t_id].gotoAndPlay(0);
//				Executor.cancelByName('_missMc3' + t_id);
//				Executor.executeAfterWithName( _missMc3[t_id].totalFrames, '_missMc3', onAnimationEnd, _missMc3[t_id]);
				
				// ポイのライフ情報送信
				if (_pois[t_id].life > -1)
				{
					_idelegate.sendLife({id:"game.life", data:{t_id:data.t_id , lastLife:_pois[t_id].life}});
				}
			}
			/*-------------------------------------------
			本番はここをコメント解除
			-------------------------------------------*/
//			_pois[t_id].setPosX(_pois[t_id].getPosX() + data.data.acg.x);
//			_pois[t_id].setPosY(_pois[t_id].getPosY() - data.data.acg.y);
			_pois[t_id].x += data.data.acg.x;
			_pois[t_id].y -= data.data.acg.y;
			
//			_pois[t_id].setPosX(data.data.acg.x);
//			_pois[t_id].setPosY(data.data.acg.y);
//			_pois[t_id].rotatePoi(data.data.acg.y);
			
			if (_pois[t_id].x > _container.stage.stageWidth)
			{
				_pois[t_id].x = _container.stage.stageWidth;
			}
			else if (_pois[t_id].x < 0.0)
			{
				_pois[t_id].x = 0.0;
			}
			if (_pois[t_id].y > _container.stage.stageHeight)
			{
				_pois[t_id].y = _container.stage.stageHeight;
			}
			else if (_pois[t_id].y < 0.0)
			{
				_pois[t_id].y = 0.0;
			}
		}
		
		/**
		 *ポイ回転初期化 
		 * @param rotData
		 * 
		 */		
		public function initPoiRot(rotData:Object = null):void
		{
			var t_id:int = rotData.t_id - 1;
			var rot:Number = rotData.data.alpha;
			_pois[t_id].initRotatePoi(rot);
		}
		/**
		 *ポイ回転
		 * @param rotData
		 * 
		 */		
		public function setPoiRot(rotData:Object = null):void
		{
			var t_id:int = rotData.t_id - 1;
			var rot:Number = rotData.data.alpha;
			_pois[t_id].rotatePoi(rot);
		}
		
		/**
		 * ぽいを止める 
		 * @param data
		 * 
		 */		
		public function stopPoi(data:Object):void
		{
			var t_id:int = data.t_id - 1;
			// poiViewのライフが0なら終了 0より大きければゲーム中断
			if (_pois[t_id].life <= 0)
			{
				// ゲーム終了
				// ポイの終了アニメーション　→　アニメーション終了したら消える
				//_pois[t_id].missAnimation();
			}
			else
			{
				// ゲーム中断
			}
		}
		
		/**
		 *アニメーション終了ハンドラ 
		 * @param mc
		 */		
		private function onAnimationEnd(mc:MovieClip):void
		{
			removeFromParent(mc);
			mc = null;
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