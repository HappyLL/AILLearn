package cellSpacingPartition.cellBox
{
	import vector.Vector2d;

	public class InvertedAABBox2D
	{
		private var m_stTopLeftPt:Vector2d;
		private var m_stRightBtmPt:Vector2d;
		private var m_stCenterPt:Vector2d;
		
		public function InvertedAABBox2D(stTopLftPt:Vector2d,stRightBtmPt:Vector2d)
		{
			m_stTopLeftPt = new Vector2d;
			m_stTopLeftPt.Copy(stTopLftPt);
			
			m_stRightBtmPt = new Vector2d;
			m_stRightBtmPt.Copy(stRightBtmPt);
			
			m_stCenterPt = m_stTopLeftPt.AddVectorRet(m_stRightBtmPt).DivNumberRet(2);	
		}
		
		/**
		 *判断两个矩形是否重叠
		 */
		public function IsOverLappedWith(stBox:InvertedAABBox2D):Boolean
		{
			return !((this.Bottom<stBox.Top)||(this.Right<stBox.Left)||(this.Left>stBox.Right)||(this.Top>stBox.Bottom))		
			
		}
		
		public function get TopLeftPoint():Vector2d
		{
			return m_stTopLeftPt;
		}
		
		public function get RightBtmPoint():Vector2d
		{
			return m_stRightBtmPt;
		}
		
		public function get Top():Number
		{
			return m_stTopLeftPt.nY;
		}
		
		public function get Left():Number
		{
			return m_stTopLeftPt.nX;
		}
		
		public function get Bottom():Number
		{
			return m_stRightBtmPt.nY;
		}
		
		public function get Right():Number
		{
			return m_stRightBtmPt.nX;
		}
		
	}
}