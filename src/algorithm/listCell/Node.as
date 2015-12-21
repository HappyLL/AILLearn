package algorithm.listCell
{
	/**
	 * 双向列表节点
	 */
	public class Node
	{
		private var m_stPreNode:Node;
		private var m_stNextNode:Node;
		
		private var m_stData:*;
		
		public function Node()
		{
			
		}
		
		public function Next():Node
		{
			return m_stNextNode;
		}
		
		public function Previous():Node
		{
			return m_stPreNode;
		}
		
		public function get PreNode():Node
		{
			return m_stPreNode;
		}
		
		public function set PreNode(value:Node):void
		{
			m_stPreNode = value;
		}
		
		public function get NextNode():Node
		{
			return m_stNextNode;
		}
		
		public function set NextNode(value:Node):void
		{
			m_stNextNode = value;
		}
		
		public function get Data():*
		{
			return m_stData;
		}
		
		public function set Data(value:*):void
		{
			m_stData = value;
		}
		
	}
}