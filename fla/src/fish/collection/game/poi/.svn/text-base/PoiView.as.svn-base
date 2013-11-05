package fish.collection.game.poi
{
	import com.greensock.easing.Back;
	
	import fish.collection.game.GameInternalDelegate;
	import fish.collection.game.poi.configuration.PoiConfiguration;
	import fish.collection.game.poi.data.PoiData;
	import fish.collection.game.util.Util;
	
	import flash.debugger.enterDebugger;
	import flash.display.Sprite;
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
		private var _onGame:Boolean;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================

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
			// ポイ本体の表示
			_poiMc = new PoiMc();
			// ぽいを元に戻す
			_poiMc.gotoAndStop('normal');
			_poiMc.poiInner.gotoAndStop("t_id" + id);
			_poiMc.poiInner_miss.gotoAndStop("t_id" + id);
			
			this.addChild(_poiMc);
			hidePoi();
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
			_poiMc.gotoAndStop('normal');
			_poiMc.poiInner.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
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
			_poiMc.gotoAndStop('miss');
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			// ミスアニメーション
			Tween.applyTo(this, 1.5, {alpha: 0.0, scaleX: 0.5, scaleY: 0.5, ease:Back.easeOut, onComplete: onMissAnimationEnd});
			if (_life <= 0)
				_onGame = false;
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
			}
			else
			{
				this.alpha = 1.0;
				this.scaleX = 1.0;
				this.scaleY = 1.0;
			}
			// ぽいを元に戻す
			_poiMc.gotoAndStop('normal');
			_poiMc.poiInner.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
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
			_life = PoiConfiguration.MAX_LIFE;;
			// ポイを非表示にする
			hidePoi();
			// ポイの回転初期値を戻す
			_initRot = 0.0;
			// ぽいを元に戻す
			_poiMc.gotoAndStop('normal');
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
			_poiMc.poiInner.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			_poiMc.poiInner_miss.gotoAndStop("t_id" + String(int(_poiData.t_id) - 1));
			Executor.executeAfterWithName(17, "poiScoop" + _poiData.t_id, onComplete);
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
		public function rotatePoi(rot:Number):void
		{
			rot = -rot;
			this.rotationZ = rot;
		}
		
		/**
		 * ポイの残数更新 
		 */
		public function updateLife():void
		{
			// ポイ残数
			if (_life >= 0 && _life <= 3)
				_poiMc.life.gotoAndStop('life_' + _life);
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