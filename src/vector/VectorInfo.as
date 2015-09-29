package vector
{
	public class VectorInfo
	{
		private static var pIns:VectorInfo;
		
		/**顺时针*/
		public static const CLOCKWISE:int = 1;
		/**逆时针*/
		public static const ANTICLOCKWISE:int = 2;
		
		public static const EPS:Number = 1e-8;
		
		/**目标点和当前位置点的误差值*/
		public static const EPS_ST:Number = 0.5;
		
		public function VectorInfo()
		{
			if(pIns)
				throw new Error("单例错误");
		}
		
		public static function Get():VectorInfo
		{
			return pIns||(pIns = new VectorInfo);
		}
		
	}
}