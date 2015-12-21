package baseGameEntity.info
{
	
	public class BaseGameEntityInfo
	{
		private static var pIns:BaseGameEntityInfo;
		
		public static const MINER:int = 0;
		public static const MINER_WIFE:int = 1;
		public static const DEFAULT_ENTITY_TYPE:int = -1;
		public static const NUMVEHICLEVERTS:int = 3
		public static const VEHICLEMASS:Number = 1.0;
		public static var MAXSTEERINGFORCE:Number = 150;
		public static var MAXSPEED:Number = 5.0;
		public static const MAXTURNRATEPERSECOND:Number = Math.PI;
		public static const VEHICLESCALE:Number =2.0;
		
		public function BaseGameEntityInfo()
		{
			if(pIns)
				throw new Error("单例错误");
		}
		
		public  static function  Get():BaseGameEntityInfo
		{
			return pIns||(pIns = new BaseGameEntityInfo)
		}
		
		
	}
}