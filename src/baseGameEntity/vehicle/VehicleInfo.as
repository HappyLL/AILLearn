package baseGameEntity.vehicle
{
	public class VehicleInfo
	{
		private static var pIns:VehicleInfo; 
		
		
		public var m_szPointOfVeh:Array = [[40,0],[-20*Math.cos(5*Math.PI/12)-20,20*Math.sin(5*Math.PI/12)],
			[-20*Math.cos(5*Math.PI/12)-20,-20*Math.sin(5*Math.PI/12)]]
		
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