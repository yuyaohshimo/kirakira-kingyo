package fish.collection.game.poi
{
	import com.greensock.easing.Back;
	
	import fish.collection.game.GameInternalDelegate;
	import fish.collection.game.poi.configuration.PoiConfiguration;
	import fish.collection.game.poi.data.PoiData;
	import fish.collection.game.util.Util;
	import fish.collection.game.view.FishControlData;
	import fish.collection.json.ExternalConfig;
	
	import flash.debugger.enterDebugger;
	import flash.display.Sprite;
	import flash.geom.Orientation3D;
	import flash.text.TextField;
	
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
		private var _poiData:PoiData;
		private var _scoreData:Object;
		private var _gotfishData:Object;
		private var _userName:TextField;
		private var _userLife:Sprite;
		private var _life:int;
		private var _poiMc:PoiMc;
		private var _initRot:Number;
		private var _nowRot:Number;
		private var _onGame:Boolean;
		private var _rotSmooth:Boolean;
		private var _isTutorial:Boolean;
//		private var tf:TextField;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================

		public function set isTutorial(value:Boolean):void
		{
			_isTutorial = value;
		}

		public function get isTutorial():Boolean
		{
			return _isTutorial;
		}

		public function get rotSmooth():Boolean
		{
			return _rotSmooth;
		}

		public function set rotSmooth(value:Boolean):void
		{
			_rotSmooth = value;
		}

		public function get onGame():Boolean
		{
			return _onGame;
		}
		public function set life(value:int):void
		{
			_life = value;
		}
		public function get life():int
		{
			return _life;
		}
		public function getPoiSize():Number
		{
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
		public function initialize(id:int):void
		{
			// ポイ残数初期化
			_life = PoiConfiguration.MAX_LIFE;
			// 初期回転を保存
			_initRot = 0.0;
			_nowRot = 0.0;
			_rotSmooth = false;
			// ポイ本体の表示
			_poiMc = new PoiMc();
			// ぽいを元に戻す
			_poiMc.gotoAndStop('start');
			_poiMc.poiInner.gotoAndStop("t_id" + id);
			_poiMc.poiInner_miss.gotoAndStop("t_id" + id);
			
			this.addChild(_poiMc);
			hidePoi();
			
			// デバッグ用テキストフィールド
//			tf = new TextField();
//			tf.scaleX = 1.5;
//			tf.scaleY = 1.5;
//			this.addChild(tf);
		}
		
		/**
		 * ポイを表示 
		 */
		public function show(data:PoiData):void
		{
			// ポイデータ
			_poiData = data;
			showPoi();
			// ユーザー名
			createName();
			// ポイの残数
			updateLife();
			// ぽいを元に戻す
			_poiMc.poiInner.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.gotoAndPlay('start');
			
			// チュートリアルモードつかうかどうか
			_isTutorial = ExternalConfig.IS_USE_TUTORIAL;
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			removeAllChild(this);
			_poiMc = null;
		}
		
		/**
		 * ポイの位置更新 
		 * @param __x
		 * @param __y
		 * 
		 */		
		public function updatePoiPos(__x:Number, __y:Number):void
		{
			//_poiMc.poiInner.rotationY = Util.smoothMoveFunc(_poiMc.poiInner.rotationY, - __x * 4, 0.2);
			
			// 回転を考慮した位置更新（バイオハザード方式）
			var nowRotation:Number = this.rotationZ;
			var dist:Number = Math.sqrt(__x * __x + __y * __y);
			var angle:Number = Math.atan2(__y, __x);
			
//			this.x = 800;
//			this.y = 450;
			this.x += dist * Math.cos(angle + nowRotation * Math.PI / 180.0);
			this.y += dist * Math.sin(angle + nowRotation * Math.PI / 180.0);
		}
		
		/**
		 *　ポイの死亡アニメーション 
		 * 
		 */		
		public function missAnimation():void
		{
			// ポイが敗れる
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.gotoAndPlay('miss');
			// ミスアニメーション
//			Tween.applyTo(this, 2.0, {alpha: 0.1, scaleX: 0.2, scaleY: 0.2, ease:Back.easeOut, onComplete: onMissAnimationEnd});
			Executor.executeAfterWithName(16, "poiMiss" + _poiData.t_id, onMissAnimationEnd);
			
		}
		
		/**
		 * ゲームオーバーアニメーション 
		 * 
		 */		
		public function gameOverAnimation():void
		{	
			// ポイが敗れる
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.gotoAndPlay('gameOver');
			// ミスアニメーション
//			Tween.applyTo(this, 2.0, {alpha: 0.1, scaleX: 0.2, scaleY: 0.2, ease:Back.easeOut, onComplete: onMissAnimationEnd});
			Executor.executeAfterWithName(16, "poiMiss" + _poiData.t_id, onMissAnimationEnd);
		}
		
		/**
		 * ポイの死亡アニメーション終了ハンドラ 
		 * 
		 */		
		private function onMissAnimationEnd():void
		{
			if (_life <= 0)
			{
				// もろもろ戻す
				this.alpha = 1.0;
				this.scaleX = 1.0;
				this.scaleY = 1.0;
				// ライフ元に戻す
				_life = PoiConfiguration.MAX_LIFE;;
				// ポイを非表示にする
				hidePoi();
				// ポイの回転初期値を戻す
				_initRot = 0.0;
				// ゲームを終了
				_onGame = false;
			}
			else
			{
				this.alpha = 1.0;
				this.scaleX = 1.0;
				this.scaleY = 1.0;
			}
			// ぽいを元に戻す
			Executor.cancelByName("poiMiss" + _poiData.t_id);
			_poiMc.poiInner.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.gotoAndPlay('start');
		}
		
		/**
		 * ポイをリセットする 
		 * 
		 */		
		public function resetPoi():void
		{
			// もろもろ戻す
			this.alpha = 1.0;
			this.scaleX = 1.0;
			this.scaleY = 1.0;
			// ライフ元に戻す
			_life = PoiConfiguration.MAX_LIFE;
			// ポイを非表示にする
			hidePoi();
			// ポイの回転初期値を戻す
			_initRot = 0.0;
			// ぽいを元に戻す
			_poiMc.gotoAndStop('start');
			_poiMc.poiInner.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			// ゲーム中フラグOFF
			_onGame = false;
		}
		
		/**
		 * すくうアニメーション 
		 * 
		 */		
		public function scoopAnimation():void
		{
			_poiMc.gotoAndPlay("scoop");
			//_poiMc.gotoAndPlay('start');
			_poiMc.poiInner.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			Executor.executeAfterWithName(12, "poiScoop" + _poiData.t_id, onComplete);
		}
		/**
		 * すくうアニメーション終了ハンドラ 
		 * 
		 */		
		private function onComplete():void
		{
			Executor.cancelByName("poiScoop" + _poiData.t_id);
			_poiMc.gotoAndStop('normal');
			_poiMc.poiInner.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
		}
		/**
		 * ポイの回転初期化
		 * @param rotation
		 * 
		 */		
		public function initRotatePoi(rot:Number):void
		{
			_initRot = rot;
		}
		/**
		 * ポイを回転させる 
		 * @param rotation
		 * 
		 */
		public function rotatePoi(rot:Number, accuracy:int):void
		{
			
			// テキスト表示
			//tf.text = String(rot);
			//			tf.text = String(_nowRot) + '::' + String(rot);
			//			tf.rotationZ = -this.rotationZ;
			//if (!_rotSmooth)
				rot = int(rot / 45) * 45;
			_nowRot = Util.smoothMoveRotateFunc(_nowRot, rot, 0.3);
			this.rotationZ = _nowRot + FishControlData.paramsPoi[_poiData.t_id].ORIENTATION;
			//this.rotationZ = rot;
			
		}
		
		/**
		 * ポイの残数更新 
		 */
		public function updateLife():void
		{
			// ポイ残数
			if (_life >= 0 && _life <= 3)
				_poiMc.life.gotoAndStop(_poiData.t_id + 'life_' + _life);	// t_idごとに「残り」の色を変える
		}
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
		/**
		 * ユーザー名を表示 
		 */
		private function createName():void
		{	
			_poiMc.userName.userName.text = _poiData.name;
		}
		
		/**
		 * ポイを非表示にする 
		 * 
		 */		
		private function hidePoi():void
		{
			this.visible = false;
		}
		/**
		 * ポイを表示する 
		 * 
		 */		
		private function showPoi():void
		{
			this.visible = true;
			_onGame = true;
			_poiMc.poiInner.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
		}
	}
}