package configXml
{
	import vector.VectorInfo;

	//游戏世界的xml配置
	public class GameWordData
	{
		private static var pIns:GameWordData;
		public var MINNUMBER:Number;
		public var NumSamplesForSmoothing:int = 50;
		public var NUMOBSTACLES:int = 10;
		public var NUMOBSTACLESRADIUS:Number = 50.0;
		public var NUMSWALL2D:int = 50;
		
		
		
		public function GameWordData()
		{
			if(pIns)
				throw new Error("单例");
		}
		
		public static function Get():GameWordData
		{
			return pIns||(pIns = new GameWordData);	
		}
		
		public function IsEqual(num:Number):Boolean
		{
			return Math.abs(num)<VectorInfo.EPS;
		}
		
	}
}