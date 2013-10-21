package fish.collection.poi.data
{
	public class PoiData
	{
		public var t_id:String;
		public var name:String;
		
		public function PoiData(data:Object = null)
		{
			if (!data) return;
			if (data.t_id) 
				t_id = data.t_id;
			if (data.name) 
				name = data.name;
		}
	}
}