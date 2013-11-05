package fish.collection.game.view
{
	import com.greensock.easing.Back;
	
	import fish.collection.fish.FishView;
	import fish.collection.fish.data.FishData;
	import fish.collection.game.GameInternalDelegate;
	import fish.collection.game.poi.PoiView;
	import fish.collection.game.util.Util;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	
	import pigglife.util.Executor;
	import pigglife.util.Tween;

	/**
	 * タスク
	 * 
	 * マウスから逃げていく
	 * マウスクリックで捕まえる(消える)
	 */
	public class Boid extends Sprite
	{
		// 
		private var _idelegate:GameInternalDelegate;
		// Boidの領域
		public var BOUNDING_WIDTH:int = 900;
		public var BOUNDING_HEIGHT:int = 600;
		//　境界の範囲
		private const BOUNDARY:Number = 150.0;
		
		// 座標
		private var _px:Number, _py:Number;
		// 速度
		private var _vx:Number, _vy:Number;
		private var _vxSmooth:Number, _vySmooth:Number;
		private var _vxSpring:Number, _vySpring:Number;
		
		// 加速度
		private var _ax:Number, _ay:Number;
		
		// ムービークリップ
		private var _fishView:FishView;
		
		// しっぽの回転
		private var _tailRot:Vector.<Number>;
		private const TAIL_BUF:uint = 10;
		
		// 魚データ
		private var _fishData:FishData;
		
		// 捕獲フラグ
		private var _isCatched:Boolean;
		// index
		private var _index:int;
		
		// ポイとの距離
		private var _distPoi:Number;
		
		// sound
		private var _dropSound:Sound;
		
		private var _temp:Boolean = false;;
		
		/**
		 * コンストラクタ
		 */
		public function Boid() 
		{
			super();
			initSound();
		}
		
		public function get isCatched():Boolean
		{
			return _isCatched;
		}

		public function get distPoi():Number
		{
			return _distPoi;
		}

		public function get fishData():FishData
		{
			return _fishData;
		}
		
		public function getFishBodyPos():Point
		{
			var point:Point = new Point(_fishView.body.x, _fishView.body.y);
			return point;
		}

		/**
		 * 初期化
		 * @param  : 
		 * @return 
		 */
		public function initialize(px:Number, py:Number, vx:Number, vy:Number, index:int, idelegate:GameInternalDelegate):void 
		{
			_idelegate = idelegate;
			_px = Number(px);
			_py = Number(py);
			_vx = Number(vx);
			_vy = Number(vy);
			_ax = 0.0;
			_ay = 0.0;
			_vxSmooth = Number(vx);
			_vySmooth = Number(vy);
			_vxSpring = Number(vx);
			_vySpring = Number(vy);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_index = index;
			
			_tailRot = new Vector.<Number>(TAIL_BUF, true);
			for (var i:int = 0, len:int = _tailRot.length; i < TAIL_BUF; i++)
			{
				_tailRot[i] = 0.0;
			}
			// 捕獲フラグ
			_isCatched = false;
			_distPoi = 0.0;
		}
		
		private function initSound():void
		{
			//サウンドの読み込み
			var rand:int = int(Math.random() * 13) + 1;
			switch (rand)
			{
				case 1:
					_dropSound = new drop_1();
					break;
				case 2:
					_dropSound = new drop_2();
					break;
				case 3:
					_dropSound = new drop_3();
					break;
				case 4:
					_dropSound = new drop_4();
					break;
				case 5:
					_dropSound = new drop_5();
					break;
				case 6:
					_dropSound = new drop_6();
					break;
				case 7:
					_dropSound = new drop_7();
					break;
				case 8:
					_dropSound = new drop_8();
					break;
				case 9:
					_dropSound = new drop_9();
					break;
				case 10:
					_dropSound = new drop_10();
					break;
				case 11:
					_dropSound = new drop_11();
					break;
				case 12:
					_dropSound = new drop_12();
					break;
				case 13:
					_dropSound = new drop_13();
					break;
				default:
					_dropSound = new drop_1();
					break;
			}
		}
			
		/**
		 * ステージ配置イベントリスナ
		 */
		protected function onAddedToStage(event:Event):void
		{
			BOUNDING_WIDTH = stage.stageWidth;
			BOUNDING_HEIGHT = stage.stageHeight;
			trace('境界', BOUNDING_WIDTH, BOUNDING_HEIGHT);
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		/**
		 * 魚の種類を決定
		 * @param fishCode : 魚のコード
		 * @return 
		 */
		public function setFishCode():void 
		{
			// 出現させる魚の設定
			var random:int = Math.random() * 100;
			var type:int = 1;
			if (1 <= random && random < 50)
				type = 1;
			else if (50 <= random && random < 70)
				type = 2;
			else if (70 <= random && random < 80)
				type = 3;
			else if (80 <= random && random < 90)
				type = 4;
			else if (90 <= random && random < 95)
				type = 5;
			else if (95 <= random)
				type = 6;
			
			
			var typeStr:String = 'type' + type;
			var obj:Object = {
				code:"fish1", 
				name:"テスト",
				type:typeStr
			};
			_fishData = new FishData(obj);
		}
		
		/**
		 * 魚の外観を設定 
		 * @param colorVariationID
		 * 
		 */		
		public function setFishView(colorVariationID:int):void
		{
			if (!_fishView)
			{
				_fishView = new FishView();
			}
			else
			{
				_fishView.clean();
				_fishView = null;
				_fishView = new FishView();
			}
			_fishView.initialize(_fishData);
			_fishView.show(colorVariationID);
			// ドロップシャドウ
			var drop_filter:DropShadowFilter = new DropShadowFilter();
			drop_filter.distance = 20.0;
			drop_filter.alpha = 0.2;
			drop_filter.blurX = 10.0;
			drop_filter.blurY = 10.0;
			_fishView.filters = [drop_filter];
			addChild(_fishView);
		}
		
		
		/**
		 * 魚との距離を取得する 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public function getDist(x:Number, y:Number):Number
		{
			var dx:Number = (x - _px);
			var dy:Number = (y - _py);
			var d:Number = Math.sqrt(dx * dx + dy * dy);
			return d;
		}
		
		/**
		 * 魚の捕獲アニメーション 
		 * 
		 */		
		public function catchedAnimation():void
		{
			// 捕獲フラグをONにする
			_isCatched = true;
			Tween.applyTo(_fishView, 2.0, {alpha:0, scaleX:0.0, scaleY:0.0, ease:Back.easeOut,onComplete: onCatchedAnimationEnd});
			// サウンドを再生する(ランダムで時間差つける)
			//Executor.executeAfter(int(Math.random()*10), playSound);
			Executor.executeAfterWithName(int(Math.random()*10), 'dropSound' + String(_index), playSound);
		}
		/**
		 * サウンドを再生させる 
		 * 
		 */		
		private function playSound():void
		{
			_dropSound.play(0.0, 1);
			Executor.cancelByName('dropSound' + String(_index));
		}
		/**
		 * 捕獲アニメーション終了フラグ 
		 * 
		 */		
		private function onCatchedAnimationEnd():void
		{
			trace('捕獲アニメーション終了');
			var rand:int = Math.random() * 4;
			var initSpeedMax:Number = 1000.0;
			switch (rand)
			{
				case 0:
					initialize( 
						BOUNDING_WIDTH * 0,
						BOUNDING_HEIGHT * 0,
						Util.getRandom(0, initSpeedMax),
						Util.getRandom(0, initSpeedMax),
						_index,
						_idelegate
					);
					break;
				case 1:
					initialize( 
						BOUNDING_WIDTH * 1,
						BOUNDING_HEIGHT * 0,
						Util.getRandom(-initSpeedMax, 0),
						Util.getRandom(0, initSpeedMax),
						_index,
						_idelegate
					);
					break;
				case 2:
					initialize( 
						BOUNDING_WIDTH * 1,
						BOUNDING_HEIGHT * 1,
						Util.getRandom(-initSpeedMax, 0),
						Util.getRandom(-initSpeedMax, 0),
						_index,
						_idelegate
					);
					break;
				case 3:
					initialize( 
						BOUNDING_WIDTH * 0,
						BOUNDING_HEIGHT * 1,
						Util.getRandom(0, -initSpeedMax),
						Util.getRandom(-initSpeedMax, 0),
						_index,
						_idelegate
					);
					break;
				default:
					initialize( 
						BOUNDING_WIDTH * 0,
						BOUNDING_HEIGHT * 0,
						Util.getRandom(0, initSpeedMax),
						Util.getRandom(0, initSpeedMax),
						_index,
						_idelegate
					);
					break;
			}
			Tween.applyTo(_fishView, 2.0, {alpha:1.0, scaleX:1.0, scaleY:1.0, ease:Back.easeOut});
		}
		/**
		 * 魚との当たり判定
		 */
		public function hitJudge(x:Number, y:Number):Boolean
		{
			if (_isCatched)	// 捕獲フラグONのときはヒットしない
				return false;
			else
				return _fishView.hitTestPoint(x, y, true);
		}
		
		/**
		 * 他のBoidからの影響
		 */
		public function force(boids:Vector.<Boid>, index:int, pois:Vector.<PoiView>) : void 
		{
			// 一番近いBoidを探す
			var nearlest:Boid = null;
			// 距離
			var dx:Number = 0.0;
			var dy:Number = 0.0;
			var dist2:Number = 0.0;	// 距離の自乗
			// 最短距離を保持する
			var mindist2:Number = Number.MAX_VALUE;
			// index用
			var i:String;
			// 探す用Boidインスタンス
			var b:Boid;
			var count:int = 0;
			var cx:Number = 0.0
			var cy:Number = 0.0;
			for (i in boids) 
			{
				// Boidを指定
				b = boids[i];
				if (b == this)	// 自分自身なら次に飛ぶ
					continue;
				// 指定したBoidまでの距離を算出
				dx = b._px - _px; 
				dy = b._py - _py;
				dist2 = dx * dx + dy * dy;
				// 最短距離より小さい場合
				if (dist2 < mindist2) 
				{
					mindist2 = dist2;
					// 直近のBoidを更新
					nearlest = b;
				}
				// 指定したBoidまでの距離が1500未満の場合
				if (dist2 < 1500.0)
				{
					cx += b._px;
					cy += b._py;
					count++;
				}
				if (x == 0 || y == 0)
				{
					trace('動いていない', i, index, x, y, _px, _py, _vx, _vy, _ax, _ay, _temp, dist2, dx * dx + dy * dy, mindist2, b._px, b._py, count);
				}
			}
			
			
			
			_ax = _ay = 0.0;
			_temp = true;
			// 直近のBoidがいなければ抜ける
			if (nearlest == null)
				return;
			
			
			// 直近のBoidの情報を保持
			var npx:Number = nearlest._px;
			var npy:Number = nearlest._py;
			var nvx:Number = nearlest._vx;
			var nvy:Number = nearlest._vy;
			dx = (npx - _px);
			dy = (npy - _py);
			dist2 = dx * dx + dy * dy;
			// 直近のBoidからの距離が遠すぎれば抜ける
//			if (dist2 > 20000000)
//				return;
			
			
			var date:Date = new Date();
			var sinVal:Number = Math.cos(date.getTime() * Util.getRandom(0.0001, 0.001)) * 0.3;
			// Separation(分離)
			var dist:Number = Math.sqrt(dist2);
			if (dist > 0)
			{
				var separation:Number = FishControlData.params[_fishData.type].SEPARATION + sinVal;
				_ax += dx / dist * (dist - 60.0) * separation;
				_ay += dy / dist * (dist - 60.0) * separation;
			}
			
			// Alignment(整列)
			var alignment:Number = FishControlData.params[_fishData.type].ALIGNMENT + sinVal;
			_ax += (nvx - _vx) * alignment; 
			_ay += (nvy - _vy) * alignment;
			
			if (count > 0)
			{
				// Cohesion(結合)
				dx = (cx / Number(count) - _px); 
				dy = (cy / Number(count) - _py);
				var cohesion:Number = FishControlData.params[_fishData.type].COHESION + sinVal;
				_ax += dx * cohesion; 
				_ay += dy * cohesion;
				_ax += 3.0 * (Math.random() - 0.5);
				_ay += 3.0 * (Math.random() - 0.5);
			}
			
			// ポイが近ければ逃げていく
			for (var j:int = 0, len:int = pois.length; j < len; j++)
			{
				dx = dy = .0;
				dx = (pois[j].x - _px);
				dy = (pois[j].y - _py);
				_distPoi = Math.sqrt(dx * dx + dy * dy);
				if (_distPoi > Util.getRandom(50.0, 100.0))
				{
					continue;
				}
				if (dist > 0)
				{
					_ax += dx / dist * (dist - Util.getRandom(400, 1000)) * Util.getRandom(0.7, 1.7);
					_ay += dy / dist * (dist - Util.getRandom(500, 1200)) * Util.getRandom(0.7, 1.7);
				}
			}
			
			// boundary(境界)
			if (_px < BOUNDARY)
			{
				_ax += (BOUNDARY - _px) * 0.3;
			}
			else if (_px > BOUNDING_WIDTH - BOUNDARY)
			{
				_ax += (BOUNDING_WIDTH - BOUNDARY - _px) * 0.3;
			}
			if (_py < BOUNDARY)
			{
				_ay += (BOUNDARY - _py) * 0.3;
			}
			else if (_py > BOUNDING_HEIGHT - BOUNDARY)
			{
				_ay += (BOUNDING_HEIGHT - BOUNDARY - _py) * 0.3;
			}
		}
		
		/**
		 * 自身の更新関数
		 */
		public function update(index:int) : void
		{
			var date:Date = new Date();
			var sinVal:Number = FishControlData.params[_fishData.type].SIN_VALUE * Math.sin(date.getTime() * Util.getRandom(0.00001, 0.0001));
			var speedDecay:Number = FishControlData.params[_fishData.type].SPEED_DECAY + sinVal;

			_px += _vx * (1.0 / speedDecay); 
			_py += _vy * (1.0 / speedDecay);
			_vx += _ax * (1.0 / speedDecay); 
			_vy += _ay * (1.0 / speedDecay);
			
			// speed limit
			var v:Number = Math.sqrt(_vx * _vx + _vy * _vy);
			if (v > 50.0) 
			{
				_vx = _vx / v * 50.0;
				_vy = _vy / v * 50.0;
			} 
			else if (v < 8.0) 
			{
				_vx = _vx / v * 8.0;
				_vy = _vy / v * 8.0;
			}
			
			
			// 回転の更新
			var nextRotVal:Number = Math.atan2(_vy, _vx) * 180.0 / Math.PI + 90.0;
			var currentRotVal:Number = this.rotation;
			
			// 現在の回転地との差(右回転:正 左回転:負)
			var rotMargin:Number = (currentRotVal+360) - (nextRotVal+360);
			
			_fishView.body.rotation = nextRotVal;
			_fishView.rFin.rotation = nextRotVal;
			_fishView.lFin.rotation = nextRotVal;
			_fishView.head.rotation = nextRotVal;
			
			
			_fishView.tail.x = Util.smoothMoveFunc(_fishView.tail.x, - _fishView.tailDist * Math.sin(nextRotVal * Math.PI / 180.0), 0.5);
			_fishView.tail.y = Util.smoothMoveFunc(_fishView.tail.y,   _fishView.tailDist * Math.cos(nextRotVal * Math.PI / 180.0), 0.5);

			var length:int = _tailRot.length;
			var hanten:Number = Math.abs(_tailRot[0] - _tailRot[length - 1]);
			if (hanten > 180)// 反転した時
			{
				// 波紋アニメーション入れる
				var size:String = '';
				if (hanten > 330 && hanten < 340)
				{
					size = 'medium';
				}
				else if(hanten > 320 && hanten <= 330)
				{
					size = 'small';
				}
				//trace(size, hanten);
				if (size != '')
					_idelegate.createWave(this.x, this.y, size);
				// 反転でしっぽが破綻しないようにさせる
				while(Math.abs(_tailRot[0] - _tailRot[length - 1]) > 200)
				{
					updateRotation();
				}
			}
			// 最新を更新
			_tailRot[0] = nextRotVal;
			// 回転値を更新する
			_fishView.tail.rotation = _tailRot[_tailRot.length - 1];
			
			updateRotation();
			
			// 座標更新
			x = _px;
			y = _py;
		
		}
		
		/**
		 * 回転値を更新する
		 */
		private function updateRotation():void
		{
			for (var i:int = _tailRot.length -1; i > 0; i--)
			{
				_tailRot[i] = _tailRot[i-1];
			}
		}
	}
	
	/*-------------------------------------------
	サウンド
	-------------------------------------------*/
	drop_1;
	drop_2;
	drop_3;
	drop_4;
	drop_5;
	drop_6;
	drop_7;
	drop_8;
	drop_9;
	drop_11;
	drop_12;
	drop_13;
}










