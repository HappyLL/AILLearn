package algorithm
{
	import algorithm.listCell.Node;

	public class List
	{
		private var m_stHeadNode:Node;
		private var m_iLength:int;
		
		public function List()
		{
			m_stHeadNode = CreateNode(null);
			m_iLength = 0;
		}
		
		private function CreateNode(stData:*):Node
		{
			var stNode:Node = new Node;
			stNode.NextNode = null;
			stNode.PreNode = null;
			stNode.Data = stData;
			return stNode;
		}
		
		private function DestroyNode(stNode:Node):void
		{
			stNode.NextNode = null;
			stNode.PreNode = null;
			stNode.Data = null;
			stNode = null;
		}
		
		public function PushFront(stData:*):void
		{
			var value:Node = CreateNode(stData);
			
			value.PreNode = m_stHeadNode;
			value.NextNode = m_stHeadNode.NextNode;
			m_stHeadNode.NextNode = value;
			if(value.NextNode!=null)
				value.NextNode.PreNode = value;
			
			m_iLength++;
		}
		
		public function Remove(stData:*):void
		{
			Erase(Find(stData));
		}
		
		public function Find(stData:*):Node
		{
			var stCurNode:Node = m_stHeadNode;
			while(stCurNode)
			{
				if(stCurNode.Data==stData)
					return stCurNode;
				stCurNode = stCurNode.Next();
			}
			return null;
		}
		
		public function Erase(stNode:Node):void
		{
			if(stNode==null)
				return;
			if(stNode.PreNode)
			{
				stNode.PreNode.NextNode = stNode.NextNode;
			}
			
			if(stNode.NextNode)
			{
				stNode.NextNode.PreNode = stNode.PreNode;
			}
			
			DestroyNode(stNode);
			m_iLength--;
		}
		
		public function Head():Node
		{
			//var stHeadNode:Node = m_stHeadNode;
			return m_stHeadNode;
		}
		
		public function Clear():void
		{
			var stCurNode:Node = m_stHeadNode.NextNode;
			var stTmpNode:Node;
			while(stCurNode)
			{
				stTmpNode = stCurNode;
				stCurNode = stCurNode.Next();
				Erase(stTmpNode);
			}
		}
		
		public function Length():int
		{
			return m_iLength;
		}
		
			
	}
}