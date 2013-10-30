package fish.collection.top
{
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import pigglife.util.ButtonHelper;
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
			// ロゴ
			createLogo();
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