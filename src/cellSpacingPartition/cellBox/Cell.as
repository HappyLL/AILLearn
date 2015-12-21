package cellSpacingPartition.cellBox
{
	import algorithm.List;

	import vector.Vector2d;

	public class Cell
	{
		private var m_stInvBox2D:InvertedAABBox2D;
		
		private var m_szEntity:List;
		
		public function Cell(stTopLeftPt:Vector2d,stRigBtmPt:Vector2d)
		{
			m_szEntity = new List;
			m_stInvBox2D = new InvertedAABBox2D(stTopLeftPt,stRigBtmPt);
		}
		
		public function get InvBox2D():InvertedAABBox2D
		{
			return m_stInvBox2D;
		}
		
		public function get EntitySet():List
		{
			return m_szEntity;
		}
		
	}
}