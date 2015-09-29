package baseGameEntity.smoother
{
	/**
	 * 这个类的作用
	 * 其成员变量中有一个是每次更新时朝向的集合
	 * 目的是为类求出朝向的集合的均值向量
	 */
	public class Smoother
	{
		private var m_szHistory:Vector.<*>;
		private var m_iNextUpdateSlot:int;
		private var m_stZeroValue:*;
		private var m_stT:Class;
		/**
		 * @param T:所要定义的成员的类型
		 * @iSampleSize 定义集合的大小
		 * @ZeroValue:表示当前最初值
		 */
		public function Smoother(T:Class,iSampleSize:int,ZeroValue:*)
		{
			m_stT = T;
			m_szHistory = new Vector.<T>(iSampleSize);
			for(var i:int = 0;i<m_szHistory.fixed;++i)
			{
				m_szHistory[i] = ZeroValue;
			}
			
			m_stZeroValue = ZeroValue;
			m_iNextUpdateSlot = 0;
			
		}
		
		public function Update(stMostRecentValue:*):*
		{
			m_szHistory[m_iNextUpdateSlot++] = stMostRecentValue;
			if(m_iNextUpdateSlot == m_szHistory.length)
				m_iNextUpdateSlot = 0;
			var sum:* = m_stZeroValue;
			
			for(var i:int = 0;i<m_szHistory.length;++i)
			{
				sum = sum.AddVector(m_szHistory[i]);
			}
			return sum.DivNumberRet(m_szHistory.length*1.0)
			
		}
		
	}
}