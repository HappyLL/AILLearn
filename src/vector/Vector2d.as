package vector
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import configXml.GameWordData;
	
	public class Vector2d extends Point
	{
		private var m_nX:Number;
		private var m_nY:Number;
		
		/**
		 * 二维平面上向量
		 */
		public function Vector2d(nX:Number = 0,nY:Number = 0)
		{
			m_nX = nX;
			m_nY = nY;
			this.x = m_nX;
			this.y = m_nY;
		}
		
		/**
		 * 设置为零向量
		 */
		public function Zero():void
		{
			m_nX = 0;
			m_nY = 0;
		}
		/**
		 * 判断是否为零向量
		 */
		public function isZero():Boolean
		{
			return (m_nX*m_nX+m_nY*m_nY)<VectorInfo.EPS;
		}
		/**
		 * 当前向量长度
		 */
		public function Length():Number
		{
			return Math.sqrt(LengthSq());
		}
		/**
		 * 当前向量长度的平方
		 */
		public function LengthSq():Number
		{
			return m_nX*m_nX+m_nY*m_nY;
		}
		/**
		 * 将当前向量转化为单位向量
		 */
		public function Normalize():void
		{
			var iLen:int = Length();
			if(iLen<1e-12)
			{
				m_nX = 0;
				m_nY = 0;
				return;
			}
			m_nX/=iLen;
			m_nY/=iLen;
		}
		
		/**
		 * 向量点击
		 */
		public function Dot(vt:Vector2d):Number
		{
			return m_nX*vt.m_nX+m_nY*vt.m_nY;
		}
		
		/**
		 * 判断当前向量在另一个向量的位置(逆时针方向或顺时针方向)
		 * 利用叉积
		 * 因为当前的坐标系Y坐标变化 所以满足是Y要为原来的负数
		 */
		public function Sign(vt:Vector2d):int
		{
			var nRet:Number = m_nX*(-vt.m_nY) - (-m_nY)*vt.m_nX;
			//trace(nRet)
//			if(Math.abs(nRet)<1e-2)
//				return 0;
			if(nRet<0)
			{
				return VectorInfo.ANTICLOCKWISE;
			}
			else 
				return VectorInfo.CLOCKWISE;
		}
		/**
		 * 返回当前的向量正交的向量
		 */
		public function Perp():Vector2d
		{
			return new Vector2d(-m_nY,m_nX);
		}
		
		/**
		 * 判断当前向量长度是否最大值如果是则变为长度为max的向量
		 */
		public function Truncate(nMax:Number):void
		{
			if(this.Length()>nMax)
			{
				this.Normalize();
				this.MulNumber(nMax);
			}
		}
		/**
		 * 两个向量的的距离
		 */
		public function Distance(vt:Vector2d):Number
		{
			return Math.sqrt(DistanceSq(vt))
		}
		
		/**
		 * 两个向量的的距离的平方
		 */
		public function DistanceSq(vt:Vector2d):Number
		{
			return (m_nX - vt.m_nX)*(m_nX - vt.m_nX)+
				(m_nY - vt.m_nY)*(m_nY - vt.m_nY);
		}
		/**
		 * 当前向量在给定向量的vtnor的反投影*2+当前向量
		 */
		public function Reflect(vtnor:Vector2d):void
		{
			var vt:Vector2d = vtnor.GetReverse();
			vt.MulNumber(this.Dot(vtnor)*2);
			this.AddVector(vt);
		}
		
		/**
		 * 返回一个向量的反向量(位置为原来的负数)
		 */
		public function GetReverse():Vector2d
		{
			return new Vector2d(-this.m_nX,-this.m_nY);
		}
		
		/**
		 * 向量乘以数量
		 */
		public function MulNumber(iPro:Number):void
		{
			this.m_nX*=iPro;
			this.m_nY*=iPro;
		}
		
		/**
		 * 向量乘以数量
		 */
		public function MulNumberRet(iPro:Number):Vector2d
		{
			return new Vector2d(this.m_nX*iPro,this.m_nY*iPro);
		}
		
		/**
		 * 向量除以数量
		 */
		public function DivNumber(iPro:Number):void
		{
			if(Math.abs(iPro)<VectorInfo.EPS)
				throw new Error("除零");
			this.m_nX/=iPro;
			this.m_nY/=iPro;
		}
		
		/**
		 * 向量除以数量
		 */
		public function DivNumberRet(iPro:Number):Vector2d
		{
			if(Math.abs(iPro)<VectorInfo.EPS)
				throw new Error("除零");
			return new Vector2d(this.m_nX/iPro,this.m_nY/iPro);
		}
		
		/**
		 * 向量相加 +
		 */
		public function AddVector(vt:Vector2d):void
		{
			this.m_nX = this.m_nX+vt.m_nX;
			this.m_nY = vt.m_nY+this.m_nY;
		}
		
		public function AddVectorRet(vt:Vector2d):Vector2d
		{
			return new Vector2d(this.m_nX+vt.m_nX,this.m_nY+vt.m_nY);
		}
		
		/**
		 * 向量相减
		 */
		public function SubVector(vt:Vector2d):void
		{
			this.m_nX = this.m_nX-vt.m_nX;
			this.m_nY = -vt.m_nY+this.m_nY;
		}
		
		public function SubVectorRet(vt:Vector2d):Vector2d
		{
			return new Vector2d(m_nX - vt.m_nX , m_nY - vt.m_nY);
		}
		
		public function IsEqual(vt:Vector2d):Boolean
		{
			return GameWordData.Get().IsEqual(m_nX - vt.m_nX)&&
				GameWordData.Get().IsEqual(m_nY - vt.m_nY);
		}
		
		public function get nX():Number
		{
			return m_nX;
		}
		
		public function set nX(value:Number):void
		{
			m_nX = value;
			x = value;
		}	
		
		public function get nY():Number
		{
			return m_nY;
		}
		
		public function set nY(value:Number):void
		{
			m_nY  = value;
			y = value;
		}
		
		/**获取当前两点构成线段的中点*/
		public static function Vect2DSegmentMidPoint(stLhs:Vector2d,stRhs:Vector2d):Vector2d
		{
			return new Vector2d((stLhs.nX+stRhs.nX)/2,(stLhs.nY+stRhs.nY)/2);
		}
		
		/**将当前向量变成标准向量*/
		public static function Vect2DNormalize(stVector2d:Vector2d):Vector2d
		{
			var stTmpVector2d:Vector2d = new Vector2d(stVector2d.nX,stVector2d.nY);
			stTmpVector2d.Normalize();
			return stTmpVector2d;
		}
		
		/**
		 * 旋转当前向量
		 * @param Angle:旋转的弧度
		 */
		public static function Vec2DRotateAroundOrigin(stOrVector2d:Vector2d,nAngle:Number):Vector2d
		{
			var stVector2d:Vector2d = new Vector2d(stOrVector2d.nX,stOrVector2d.nY);
			var stMatrix:Matrix = new Matrix;
			stMatrix.rotate(nAngle);
			var stPoint:Point = stMatrix.transformPoint(stVector2d);
			stVector2d.nX = stPoint.x;
			stVector2d.nY = stPoint.y;
			return stVector2d;
		}
		
		/**
		 * 判断是否相交
		 * @param stA:一个向量AB的起点
		 * @param stB:一个向量AB的终点
		 * @param stC:
		 * @param stD:
		 * @param stIns:交点
		 * @return -1 表示当前不想交(否则为点A到交点的距离)
		 */
		public static function LineIntersection2D(stA:Vector2d,stB:Vector2d,stC:Vector2d,stD:Vector2d,stIns:Vector2d):Number
		{
			var nRTop:Number = (stA.nY - stC.nY)*(stD.nX - stC.nX) - (stA.nX - stC.nX)*(stD.nY - stC.nY);
			var nRBot:Number = (stB.nX - stA.nX)*(stD.nY - stC.nY) - (stB.nY - stA.nY)*(stD.nX - stC.nX);
			
			var nSTop:Number = (stA.nY - stC.nY)*(stB.nX - stA.nX) - (stA.nX - stC.nX)*(stB.nY - stA.nY);
			var nSBot:Number = (stB.nX - stA.nX)*(stD.nY - stC.nY) - (stB.nY - stA.nY)*(stD.nX - stC.nX);
			
			if((nRBot==0)||(nSBot==0))
				return -1;
			
			var nR:Number = nRTop/nRBot;
			var nS:Number = nSTop/nSBot;
			
			if((nR>0&&nR<1)&&(nS>0&&nS<1))
			{
				var stTemp:Vector2d = stB.SubVectorRet(stA);
				stTemp.Normalize();
				var stTempSec:Vector2d = stA.AddVectorRet(stTemp.MulNumberRet(nR));
				stIns.nX = stTempSec.nX;
				stIns.nY = stTempSec.nY;
				stTemp.MulNumber(nR);
				return  stTemp.Length();
			}
			
			return -1;
		}
		
		public static function WrapAround(stPos:Vector2d,nMaxX:Number,nMaxY:Number):void
		{
			if(stPos.nX>=nMaxX)
				stPos.nX = 0;
			if(stPos.nX<0)
				stPos.nX = nMaxX;
			if(stPos.nY>=nMaxY)
				stPos.nY = 0;
			if(stPos.nY<0)
				stPos.nY = nMaxY;
		}
		
		public static function IsSimaEqualVector2d(stVectorLhs:Vector2d,stVectorRhs:Vector2d,Eps:Number):Boolean
		{
//			trace(stVectorLhs.nX,stVectorLhs.nY);
//			trace(stVectorRhs.nX,stVectorRhs.nY);
			
			return (Math.abs(stVectorLhs.nX - stVectorRhs.nX)<Eps)
					&&(Math.abs(stVectorLhs.nY - stVectorRhs.nY)<Eps);
		}
		
		public static function RandomClamped():Number
		{
			return Math.random() - Math.random();
		}
		
		public static function RandFloat():Number
		{
			return (Math.random())		
		}
		
		public static function RandInRange(x:Number,y:Number):Number
		{
			return x + RandFloat()*(y - x);
		}
		
	}
}