package baseGameEntity.moveEntity
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import baseGameEntity.BaseGameEntity;
	
	import vector.Vector2d;
	
	public class MoveEntity extends BaseGameEntity
	{
		
		protected var m_stVelocity:Vector2d;
		protected var m_stHeading:Vector2d;
		protected var m_stRenderHeading:Vector2d;
		protected var m_stSide:Vector2d;
		protected var m_nMass:Number;
		protected var m_nMaxSpeed:Number;
		protected var m_nMaxForce:Number;
		protected var m_nMaxTurnRate:Number;
		
		public function MoveEntity(stPos:Vector2d,nRadius:Number,stVelocity:Vector2d,
								   nMaxSpeed:Number,stHeading:Vector2d,nMass:Number,
								   stScale:Vector2d,nTurnRate:Number,nMaxForce:Number)
		{
			super(0,stPos,nRadius);
			m_stVelocity = stVelocity;
			m_stHeading = stHeading;
			m_stRenderHeading = new Vector2d(m_stHeading.nX,m_stHeading.nY);
			m_stSide = stHeading.Perp();
			m_nMaxSpeed = nMaxSpeed;
			m_nMaxTurnRate = nTurnRate;
			m_nMaxForce = nMaxForce;
			m_stScale = stScale;
			m_nMass = nMass;
		}
		
		public function get Velocity():Vector2d
		{
			return m_stVelocity;
		}
		
		public function set Velocity(value:Vector2d):void
		{
			m_stVelocity = value;
		}
		
		public function get Mass():Number
		{
			return m_nMass;
		}
		
		public  function set Mass(value:Number):void
		{
			m_nMass = value;
		}
		
		public function get Side():Vector2d
		{
			return m_stSide;
		}
		
		public function get MaxSpeed():Number
		{
			return m_nMaxSpeed;
		}
		
		public function set MaxSpeed(value:Number):void
		{
			m_nMaxSpeed = value;
		}
		
		public function get MaxForce():Number
		{
			return m_nMaxForce;
		}
		
		public function set MaxForce(value:Number):void
		{
			m_nMaxForce = value;
		}
		
		public function IsSpeedMaxedOut():Boolean
		{
			return m_nMaxSpeed*m_nMaxSpeed>=m_stVelocity.LengthSq();
		}
		
		public function get Speed():Number
		{
			return m_stVelocity.Length();
		}
		
		public function get SpeedSq():Number
		{
			return m_stVelocity.LengthSq();
		}
		
		public function get Heading():Vector2d
		{
			return m_stHeading;
		}
		
		public function set Heading(value:Vector2d):void
		{
			if(value.LengthSq()<0.000001)
				throw new Error('向量错误');
			m_stHeading = value;
			m_stSide = m_stHeading.Perp();
		}
		/**
		 * 将当前的物体旋转到给定的目标点的朝向(当前点到目标点所形成向量的朝向)
		 * @return 返回true表示当前物体正朝着目标点否则为false
		 */
		public function IsRotateHeadingToFacePosition(stTarget:Vector2d):Boolean
		{
			var stToTarget:Vector2d = stTarget.SubVectorRet(m_stPos);
			stToTarget.Normalize();
			var nAngle:Number = Math.acos(stToTarget.Dot(m_stHeading));
			//小于0....则表示当前正朝向目标体
			if(nAngle<0.000001)
				return true;
			//超过最大朝向则为最大朝向
			if(nAngle>m_nMaxTurnRate) nAngle = m_nMaxTurnRate;
			
			var stMatrix:Matrix = new Matrix;
			stMatrix.rotate(nAngle*m_stHeading.Sign(stToTarget));
			m_stHeading = TransFormVector(m_stHeading,stMatrix);
			m_stVelocity = TransFormVector(m_stSide,stMatrix);
			return false;
		}
		
		public function get MaxTurnRate():Number
		{
			return m_nMaxTurnRate;
		}
		
		public function  set MaxTurnRate(value:Number):void
		{
			m_nMaxTurnRate = value;
		}
		
		private function TransFormVector(stVt:Vector2d,stMatrix:Matrix):Vector2d
		{
			var stPoint:Point = new Point(stVt.nX,stVt.nY);
			stPoint= stMatrix.transformPoint(stPoint);
			return new Vector2d(stPoint.x,stPoint.y);
		}
		
	}
}