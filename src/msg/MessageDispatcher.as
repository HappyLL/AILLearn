package msg
{
	import algorithm.PriorityQueue;
	
	import baseGameEntity.BaseGameEntity;
	import baseGameEntity.EntityManager;
	
	public class MessageDispatcher
	{
		private static var pIns:MessageDispatcher;
		
		private var m_stPrioQuene:PriorityQueue; 
		
		public function MessageDispatcher()
		{
			m_stPrioQuene = new PriorityQueue;	
			m_stPrioQuene.Create(PrioInerFunction);
		}
		
		public static function Get():MessageDispatcher
		{
			return pIns||(pIns = new MessageDispatcher);
		}
		
		/**
		 * 发送消息
		 * @param stBaseEntity:BaseGameEntity 接收消息体
		 * @param stTelegram:Telegram 消系体
		 */
		public function Discharge(stBaseEntity:BaseGameEntity,stTelegram:Telegram):void
		{
			if(stBaseEntity==null)
				throw new Error("接收处理消息的人为空");
			if(!stBaseEntity.HandleMessage(stTelegram))
			{
				trace("当前状态 对应对象没有相应的处理机制");
			}
		}
		
		/**
		 * 创建消息
		 * @param nDelay:Number 延时多少秒发送消息
		 * @param iSender:int 发送者
		 * @param iReceiver:int 接收者
		 * @oaram iMsg:int 消息内容ID
		 * @param stExtInfo:* 额外附加的消息内容
		 */
		public function DispatcherMessage(nDelay:Number,iSender:int,iReceiver:int,iMsg:int,stExtInfo:*):void
		{
			var stTelegram:Telegram = new Telegram;
			stTelegram.Sender = iSender;
			stTelegram.Receiver = iReceiver;
			stTelegram.Msg = iMsg;
			stTelegram.AddtionContent = stExtInfo;
			
			if(nDelay<0.00001)
			{
				
				stTelegram.DispatcherTime = 0;	
				var stBaseEntity:BaseGameEntity = EntityManager.Get().GetEntityFromID(iReceiver);
				
				Discharge(stBaseEntity,stTelegram);
			}
			else 
			{
				//延时发送消息
				stTelegram.DispatcherTime = (new Date()).getTime() + nDelay;
				m_stPrioQuene.Insert(stTelegram);
			}
		}
		/**
		 * 延时发送消息
		 */
		public function DispatcherDelayMessage():void
		{
			var stDate:Date = new Date;
			var iTime:Number = stDate.time;
			while(m_stPrioQuene.Size())
			{
				var stMax:Telegram = m_stPrioQuene.Max() as Telegram;
				if(stMax==null)
					return;
				if(stMax.DispatcherTime<=iTime)
				{
					m_stPrioQuene.DeleteMax();
					Discharge(EntityManager.Get().GetEntityFromID(stMax.Receiver),stMax);
				}
				else
					return;
			}
		}
		
		/**
		 * 优先队列所对应的函数
		 */
		private function PrioInerFunction(stLhsT:Telegram,stRhsT:Telegram):int
		{
			if(stLhsT.DispatcherTime<stRhsT.DispatcherTime)
			{
				return -1;
			}
				
			else if(stLhsT.DispatcherTime == stRhsT.DispatcherTime)
			{
				return 0;
			}
			
			return 1;
			
		}
		
	}
}