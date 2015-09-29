package path
{
	import flash.display.Sprite;
	
	import vector.Vector2d;

	public class Path extends Sprite
	{
		/**当前路劲点的集合*/
		private var m_szWayPoints:Vector.<Vector2d>;
		/**当前路劲点的下标*/
		private var m_iNowPointIndex:int;
		
		/**当前路径是否是环路*/
		private var m_bLoop:Boolean;
		
		/**
		 * @param iNumsWayPoint 当前路劲点的个数
		 * @param nMinX:路劲中的最小点的X
		 * @param nMinY:路劲中的最小点的Y
		 * @param nMaxX:路劲中的最大点的X
		 * @param nMaxY:路劲中的最大点的Y
		 * @param isLoop:当前是否是环路
		 */
		public function Path(iNumsWayPoint:int,nMinX:Number,nMinY:Number,nMaxX:Number,nMaxY:Number,isLoop:Boolean)
		{
			m_bLoop = isLoop;
			m_szWayPoints = new Vector.<Vector2d>;
			CreateRandomPath(iNumsWayPoint,nMinX,nMinY,nMaxX,nMaxY);
		}
		
		public function CreateRandomPath(iNumsWayPoint:int,nMinX:Number,nMinY:Number,nMaxX:Number,nMaxY:Number):Vector.<Vector2d>
		{
			m_szWayPoints.length = 0;
			var nMidX:Number = (nMinX+nMaxX)/2;
			var nMidY:Number = (nMaxY+nMinY)/2;
			
			var nSmaller:Number = Math.min(nMidX,nMidY)
			
				
			var nSpacing:Number = 2*Math.PI/(iNumsWayPoint);
			
			var nRadialDist:Number;
			for(var i:int = 0;i<iNumsWayPoint;++i)
			{
				nRadialDist = Vector2d.RandInRange(nSmaller*0.2,nSmaller);
				var stTmp:Vector2d = new Vector2d(nRadialDist,0);
				stTmp = Vector2d.Vec2DRotateAroundOrigin(stTmp,i*nSpacing);
				stTmp.nX+=nMidX;stTmp.nY+=nMidY;
				m_szWayPoints.push(stTmp);
			}
			m_iNowPointIndex = 0;
			return m_szWayPoints;
		}
		
		public function get CurrentWayPoint():Vector2d
		{
			var iNowIndex:int = m_iNowPointIndex;
			if(m_iNowPointIndex == m_szWayPoints.length)
				iNowIndex --;
			return m_szWayPoints[iNowIndex];
		}
		
		public function IsFinished():Boolean
		{
			return m_iNowPointIndex == m_szWayPoints.length;
		}
		
		public function LoopOn():void
		{
			m_bLoop = true;
		}
		
		public function LoopOff():void
		{
			m_bLoop = false;
		}
		
		public function AddWayPoint(stPoint:Vector2d):void
		{
			
		}
		
		public function set NewPath(value:Vector.<Vector2d>):void
		{
			m_szWayPoints = value;
			m_iNowPointIndex = 0;
		}
		
		public function Clear():void
		{
			m_szWayPoints.length = 0;
		}
		
		public function GetPath():Vector.<Vector2d>
		{
			return m_szWayPoints;
		}
		
		public function SetNextWayPoint():void
		{
			if(m_iNowPointIndex==m_szWayPoints.length)
			{
				if(m_bLoop)
					m_iNowPointIndex = 0;
				return;
			}
			
			if(++m_iNowPointIndex==m_szWayPoints.length)
			{
				if(m_bLoop)
				{
					m_iNowPointIndex = 0;
				}
			}
		}
		
		public function Render():void
		{
			
			var iLhsIndex:int = m_iNowPointIndex;
			var iRhsIndex:int  = m_iNowPointIndex+1;
			this.graphics.lineStyle(2,0xFF0000);
			this.graphics.moveTo(m_szWayPoints[iLhsIndex].nX,m_szWayPoints[iLhsIndex].nY);
			while(iRhsIndex<m_szWayPoints.length)
			{
				iLhsIndex = iRhsIndex;
				this.graphics.lineTo(m_szWayPoints[iLhsIndex].nX,m_szWayPoints[iLhsIndex].nY);
				this.graphics.moveTo(m_szWayPoints[iLhsIndex].nX,m_szWayPoints[iLhsIndex].nY);
				iRhsIndex++;
			}
			
			if(m_bLoop) this.graphics.lineTo(m_szWayPoints[0].nX,m_szWayPoints[0].nY);
			
		}
		
	}
}