package fish.collection.game.view.ui
{
	import com.bit101.components.ScrollBar;
	import com.bit101.components.Slider;
	import com.bit101.components.Text;
	
	import fish.collection.game.util.Util;
	import fish.collection.game.view.FishControlData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.text.TextField;
	
	public class FishControlPanel extends Sprite
	{
		private var _slider:Vector.<MySlider>;
		private var _sharedObject:SharedObject;
		
		public function FishControlPanel()
		{
			super();
			_slider = new Vector.<MySlider>();
			var index:int = 0;
			for (var type:String in FishControlData.params)
			{
				for (var key:String in FishControlData.params[type])
				{
					if (key == 'SPEED_DECAY')
					{
						_slider.push(new MySlider(type, key, 6.0, 10.0, Slider.HORIZONTAL, this, 0, 20 * index, onSlide));
					}
					else
					{
						_slider.push(new MySlider(type, key, 0.0, 1.5, Slider.HORIZONTAL, this, 0, 20 * index, onSlide));
					}
					index++;
				}
			}
			
			for (type in FishControlData.paramsPoi)
			{
				for (key in FishControlData.paramsPoi[type])
				{
					_slider.push(new MySlider(type, key, 0.0, 360.0, Slider.HORIZONTAL, this, 0, 20 * index, onSlide));
					index++;
				}
			}
		}
		/*
		private function setSharedObject():void
		{
			// 共有オブジェクトを生成
			_sharedObject = SharedObject.getLocal("FishControlPanelData","/");
			
			if(_sharedObject)
			{
				// イベントを登録
				_sharedObject.addEventListener (NetStatusEvent.NET_STATUS ,SharedObjectStatusEventFunc);
				log('共有オブジェクトの作成に成功');
			}
			else
			{
				log('共有オブジェクトの作成に失敗');
			}
		}
		
		private function SharedObjectStatusEventFunc (event : NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "SharedObject.Flush.Success":
					log("ハードディスク書き込み　　許可");
					break;
				case "SharedObject.Flush.Failed":
					log("ハードディスク書き込み　　拒否");
					break;
			}
		}
		
		private function flushSharedObject(data):void
		{
			if(_sharedObject)
			{
				_sharedObject.data = data;
				
				try
				{
					// テキストフィールドのデータをハードディスクへ保存する
					var str = _sharedObject.flush();
					switch (str) 
					{
						case SharedObjectFlushStatus.FLUSHED :
							log("ハードディスク書き込み　完了");
							break;
						case SharedObjectFlushStatus.PENDING :
							log("ハードディスク書き込み　要求");
							break;
					}
					// flush()でエラーが出る可能性があるので必ずキャッチ処理を書く
				}
				catch(e)
				{
					log("ハードディスク書き込み　失敗");
				}
			}
		}
		*/
		/**
		 * クリーン
		 */
		public function clean():void
		{
			for (var i:int = 0, len:int = _slider.length; i < len; i++)
			{
				_slider[i] = null;
			}
		}
		
		private function onSlide(e:Event):void
		{
			e.target.setTextVal();
			
			for (var type:String in FishControlData.params)
			{
				for (var key:String in FishControlData.params[type])
				{
					if (e.target.key == key && e.target.type == type)
					{
						FishControlData.params[type][key] = e.target.getValue();
						//trace('かえた', key, FishControlData.params[key]);
					}
				}
			}
			for (type in FishControlData.paramsPoi)
			{
				for (key in FishControlData.paramsPoi[type])
				{
					if (e.target.key == key && e.target.type == type)
					{
						FishControlData.paramsPoi[type][key] = e.target.getValue();
					}
				}
			}
//			for (var key:String in FishControlData.params)
//			{
//				if (e.target.key == key)
//				{
//					FishControlData.params[type][key] = e.target.getValue();
//					//trace('かえた', key, FishControlData.params[key]);
//				}
//			}
		}
	}
}
