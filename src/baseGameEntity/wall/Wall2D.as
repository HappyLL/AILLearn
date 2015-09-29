package baseGameEntity.wall
{
	import baseGameEntity.BaseGameEntity;
	
	import vector.Vector2d;

	public class Wall2D extends BaseGameEntity
	{
		private var m_stA:Vector2d;
		private var m_stB:Vector2d;
		/**当前墙壁的法线*/
		private var m_stN:Vector2d;
		
		public function Wall2D(stA:Vector2d,stB:Vector2d)
		{
			super();
			
			m_stA = new Vector2d(stA.nX,stA.nY);
			m_stB = new Vector2d(stB.nX,stB.nY);
			m_stN = new Vector2d;
			CaculateNormal();
		}
		
		private function CaculateNormal():void
		{
			var stTemp:Vector2d = Vector2d.Vect2DNormalize(m_stA.SubVectorRet(m_stB));
			
			m_stN.nX = -stTemp.nY;
			m_stN.nY = stTemp.nX;
		}
		
		public function set From(value:Vector2d):void
		{
			m_stA = value;
		}
		
		public function get From():Vector2d
		{
			return m_stA;
		}
		
		public function set To(value:Vector2d):void
		{
			m_stB = value;
		}
		
		public function get To():Vector2d
		{
			return m_stB;
		}
		
		public function set Normal(value:Vector2d):void
		{
			m_stN = value;
		}
		
		public function get Normal():Vector2d
		{
			return m_stN;
		}
		
		public function get Center():Vector2d
		{
			return new Vector2d((m_stA.nX+m_stB.nX)/2,(m_stA.nY+m_stB.nY)/2);
		}
		
		public override function Render():void
		{
			this.graphics.lineStyle(2,0x000000);
			this.graphics.moveTo(m_stA.nX,m_stA.nY);
			this.graphics.lineTo(m_stB.nX,m_stB.nY);
		}
		
	}
}