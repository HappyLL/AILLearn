package algorithm
{
	/**
	 * 优先队列
	 */
	public class PriorityQueue
	{
		/**优先队列所存量最多50万个体*/
		public static const MAX_PRIORITY_CAPACITY:int = 5000000;
		/**优先队列所存物体的总数*/
		public static var PRIORITY_CAPACITY:int = 100;
		/**内存不足时增加的量**/
		public static const PRIORITY_ADD:int = 40;
		
		
		private var m_stPrioQue:Vector.<*>;
		
		private var m_iSize:int;
		private var m_stFunction:Function;
		
		public function PriorityQueue()
		{
			
		}
		
		/**
		 * 创建优先队列
		 * @param stFunction:重载函数
		 * */
		public function Create(stFunction:Function):void
		{
			if(stFunction==null)
				throw new Error("重载函数不能为空");
			
			m_stFunction = stFunction;
			m_stPrioQue = new Vector.<*>(PRIORITY_CAPACITY<<2);
			m_iSize = 0;
			
		}
		
		/**
		 * @return 当前优先队列的大小 
		 */
		public function Size():int
		{
			return m_iSize;
		}
		
		/**
		 * @return 得到Top元素
		 */
		public function Max():*
		{
			if(Size()==0)
				trace("当前Top值为空")
			return m_stPrioQue[1];
		}
		
		/**
		 * @param stElement: 插入的元素
		 */
		public function Insert(stElement:*):void
		{
			if(stElement==null)
				throw new Error("空值不能插入队列");
			if(m_iSize+1>=PRIORITY_CAPACITY)
			{
				if(!IsCanReManageCapacity())
					return;
				ReManageCapacity();
			}
			m_stPrioQue[++m_iSize] = stElement;
			
			var iLowIndex:int = (m_iSize)>>1;
			var stTmp:*;
			var iNowIndex:int = m_iSize ;
			var i:int = iLowIndex;			
			while(i>0)
			{
				var iTag:int = m_stFunction(stElement,m_stPrioQue[i]);
				//当前左边权值比右边大
				if(iTag==-1)
				{
					stTmp = m_stPrioQue[i];
					m_stPrioQue[i] = stElement;
					m_stPrioQue[iNowIndex] = stTmp;
					iNowIndex = i;
					i>>=1;
					continue;
				}
				return;
			}
		}
		
		/**
		 * @param 删除Top值
		 */
		public function DeleteMax():*
		{
			if(m_iSize==0)
			{
				trace("队列大小为0，返回为空");
				return null;
			}
			
			var stDelete:* = m_stPrioQue[m_iSize];
			var stTmp:*;
			m_stPrioQue[m_iSize] = null;
			m_iSize--;
			var iTag:int;
			var i:int = 1;
			while(i<m_iSize)
			{
				var stLhs:* = m_stPrioQue[i<<1];
				var stRhs:* = m_stPrioQue[(i<<1)+1];
				if(stLhs!=null&&stRhs!=null)
				{
					iTag = m_stFunction(stLhs,stRhs);
					if(iTag==-1)
					{
						iTag = m_stFunction(stDelete,stLhs);
						//左边权值比右边小
						if(iTag>0)
						{
							m_stPrioQue[i] = stLhs;
							i<<=1;
						}
						else
							break;	
					}
					else
					{
						iTag = m_stFunction(stDelete,stRhs);
						if(iTag>0)
						{
							m_stPrioQue[i] = stRhs;
							i = (i<<1)+1;
						}
						else 
							break;
					}
					
				}
				else if(stLhs!=null)
				{
					iTag = m_stFunction(stDelete,stLhs);
					if(iTag>0)
					{
						m_stPrioQue[i] = stLhs;
						i<<=1;
					}
					else
						break;	
				}
				else
					break;
				
			}
			m_stPrioQue[i] = stDelete;
			
		}
		
		private function IsCanReManageCapacity():Boolean
		{
			if(m_iSize+1>MAX_PRIORITY_CAPACITY)
			{
				trace("当前空间已达到最大不能再申请");
				return false;
			}
			
			return true;
		}
		
		/**
		 * 重新分配大小
		 */
		private function ReManageCapacity():void
		{
			PRIORITY_CAPACITY = m_iSize+PRIORITY_ADD;
			if(PRIORITY_CAPACITY>MAX_PRIORITY_CAPACITY)
				PRIORITY_CAPACITY = MAX_PRIORITY_CAPACITY;
			var stPro:Vector.<*> = new Vector.<*>(PRIORITY_CAPACITY<<2);
			for(var i:int = 0;stPro.length;++i)
			{
				if(i<m_stPrioQue.length)
				{
					stPro[i] = m_stPrioQue[i];
					m_stPrioQue[i] = null
				}
				else
					stPro[i] = null;
			}
			
			m_stPrioQue = stPro;
		}
		
	}
}