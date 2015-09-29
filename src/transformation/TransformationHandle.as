package transformation
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import vector.Vector2d;
	/**
	 * as3的矩阵真他妈的坑爹
	 * as3的矩阵运算:
	 * [x,y,1][a,b,0] 
	 *        [c,d,0]
	 *        [tx,ty,1]
	 */      
	public class TransformationHandle
	{
		
		private static var pIns:TransformationHandle; 
		
		public function TransformationHandle()
		{
			if(pIns)
				throw new Error('单例错误')
		}
		
		public static function Get():TransformationHandle
		{
			return pIns||(pIns = new TransformationHandle);
		}
		
		/**
		 * 将点stPoint转化为以stAgentPosition(当前坐标下)为原点局部坐标系
		 * @param stAgentHeading:要转化坐标系的指向x坐标的向量
		 * @param stAgentSide:要转化坐标系的指向y坐标的向量
		 * @param stAgentPosition:局部标系下的原点(传入的值为未转化过得点)
		 * @return 返回当前局部坐标系下的坐标
		 */
		public function PointToLocalSpace(stPoint:Vector2d,stAgentHeading:Vector2d,stAgentSide:Vector2d,stAgentPosition:Vector2d):Vector2d
		{
			var stRetPos:Vector2d = new Vector2d(stPoint.nX,stPoint.nY);
			var nTx:Number = -stAgentHeading.Dot(stAgentPosition);
			var nTy:Number = -stAgentSide.Dot(stAgentPosition)
			var stMatrix:Matrix = new Matrix(stAgentHeading.nX,stAgentSide.nX,stAgentHeading.nY,stAgentSide.nY,nTx,nTy)
			var stPt:Point = stMatrix.transformPoint(stRetPos);
			stRetPos.nX = stPt.x;
			stRetPos.nY = stPt.y;
			return stRetPos;
		}
		
		/**
		 * 将当前向量转化为局部坐标系下的向量
		 * @param stVect:要转化的向量
		 */
		public function VectorToLocalSpace(stVect:Vector2d,stAgentHeading:Vector2d,stAgentSide:Vector2d):Vector2d
		{
			var stRetVec:Vector2d = new Vector2d(stVect.nX,stVect.nY);
			var stMatrix:Matrix = new Matrix(stAgentHeading.nX,stAgentSide.nX,stAgentHeading.nY,stAgentSide.nY)
			var stPt:Point = stMatrix.transformPoint(stRetVec);
			stRetVec.nX = stPt.x;
			stRetVec.nY = stPt.y;
			return stRetVec;
		}
		
		/**
		 * 将点stPoint转化为以stAgentPosition(当前坐标下)为原点坐标系(父类坐标系)
		 * @param stAgentHeading:要转化坐标系的指向x坐标的向量
		 * @param stAgentSide:要转化坐标系的指向y坐标的向量
		 * @param stAgentPosition:局部标系下的原点(传入的值为未转化过得点)
		 * @return 返回当前父类坐标系下的坐标(默认世界也是他的父类)
		 */
		public function PointToParentSpace(stPoint:Vector2d,stAgentHeading:Vector2d,stAgentSide:Vector2d,stAgentPosition:Vector2d):Vector2d
		{
			var stRetPos:Vector2d = new Vector2d(stPoint.nX,stPoint.nY)
			var nTx:Number = stAgentPosition.nX;
			var nTy:Number = stAgentPosition.nY;
			var stMatrix:Matrix = new Matrix(stAgentHeading.nX,stAgentHeading.nY,stAgentSide.nX,stAgentSide.nY,nTx,nTy)
			var stPt:Point = stMatrix.transformPoint(stRetPos);
			stRetPos.nX = stPt.x;
			stRetPos.nY = stPt.y;	
			return stRetPos;
		}
		
		/**
		 * 将当前向量转化为父类坐标系下的向量(默认世界)
		 * @param stVect:要转化的向量
		 */
		public function VectorToParentSpace(stVect:Vector2d,stAgentHeading:Vector2d,stAgentSide:Vector2d):Vector2d
		{
			var stRetVec:Vector2d = new Vector2d(stVect.nX,stVect.nY);
			var stMatrix:Matrix = new Matrix(stAgentHeading.nX,stAgentHeading.nY,stAgentSide.nX,stAgentSide.nY)
			var stPt:Point = stMatrix.transformPoint(stRetVec);
			stRetVec.nX = stPt.x;
			stRetVec.nY = stPt.y;
			return stRetVec;
		}
		
	}
}