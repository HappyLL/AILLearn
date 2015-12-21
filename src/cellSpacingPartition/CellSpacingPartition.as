package cellSpacingPartition
{
	import algorithm.listCell.Node;
	
	import baseGameEntity.BaseGameEntity;
	
	import cellSpacingPartition.cellBox.Cell;
	import cellSpacingPartition.cellBox.InvertedAABBox2D;
	
	import vector.Vector2d;

	public class CellSpacingPartition
	{
		/**当前每个单元存储物体的邻接表*/
		private var m_szCells:Vector.<Cell>;
		
		/**当前物体的邻居*/
		private var m_szNeibors:Vector.<BaseGameEntity>
		
		private var m_iCurNeiborIndex:int;
		
		/**整体的长和宽*/
		private var m_nSpaceWidth:Number;
		private var m_nSpaceHeight:Number;
		
		/**当前网格的X,Y轴上的单元个数*/
		private var m_iNumsX:int;
		private var m_iNumsY:int;
		
		/**每一个单元的长和宽*/
		private var m_nCellSizeX:Number;
		private var m_nCellSizeY:Number;
		
		/**
		 * 对于整体空间的单元化
		 * @param iNumsX:X轴上单元的个数
		 * @param iNumsY:Y轴上单元的个数
		 * @param nSpaceWidth:要划分单元空间的宽
		 * @param nSpaceHeight:要划分单元空间的高
		 * @param iMaxEntitys:每个单元空间最大可容纳物体的个数 
		 */
		public function CellSpacingPartition(iNumsX:int,iNumsY:int,nSpaceWidth:Number,nSpaceHeight:Number,iMaxEntitys:int)
		{
			m_iNumsX = iNumsX;
			m_iNumsY = iNumsY;
			m_nSpaceWidth = nSpaceWidth;
			m_nSpaceHeight = nSpaceHeight;
			m_nCellSizeX = nSpaceWidth/m_iNumsX;
			m_nCellSizeY = nSpaceHeight/m_iNumsY;
			
			m_szCells = new Vector.<Cell>;
			m_szNeibors = new Vector.<BaseGameEntity>(iMaxEntitys);
			
			m_iCurNeiborIndex = 0;
			
			InitCell();
		}
		
		private function InitCell():void
		{
			var stCell:Cell;
			var stTL:Vector2d;
			var stRB:Vector2d;
			for(var i:int = 0;i<m_iNumsY;++i)
			{
				for(var j:int = 0;j<m_iNumsX;++j)
				{
					stTL = new Vector2d(j*m_nCellSizeX,i*m_nCellSizeY);
					stRB = new Vector2d((j+1)*m_nCellSizeX,(i+1)*m_nCellSizeY)
					stCell = new Cell(stTL,stRB);
					m_szCells.push(stCell);
				}
			}
		}
		
		public function CalculateNeighbors(stTarPos:Vector2d,nViewRadius:Number):void
		{
			var iCurIndex:int = 0;
			
			var stTmpPoint:Vector2d = new Vector2d(nViewRadius,nViewRadius);
			
			var stQueryBox:InvertedAABBox2D = new InvertedAABBox2D(stTarPos.SubVectorRet(stTmpPoint),stTarPos.AddVectorRet(stTmpPoint));
			
			var iCellLen:int = m_szCells.length;
			var nDis:Number;
			var nDisBr:Number;
			for(var i:int = 0;i<iCellLen;++i)
			{
				if(iCurIndex>=m_szNeibors.length)
					break;
				//表示当前的检测和与单元重叠并且里面有运动的物体
				if(m_szCells[i].InvBox2D.IsOverLappedWith(stQueryBox)&&m_szCells[i].EntitySet.Length()>0)
				{
					//var iEnLn:int = m_szCells[i].EntitySet.Length();
//					for(var j:int = 0;j<iEnLn;++j)
//					{
//						nDis = m_szCells[i].EntitySet[j].Pos.SubVectorRet(stTarPos).LengthSq()
//						nDisBr =(m_szCells[i].EntitySet[j].BRadius+nViewRadius); 
//						if(nDis<nDisBr*nDisBr)
//						{
//							m_szNeibors[iCurIndex++] =m_szCells[i].EntitySet[j]; 	
//						}
//					}
					var stNode:Node = m_szCells[i].EntitySet.Head();
					while(stNode.NextNode)
					{
						nDis = stNode.NextNode.Data.Pos.SubVectorRet(stTarPos).LengthSq()//m_szCells[i].EntitySet.SubVectorRet(stTarPos).LengthSq()
						nDisBr = stNode.NextNode.Data.BRadius+nViewRadius;
						if(nDis<(nDisBr*nDisBr))
						{
							m_szNeibors[iCurIndex++] = stNode.NextNode.Data;
						}
						stNode = stNode.Next();
					}
				}
			}
			
			if(iCurIndex<m_szNeibors.length-1)
				m_szNeibors[iCurIndex+1] = null;
		}
		
		/**
		 * 清空每一个单元上的运动物体个数
		 */
		public function EmptyCell():void
		{
			var iLn:int = m_szCells.length;
			for(var i:int = 0;i<iLn;++i)
			{
				m_szCells[i].EntitySet.Clear();
			}
		}
		
		/**
		 * 位置映射到下标 通过对应的比例
		 */
		public function PositionToIndex(stPos:Vector2d):int
		{
			var index:int = (int)((int)(stPos.nY*m_iNumsY/(m_nSpaceHeight)*m_iNumsX)+(int)(stPos.nX*m_iNumsX/m_nSpaceWidth))
				
			var iLn:int = m_szCells.length; 
			if(index>=iLn)
				index = iLn-1;
			if(index<0)
				index = (index%iLn + iLn)%iLn;
			return index;
		}
		
		/**
		 * 将物体放入属于对应的区域
		 */
		public function AddEntity(stBaseEntity:BaseGameEntity):void
		{
			var idx:int = PositionToIndex(stBaseEntity.Pos);
			m_szCells[idx].EntitySet.PushFront(stBaseEntity);
		}
		
		/**
		 * 更细物体所在区域
		 */
		public function UpdateEntity(stBaseEntity:BaseGameEntity,stOldPos:Vector2d):void
		{
			var iOldIdx:int = PositionToIndex(stOldPos);
			var iNwIdx:int = PositionToIndex(stBaseEntity.Pos);
			
			if(iNwIdx==iOldIdx)
				return;
			m_szCells[iOldIdx].EntitySet.Remove(stBaseEntity);
			m_szCells[iNwIdx].EntitySet.PushFront(stBaseEntity);
		}
		
		public function get Neighbors():Vector.<BaseGameEntity>
		{
			return m_szNeibors;
		}
		
	}
}