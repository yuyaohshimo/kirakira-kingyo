package fish.collection.fish.data
{
	public class BodyPartData
	{
		public var x:int;
		public var y:int;
		public function BodyPartData(data:Object = null)
		{
			if (!data) return;
			if (data.x) 
				x = data.x;
			if (data.y) 
				y = data.y;
		}
	}
}