package baseGameEntity.behavior
{
	public class SteeringBehaviorInfo
	{
		private static var pIns:SteeringBehaviorInfo;
		/**表示当前没有行为*/
		public static const BEHAVIOR_TYPE_NONE:int = 0x000000;
		/**表示当前的行为是SEEK 靠近*/
		public static const BEHAVIOR_TYPE_SEEK:int = 0x000002;
		/**表示当前的行为是FLEE 离开*/
		public static const BEHAVIOR_TYPE_FLEE:int = 0x000004;
		/**表示当前的行为是ARRIVE 抵达*/
		public static const BEHAVIOR_TYPE_ARRIVE:int = 0x000008;
		/**追逐*/
		public static const BEHAVIOR_TYPE_PURSUIT:int = 0x000010;
		/**逃离*/
		public static const BEHAVIOR_TYPE_EVADE:int = 0x000020;
		/**徘徊*/
		public static const BEHAVIOR_TYPE_WANDER:int = 0x000040;
		/**避开障碍物*/
		public static const BEHAVIOR_TYPE_OBSTACLE_AVOIDANCE:int = 0x000080;
		/**避开墙*/
		public static const BEHAVIOR_TYPE_WALL_AVOIDANCE:int = 0x0000100;
		/**插入*/
		public static const BEHAVIOR_TYPE_INTERPOSE:int = 0x0000200;
		/**隐藏*/
		public static const BEHAVIOR_TYPE_HIDE:int = 0x0000400;
		/**路径跟随*/
		public static const BEHAVIOR_TYPE_FOLLOW_PATH:int = 0x0000800;
		/**保持一定偏移的追逐*/
		public static const BEHAVIOR_TYPE_OFFSET_PURSUIT:int = 0x0001000;
		/**群集行为的分离*/
		
		/**Arrive 的三种到达模式*/
		public static const DECELERATION_SLOW:int = 3;
		public static const DECELERATION_NORMAL:int = 2;
		public static const DECELERATION_FAST:int = 1;
		
		/**检测盒的长度*/
		public static const BOXLENGTH:int = 25;
		
		/**当前的触须长度*/
		public var m_dWallDetectionFeelerLength:int = 30;
		/**当前路劲跟随 中运动物体与到达点的误差距离 距离<该距离则说明已经到达此点了*/
		public var m_dWayPointWeakDisSq:Number = 10;
		
		/**当前隐藏包围半径的距离*/
		public static const DiSTANCE_FROM_BOUNDARY:Number = 30;
		
		/**SEEK的比例因子*/
		public var m_nWeightSeek:Number = 1.0; 
		/**WANDER的比例因子*/
		public var m_nWeightWander:Number = 1.0;
		/**ObstacleAvoidance比例因子*/
		public var m_nWeightObstacleAvoidance:Number = 2.0;
		/**WallAvoidance比例因子*/
		public var m_nWeightWallAvoidance:Number = 1.0;
		/**Interpose的比例因子*/
		public var m_nWeightInterpose:Number = 1.0;
		/**Hide的比例因子*/
		public var m_nWeightHide:Number = 1.0;
		/**FollowPath的比例因子*/
		public var m_nWeightFollowPath:Number = 1.0;
		/**OFFSETPursuit的比例因子*/
		public var m_nWeightOffsetPursuit:Number = 1.0;
		
		public function SteeringBehaviorInfo()
		{
			if(pIns)
				throw new Error("单例错误");
		}
		
		public static function Get():SteeringBehaviorInfo
		{
			return pIns||(pIns = new SteeringBehaviorInfo);
		}
		
		public function On(iState:int,iNowBeha:int):Boolean
		{
			if(iState&iNowBeha)
				return true;

			return false;
		}
		
		
	}
}