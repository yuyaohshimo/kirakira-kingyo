package fish.collection.poi.data
{
	/**
	 * 端末の重力加速度データ
	 * @author bamba miskai
	 */
	public class LocateData
	{
		public var t_id:String;
		public var ac:Number;
		public var acg:Number;
		public var rr:Number;
		public var doShake:Boolean = false;
		public var doScoop:Boolean = false;
		
		public function LocateData(data:Object = null)
		{
			if (!data) return;
			if (data.t_id) 
				t_id = data.t_id;
			if (data.locate_info.ac) 
				ac = data.locate_info.ac;
			if (data.locate_info.acg) 
				acg = data.locate_info.acg;
			if (data.locate_info.rr) 
				rr = data.locate_info.rr;
			if (data.locate_info.doShake) 
				doShake = data.locate_info.doShake;
			if (data.locate_info.doScoop) 
				doScoop = data.locate_info.doScoop;
		}
	}
}