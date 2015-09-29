package tick
{
	import flash.utils.getTimer;
	
	//import mx.core.IFactory;

	/**
	 * 管理游戏的所有时钟信号
	 */
	public class Ticker implements ITickSupplier
	{
		/**游戏开始的时间(毫秒)*/
		private var m_nStartMS:Number;
		
		/**更新周期(毫秒)*/
		private var m_uiMSPerTick:uint;
		
		/**上次更新的时间(毫秒)*/
		private var m_nLastUpdateTime:Number;
		
		/**帧率*/
		private var m_uiFrameRate:uint;
		
		/**当前的Tick计数*/
		private var m_uiTickCount:uint;
		
		/**普通的时钟信号，处理不需要同步的逻辑*/
		private var m_vNormalTickList:Vector.<ITick>;
		
		/**时钟信号是否启用*/
		private var m_bIsRuning:Boolean;
		
		/**
		 * 构造函数
		 * @param uiFrameRate 游戏的帧率
		 * @param uiFixedTickLength 管理类的数量
		 */
		public function Ticker(uiFrameRate:uint)
		{
			Start();
			
			m_uiFrameRate		= uiFrameRate;
			m_uiMSPerTick		= 1000.0 / uiFrameRate;
			m_vNormalTickList	= new Vector.<ITick>;
		}
		
		/**
		 * 开始计时
		 */
		public function Start():void
		{
			m_nStartMS			= getTimer();
			m_nLastUpdateTime	= m_nStartMS;
			m_uiTickCount		= 0;
			m_bIsRuning			= true;
		}
		
		/**
		 * 停止时钟信号
		 */
		public function Stop():void
		{
			m_bIsRuning = false;
		}
		
		/**
		 * 继续提供时钟信号
		 */
		public function Continue():void
		{
			m_bIsRuning = true;
		}
		
		/**
		 * 添加一个普通的更新信号
		 * @param tick 需要更新信号的对象
		 */
		public function AddNormalTick(addTick:ITick):void
		{
			var index:int = m_vNormalTickList.indexOf(addTick);
			if (index < 0)
			{
				addTick.StartTick();
				m_vNormalTickList.push(addTick);
			}
			else
			{
				trace(addTick.GetName() + "被重复添加到KeyTick。");
			}
		}
		
		/**
		 * 从普通时钟信号中删除对应对象
		 * @param removeTick 需要删除的对象
		 */
		public function RemoveNormalTick(removeTick:ITick):void
		{
			var index:int	= m_vNormalTickList.indexOf(removeTick);
			var len:int		= m_vNormalTickList.length;
			
			if (index >= 0)
			{
				removeTick.EndTick();
				--len;
				m_vNormalTickList[index] = m_vNormalTickList[len];
			}
			
			m_vNormalTickList.length = len;
		}
		
		/**
		 * 获得当前帧速率
		 */
		public function GetFrameRate():uint
		{
			return m_uiFrameRate;
		}
		
		/**
		 * 外部的信号量，由GOW提供，监听ENTER_FRAME事件触发此信号 
		 */
		public function Signal():void
		{
			if(false == m_bIsRuning)
			{
				return;
			}
			
			var time:Number = getTimer() - m_uiMSPerTick;
			
			if(time < m_nLastUpdateTime)
			{
				return;
			}
			
			//刷新一次
			m_nLastUpdateTime += m_uiMSPerTick;
			
			DoTick();
			
			while(time >= m_nLastUpdateTime)
			{
				m_nLastUpdateTime += m_uiMSPerTick;
				DoTick();
			}
		}
		
		/**
		 * 取当前更新了多少个tickCount 
		 * @return 	更新了多少次
		 */
		public function GetTickCount():uint
		{
			return m_uiTickCount;
		}
		
		/**
		 * 送出一次时钟信号
		 */
		private function DoTick():void
		{
			++m_uiTickCount;
			
			var t:ITick;
			//coomon last
			for each(t in m_vNormalTickList)
			{
				if (t.IsTickActive())
				{
					t.Tick(m_uiTickCount);
				}
			}
		}
		
	}
}