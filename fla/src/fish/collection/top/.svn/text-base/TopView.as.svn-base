package fish.collection.top
{
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import pigglife.util.ButtonHelper;
	import pigglife.util.Tween;
	import pigglife.view.RootStage;

	/**
	 *　トップ画面
	 * @author bamba misaki
	 */
	public class TopView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _idelegate:TopInternalDelegate;
		private var _container:Sprite;
		private var _buttonHelper:ButtonHelper;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================
		public function get view():Sprite {return _container;}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function TopView(idelegate:TopInternalDelegate)
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
			_buttonHelper = new ButtonHelper(_container).click(onClick);
		}
		
		/**
		 * ロゴを表示 
		 */
		public function show():void
		{
			// 背景の白バック
			var g:Graphics = _container.graphics;
			g.beginFill(0xFFFFFF, 0.8);
			g.drawRect(0.0, 0.0, _container.stage.stageWidth, _container.stage.stageHeight);
			g.endFill();
			// ロゴ
			createLogo();
			// フェードインさせる
			_container.alpha = 0.0;
			Tween.applyTo(_container, 1.0, {alpha: 1.0});
		}
		
		/**
		 * タイトルを表示 
		 */
		public function showTitle():void
		{
			// タイトル表示
			createTitle();
		}
		
		/**
		 * フェードアウトさせる 
		 * @param handler
		 * 
		 */		
		public function fadeout(handler:Function):void
		{
			Tween.applyTo(_container, 1.0, {alpha: 0.0, onComplete: handler});
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
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
			_idelegate.clean();
			_idelegate.showGame()
		}
		
		/**
		 * ロゴを表示 
		 */
		private function createLogo():void
		{
			var logo:Bitmap = new Bitmap(new Logo);
			logo.x = int((RootStage.stageWidth - logo.width) *.5);
			logo.y = int((RootStage.stageHeight - logo.height) *.5);
			_container.addChild(logo);
		}
		
		/**
		 * スタンバイ画像を表示 
		 */
		private function createTitle():void
		{
			var title:Bitmap = new Bitmap(new Title);
			title.x = int((RootStage.stageWidth - title.width) *.5);
			title.y = int((RootStage.stageHeight - title.height) *.5);
			_container.addChild(title);
		}
	}
}