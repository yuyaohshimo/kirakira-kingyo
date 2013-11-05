package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import fish.collection.MainDelegate;
	import fish.collection.MainFacade;
	import fish.collection.MainModel;
	import fish.collection.net.FishClient;
	
	import pigglife.ObjectContainer;
	import pigglife.util.Tween;
	import pigglife.util.TweenLiteLogic;
	import pigglife.view.RootStage;
	import pigglife.view.SimpleViewContainer;
	import pigglife.view.ViewContainer;
	
	[SWF(width="1600",height="900",frameRate="24",backgroundColor="#ffffff")]
	public class fishcollection extends Sprite
	{
		protected var container:ObjectContainer;
		
		public function fishcollection()
		{

			LogConfig.enabled = false;
			
			RootStage.stage = stage;
			stage.quality = StageQuality.HIGH;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			//stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; 
			// ログを表示
			LogConfig.enabled = true;
			
			container = new ObjectContainer(ApplicationDomain.currentDomain);
			
			container.register(MainModel);
			container.register(MainDelegate);
			container.register(MainFacade);
			
			container.register(FishClient);
			
			container.register(ViewContainer,  new SimpleViewContainer(this));
			
			Tween.logic = new TweenLiteLogic();
			//enableDragg();
			
			initApp();
		}
		
		protected function initApp():void
		{
			container.initialize();
			
			var main:* = container.getInstance('fish.collection::MainModel');
			if (main != null)
			{
				// 接続開始
				main.start();
			}
		}
			
		private function enableDragg():void
		{
			RootStage.stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		private function _onMouseDown(e:MouseEvent):void
		{
			e.stopPropagation();
			stage.nativeWindow.startMove(); 
		}
	}
}