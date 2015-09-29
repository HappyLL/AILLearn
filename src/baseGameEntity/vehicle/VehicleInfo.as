package baseGameEntity.vehicle
{
	public class VehicleInfo
	{
		private static var pIns:VehicleInfo; 
		
		
		public var m_szPointOfVeh:Array = [[0,40],[-60*Math.cos(5*Math.PI/12),-60*Math.sin(5*Math.PI/12)+40],
			[60*Math.cos(5*Math.PI/12),-60*Math.sin(5*Math.PI/12)+40]]
		
		public function VehicleInfo()
		{
			if(pIns)
				throw new Error("单例错误");
		}
		
		public static function Get():VehicleInfo
		{
			return pIns||(pIns = new VehicleInfo);
		}
		
	}
}