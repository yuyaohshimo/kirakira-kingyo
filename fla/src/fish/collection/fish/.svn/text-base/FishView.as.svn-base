package fish.collection.fish
{
	import fish.collection.fish.configuration.BodyConfiguration;
	import fish.collection.fish.data.FishData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;

	/**
	 * 金魚を生成
	 * @author bamba misaki
	 */
	public class FishView extends Sprite
	{
		//=========================================================
		// VARIABLES
		//=========================================================
		private var _container:Sprite;
		private var _data:FishData;
		private var _head:Sprite;
		private var _body:Sprite;
		private var _rFin:Sprite;
		private var _lFin:Sprite;
		private var _tail:Sprite;
		private var _tailDist:Number;
		
		//=========================================================
		// GETTER/SETTER
		//=========================================================

		public function get tailDist():Number
		{
			return _tailDist;
		}

		public function get tail():Sprite
		{
			return _tail;
		}

		public function get lFin():Sprite
		{
			return _lFin;
		}

		public function get rFin():Sprite
		{
			return _rFin;
		}

		public function get body():Sprite
		{
			return _body;
		}

		public function get head():Sprite
		{
			return _head;
		}
		
		public function getFishType():String
		{
			return _data.type;
		}
		
		//===========================================================
		// PUBLIC METHODS
		//===========================================================
		public function FishView()
		{
			super();
		}
		
		/**
		 * 初期化 
		 */
		public function initialize(data:FishData):void
		{
			// データ
			_data = data;
			// 各パーツ
			_head = new Sprite();
			_body = new Sprite();
			_rFin = new Sprite();
			_lFin = new Sprite();
			_tail = new Sprite();
			addChild(_head);
			addChild(_body);
			addChild(_rFin);
			addChild(_lFin);
			addChild(_tail);
		}
		
		/**
		 * 金魚を表示 
		 */
		public function show(colorVariationID:int):void
		{
			// MCを各パーツにアタッチ
			_head.addChild(addParts(_data.type, BodyConfiguration.HEAD, colorVariationID));
			_body.addChild(addParts(_data.type, BodyConfiguration.BODY, colorVariationID));
			_rFin.addChild(addParts(_data.type, BodyConfiguration.R_FIN, colorVariationID));
			_lFin.addChild(addParts(_data.type, BodyConfiguration.L_FIN, colorVariationID));
			_tail.addChild(addParts(_data.type, BodyConfiguration.TAIL, colorVariationID));
		}
		
		/**
		 * clean 
		 */
		public function clean():void
		{
			removeAllChild(this);
			if (_head)
			{
				removeAllChild(_head);
				removeFromParent(_head);
				_head = null;
			}
			if (_body)
			{
				removeAllChild(_body);
				removeFromParent(_body);
				_body = null;
			}
			if (_rFin)
			{
				removeAllChild(_rFin);
				removeFromParent(_rFin);
				_rFin = null;
			}
			if (_lFin)
			{
				removeAllChild(_lFin);
				removeFromParent(_lFin);
				_lFin = null;
			}
			if (_tail)
			{
				removeAllChild(_tail);
				removeFromParent(_tail);
				_tail = null;
			}
		}
		
		//===========================================================
		// PRIVATE METHODS
		//===========================================================
		/**
		 * MCを各パーツにアタッチ 
		 * @param code
		 * @param part
		 * @return 
		 */
		private function addParts(type:String, part:String, colorVariationID:int):MovieClip
		{
			log('カラバリID', colorVariationID);
			// パーツのカラバリをランダムで出す
			//var colorID:int = int(Math.random() * 6) + 1  + 6 * colorVariationID;
			var colorID:int = int(Math.random() * 6) + 1;
			//var rand:int = int(Util.getRandom() + 1;
			//trace('MCを各パーツにアタッチ', type, part);
			var mcName:String = type + "_" + part + "_" + colorID;
			var myClass:Class = Class(getDefinitionByName(mcName));
			var mc:MovieClip = new myClass();
			
			// wholeデータからパーツの座標を抽出
			var wholeName:String = type + '_whole';
			var wholeClass:Class = Class(getDefinitionByName(wholeName));
			var wholeMc:MovieClip = new wholeClass();
			
			
			if(part == 'tail')
			{
				// しっぽの時は0,0を設定する
				mc.x = 0.0;
				mc.y = 0.0;
				_tailDist = wholeMc[part].y;
			}
			else
			{
				mc.x = wholeMc[part].x;
				mc.y = wholeMc[part].y;
			}
			return mc;
		}
	}
	
	/*-------------------------------------------
	FishViewで使用するMovieClipの型を記述？
	-------------------------------------------*/
	deme_body_1;
	deme_head_1;
	deme_rFin_1;
	deme_lFin_1;
	deme_tail_1;
	deme_body_2;
	deme_head_2;
	deme_rFin_2;
	deme_lFin_2;
	deme_tail_2;
	type1_body_1;
	type1_head_1;
	type1_lFin_1;
	type1_rFin_1;
	type1_tail_1;
	type1_whole;
	type1_body_2;
	type1_head_2;
	type1_lFin_2;
	type1_rFin_2;
	type1_tail_2;
	type1_body_3;
	type1_head_3;
	type1_lFin_3;
	type1_rFin_3;
	type1_tail_3;
	type1_body_4;
	type1_head_4;
	type1_lFin_4;
	type1_rFin_4;
	type1_tail_4;
	type1_body_5;
	type1_head_5;
	type1_lFin_5;
	type1_rFin_5;
	type1_tail_5;
	type1_body_6;
	type1_head_6;
	type1_lFin_6;
	type1_rFin_6;
	type1_tail_6;
	
	
	type2_body_1;
	type2_head_1;
	type2_lFin_1;
	type2_rFin_1;
	type2_tail_1;
	type2_whole;
	type2_body_2;
	type2_head_2;
	type2_lFin_2;
	type2_rFin_2;
	type2_tail_2;
	type2_body_3;
	type2_head_3;
	type2_lFin_3;
	type2_rFin_3;
	type2_tail_3;
	type2_body_4;
	type2_head_4;
	type2_lFin_4;
	type2_rFin_4;
	type2_tail_4;
	type2_body_5;
	type2_head_5;
	type2_lFin_5;
	type2_rFin_5;
	type2_tail_5;
	type2_body_6;
	type2_head_6;
	type2_lFin_6;
	type2_rFin_6;
	type2_tail_6;
	
	type3_body_1;
	type3_head_1;
	type3_lFin_1;
	type3_rFin_1;
	type3_tail_1;
	type3_whole;
	type3_body_2;
	type3_head_2;
	type3_lFin_2;
	type3_rFin_2;
	type3_tail_2;
	type3_body_3;
	type3_head_3;
	type3_lFin_3;
	type3_rFin_3;
	type3_tail_3;
	type3_body_4;
	type3_head_4;
	type3_lFin_4;
	type3_rFin_4;
	type3_tail_4;
	type3_body_5;
	type3_head_5;
	type3_lFin_5;
	type3_rFin_5;
	type3_tail_5;
	type3_body_6;
	type3_head_6;
	type3_lFin_6;
	type3_rFin_6;
	type3_tail_6;
	
	type4_body_1;
	type4_head_1;
	type4_lFin_1;
	type4_rFin_1;
	type4_tail_1;
	type4_whole;
	type4_body_2;
	type4_head_2;
	type4_lFin_2;
	type4_rFin_2;
	type4_tail_2;
	type4_body_3;
	type4_head_3;
	type4_lFin_3;
	type4_rFin_3;
	type4_tail_3;
	type4_body_4;
	type4_head_4;
	type4_lFin_4;
	type4_rFin_4;
	type4_tail_4;
	type4_body_5;
	type4_head_5;
	type4_lFin_5;
	type4_rFin_5;
	type4_tail_5;
	type4_body_6;
	type4_head_6;
	type4_lFin_6;
	type4_rFin_6;
	type4_tail_6;
	
	type5_body_1;
	type5_head_1;
	type5_lFin_1;
	type5_rFin_1;
	type5_tail_1;
	type5_whole;
	type5_body_2;
	type5_head_2;
	type5_lFin_2;
	type5_rFin_2;
	type5_tail_2;
	type5_body_3;
	type5_head_3;
	type5_lFin_3;
	type5_rFin_3;
	type5_tail_3;
	type5_body_4;
	type5_head_4;
	type5_lFin_4;
	type5_rFin_4;
	type5_tail_4;
	type5_body_5;
	type5_head_5;
	type5_lFin_5;
	type5_rFin_5;
	type5_tail_5;
	type5_body_6;
	type5_head_6;
	type5_lFin_6;
	type5_rFin_6;
	type5_tail_6;
	
	type6_body_1;
	type6_head_1;
	type6_lFin_1;
	type6_rFin_1;
	type6_tail_1;
	type6_whole;
	type6_body_2;
	type6_head_2;
	type6_lFin_2;
	type6_rFin_2;
	type6_tail_2;
	type6_body_3;
	type6_head_3;
	type6_lFin_3;
	type6_rFin_3;
	type6_tail_3;
	type6_body_4;
	type6_head_4;
	type6_lFin_4;
	type6_rFin_4;
	type6_tail_4;
	type6_body_5;
	type6_head_5;
	type6_lFin_5;
	type6_rFin_5;
	type6_tail_5;
	type6_body_6;
	type6_head_6;
	type6_lFin_6;
	type6_rFin_6;
	type6_tail_6;
}