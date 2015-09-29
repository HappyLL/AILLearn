package msg
{
	/**
	 * 消息类
	 */
	public class Telegram
	{
		/**消息发送者*/
		private var m_iSender:int;
		/**消息接收者*/
		private var m_iReceiver:int;
		/**消息内容ID*/
		private var m_iMsg:int;
		/**附加的消息内容*/
		private var m_stAddtionContent:*;
		/**消息发送延时的时间*/
		private var m_iDispatcherTime:Number;
		
		public function Telegram()
		{
			
		}
		
		public function set Sender(value:int):void
		{
			m_iSender = value;
		}
		
		public function get Sender():int
		{
			return m_iSender;
		}
		
		public function set Receiver(value:int):void
		{
			m_iReceiver = value;
		}
		
		public function get Receiver():int
		{
			return m_iReceiver;
		}
		
		public function set Msg(value:int):void
		{
			m_iMsg = value;
		}
		
		public function get Msg():int
		{
			return m_iMsg;
		}
		
		public function set AddtionContent(value:*):void
		{
			m_stAddtionContent = value;
		}
		
		public function get AddtionContent():*
		{
			return m_stAddtionContent;
		}
		
		public function set DispatcherTime(value:Number):void
		{
			m_iDispatcherTime = value;
		}
		
		public function get DispatcherTime():Number
		{
			return m_iDispatcherTime;
		}
		
	}
}