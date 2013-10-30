package fish.collection.fish
{
	import fish.collection.fish.configuration.BodyConfiguration;
	import fish.collection.fish.data.BodyPositionData;
	import fish.collection.fish.data.FishData;
	import fish.collection.game.util.Util;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
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
		private var _positionData:BodyPositionData;
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
		public function show():void
		{
			// MCを各パーツにアタッチ
			_head.addChild(addParts(_data.type, BodyConfiguration.HEAD));
			_body.addChild(addParts(_data.type, BodyConfiguration.BODY));
			_rFin.addChild(addParts(_data.type, BodyConfiguration.R_FIN));
			_lFin.addChild(addParts(_data.type, BodyConfiguration.L_FIN));
			_tail.addChild(addParts(_data.type, BodyConfiguration.TAIL));
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
		 * コンテナ c2 に所属するオブジェクトを c1 に移動します。　
		 */
		private function copyShapes(
			c1:DisplayObjectContainer,
			c2:DisplayObjectContainer,
			shapeOnly:Boolean = false,
			keepPosition:Boolean = false):void
		{
			if (keepPosition)
			{
				c1.transform.matrix = c2.transform.matrix;
			}
			
			if (c2.name.indexOf("instance") < 0)
			{
				c1.name = c2.name;
			}
			
			while (c2.numChildren > 0)
			{
				var dobj:DisplayObject = c2.getChildAt(0);
				var name:String = dobj.name;
				var ct:ColorTransform = null;

				if (shapeOnly && dobj is MovieClip)
				{
					var mat:Matrix = dobj.transform.matrix;
					var c3:MovieClip = MovieClip(dobj);
					if (c3.totalFrames > 1)
					{
						c1.addChild(c3);
					}
					else
					{
						while (c3.numChildren > 0)
						{
							var c3c:DisplayObject = c3.getChildAt(0);
							var c3m:Matrix = c3c.transform.matrix;
							c3m.concat(mat);
							c3c.transform.matrix = c3m;
							c1.addChild(c3c);
						}
						c2.removeChild(dobj);
					}
				}
				else
				{
					c1.addChild(dobj);
				}
			}
		}
		
		/**
		 * 各パーツを表示 
		 * @param obj
		 * @param index
		 */
		private function showPart(obj:DisplayObject, index:int = -1):void
		{
			if (obj != null)
			{
				if (index == -1)
					addChild(obj);
				else
					addChildAt(obj, index);
			}
		}
		
		/**
		 * MCを各パーツにアタッチ 
		 * @param code
		 * @param part
		 * @return 
		 */
		private function addParts(type:String, part:String):MovieClip
		{
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
			
			type2_body_1;
			type2_head_1;
			type2_lFin_1;
			type2_rFin_1;
			type2_tail_1;
			type2_whole;
			
			type3_body_1;
			type3_head_1;
			type3_lFin_1;
			type3_rFin_1;
			type3_tail_1;
			type3_whole;
			
			type4_body_1;
			type4_head_1;
			type4_lFin_1;
			type4_rFin_1;
			type4_tail_1;
			type4_whole;
			
			type5_body_1;
			type5_head_1;
			type5_lFin_1;
			type5_rFin_1;
			type5_tail_1;
			type5_whole;
			
			type6_body_1;
			type6_head_1;
			type6_lFin_1;
			type6_rFin_1;
			type6_tail_1;
			type6_whole;
			
			
			//trace('MCを各パーツにアタッチ', type, part);
			var mcName:String = type + "_" + part + "_" + 1;
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
			
			// パーツの座標を設定する
			//getPos(mc, part);
			return mc;
		}
		
		
		/**
		 * 各パーツの位置を調整 
		 * @param part
		 * @param name
		 */
		private function getPos(mc:DisplayObject, partName:String):void
		{
			mc.x = BodyConfiguration.DEFAULT_POSITION[partName].x;
			mc.y = BodyConfiguration.DEFAULT_POSITION[partName].y;	
		}
	}
}