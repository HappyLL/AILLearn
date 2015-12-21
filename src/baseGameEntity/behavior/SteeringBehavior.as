package baseGameEntity.behavior
{
	import flash.geom.Point;
	
	import baseGameEntity.BaseGameEntity;
	import baseGameEntity.vehicle.Vehicle;
	
	import path.Path;
	
	import transformation.TransformationHandle;
	
	import vector.Vector2d;
	
	public class SteeringBehavior
	{
		private var m_stVehicle:Vehicle;
		private var m_stSteeringForce:Vector2d;
		private var m_stPath:Path;
		private var m_iMask:int;
		private var m_stFocusVec:Vehicle;
		private var m_stInterposVecLhs:Vehicle;
		private var m_stInterposVecRhs:Vehicle;
		private var m_stHideVec:Vehicle;
		private var m_stLeader:Vehicle;
		private var m_stOffsetPt:Vector2d;
		private var m_bCellSpaceOn:Boolean;
		
		/**当前wander圈的半径*/
		private var m_nWanderRadius:Number;
		/**当前Vehicle与Wander圈的距离*/
		private var m_nWanderDistance:Number;
		/**当前每帧目标圈(目标圈锁在Wander圈上)的偏移距离*/
		private var m_nWanderJitter:Number;
		/**目标圈的位置*/
		private var m_stWanderTarget:Vector2d;
		
		private var m_nBoxLength:Number;
		
		private var m_dViewDistance:Number;
		
		
		public function SteeringBehavior(stVeicle:Vehicle)
		{
			m_stVehicle = 	stVeicle;
			m_stSteeringForce = new Vector2d;
			m_iMask = 0;
			m_stFocusVec = null;
			m_nWanderRadius = 10;
			m_nWanderDistance = 60;
			m_nWanderJitter = 60;
			m_stWanderTarget = new Vector2d(m_nWanderRadius*Math.SQRT1_2,m_nWanderRadius*Math.SQRT1_2);
			m_dViewDistance = m_stVehicle.BRadius;
			m_bCellSpaceOn = true;
		}
		
		/**
		 * Calcuate:计算当前物体受到的合力
		 * @return:返回的是合力
		 */
		public function Calculate():Vector2d
		{
			m_stSteeringForce.Zero();
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_SEPARATION)||SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_ALIGNMENT)
				||SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_COHESION))
			{
				if(!m_bCellSpaceOn)				
					m_stVehicle.World.TagVehiclesWithinViewRange(m_stVehicle,m_dViewDistance);
				else
					m_stVehicle.World.CellSpace.CalculateNeighbors(m_stVehicle.Pos,m_dViewDistance);
			}
			
			m_stSteeringForce = CalculatePrioritized();
			
			return new Vector2d(m_stSteeringForce.nX,m_stSteeringForce.nY);
		}
		
		public function IsSpacePartitioningOn():Boolean
		{
			return m_bCellSpaceOn;
		}
		
		public function OrMask(value:int):void
		{
			m_iMask|=value;
		}
		
		/**
		 * 靠近
		 * Seek:可以算出要给物体加的速度使得当前物体的速度与要给物体加的速度的合速度的方向指向目标点
		 * @param: stTargetPos 要达到的目标点
		 * @return 要给物体加的速度
		 */
		public function Seek(stTargetPos:Vector2d):Vector2d
		{
			//合力
			var stResultVel:Vector2d = Vector2d.Vect2DNormalize(stTargetPos.SubVectorRet(m_stVehicle.Pos));
			stResultVel.MulNumber(m_stVehicle.MaxSpeed);
			//返回的是要加给物体的速度
			return (stResultVel.SubVectorRet(m_stVehicle.Velocity));
		}
		
		/**
		 * 离开
		 * Flee:可以算出当前离开物体的力与Seek相反
		 * @param: stTargetPos 要达到的目标点
		 * @return 要给物体加的速度
		 */
		public function Flee(stTargetPos:Vector2d):Vector2d
		{
			//合速度
			var stResultVel:Vector2d = Vector2d.Vect2DNormalize(stTargetPos.SubVectorRet(m_stVehicle.Pos));
			stResultVel.MulNumber(m_stVehicle.MaxSpeed);
			//返回的是要加给物体的速度
			return (m_stVehicle.Velocity.SubVectorRet(stResultVel));
		}
		
		/**
		 * 抵达
		 * Arrive:与Seek不同到达目的地后不再做误差偏移
		 * @param: stTargetPos:目标点
		 * @param: iDeceleration 减速的模式
		 * @return 要加给物体的速度
		 */
		public function Arrive(stTargetPos:Vector2d,iDeceleration:int):Vector2d
		{
			var stResultVel:Vector2d = stTargetPos.SubVectorRet(m_stVehicle.Pos);
			var nDist:Number = stResultVel.Length();
			if(nDist>0)
			{
				var nDecelerationWeaker:Number = 0.3;
				var nSpeed:Number = (nDist/(iDeceleration*1.0*nDecelerationWeaker));
				nSpeed = Math.min(nSpeed,m_stVehicle.MaxSpeed);
				stResultVel = stResultVel.MulNumberRet(nSpeed).DivNumberRet(nDist);
				return (stResultVel.SubVectorRet(m_stVehicle.Velocity));
			}
			return  new Vector2d(0,0);
		}
		
		/**
		 * 追逐
		 * Pursuit: 通过目标物体当前的速度来判断当前物体下一步的位移，以此来追逐
		 * @param : stEvade:追逐的目标点
		 * @return 要加给物体的速度
		 */
		public function Pursuit(stEvade:Vehicle):Vector2d
		{
			if(stEvade==null)
				return new Vector2d(0,0);
			var stToEvade:Vector2d = stEvade.Pos.SubVectorRet(m_stVehicle.Pos);
			
			//首先判断是否为正面
			var nDot:Number = stToEvade.Dot(m_stVehicle.Heading);
			var nDotRad:Number = -m_stVehicle.Heading.Dot(stEvade.Heading);
			var stNewPos:Vector2d = new Vector2d(stEvade.Pos.nX,stEvade.Pos.nY) 
			//判断如果是正面
			if(nDot>=0&&nDotRad<-0.95)
			{
				return Seek(stNewPos);
			}
			//否则不是正面则要计算时间(与距离成正比 与速度和成反比)
			var nLastTime:Number = stToEvade.Length()/(stEvade.Speed+m_stVehicle.MaxSpeed);
			//计算出预测的位置
			stNewPos.AddVector(stEvade.Velocity.MulNumberRet(nLastTime))
			return Seek(stNewPos)
			
		}
		
		/**
		 * 逃离
		 * Evade: 预测目标物体下一步的位移并Flee
		 * @param: pursuer:逃离的目标点
		 * @return 要加给物体的速度 
		 */
		public function Evade(stPursuer:Vehicle):Vector2d
		{
			if(stPursuer==null)
				return new Vector2d(0,0)
			var stToPursuer:Vector2d = stPursuer.Pos.SubVectorRet(m_stVehicle.Pos);
			
			//逃离不需要判断正面
			var stNewPos:Vector2d = new Vector2d(stPursuer.Pos.nX,stPursuer.Pos.nY);
			
			var nLastTime:Number = stToPursuer.Length()/(stPursuer.Speed+m_stVehicle.MaxSpeed)
			stNewPos.AddVector(stPursuer.Velocity.MulNumberRet(nLastTime));
			return Flee(stNewPos);
		}
		
		/**
		 * 徘徊
		 * 
		 */
		public function Wander():Vector2d
		{
			m_stWanderTarget.AddVector(new Vector2d(Vector2d.RandomClamped()*m_nWanderJitter,Vector2d.RandomClamped()*m_nWanderJitter));
			m_stWanderTarget.Normalize();
			m_stWanderTarget.MulNumber(m_nWanderRadius);
			var stNewVector2d:Vector2d = new Vector2d(m_nWanderDistance,0);
			var stTargetPos:Vector2d = stNewVector2d.AddVectorRet(m_stWanderTarget);
			//			var stPt:Point = new Point;
			//			stPt.x = stTargetPos.nX;stPt.y = stTargetPos.nY;
			//			stPt= m_stVehicle.localToGlobal(stPt);
			stTargetPos = TransformationHandle.Get().PointToParentSpace(stTargetPos,m_stVehicle.Heading,m_stVehicle.Side,m_stVehicle.Pos);
			return stTargetPos.SubVectorRet(m_stVehicle.Pos);
		}
		
		/**
		 * 避开障碍物
		 * @param szObstacle 当前的障碍物数组
		 */
		public function ObstacleAvoidance(szVehicle:BaseGameEntity):Vector2d
		{
			//检测盒的长度与当前所获得的速率成正比
			m_nBoxLength = SteeringBehaviorInfo.BOXLENGTH*(1+m_stVehicle.Speed/m_stVehicle.MaxSpeed);
			//检测在检测盒的边缘半径下 有多少障碍物与碰触
			m_stVehicle.World.TagObstaclesWithinViewRange(m_stVehicle,m_nBoxLength);
			
			var stClosedObstacle:BaseGameEntity = null;
			var stClosedPoint:Point = new Point;
			var nClosedDistance:Number = Infinity;
			
			//var szRetTagBaseEt:Vector.<BaseGameEntity> = new Vector.<BaseGameEntity>;
			var szOrignTagBaseEt:Vector.<BaseGameEntity> = m_stVehicle.World.ObstacleSet;
			
			var stLocalPt:Vector2d = new Vector2d;
			var nNowDis:Number;
			var nExpandRadius:Number;
			var nX:Number
			for(var i:int = 0;i<szOrignTagBaseEt.length;++i)
			{
				if(szOrignTagBaseEt[i].IsTagged())
				{
					stLocalPt.nX = szOrignTagBaseEt[i].x;
					stLocalPt.nY = szOrignTagBaseEt[i].y;
					stLocalPt = TransformationHandle.Get().PointToLocalSpace(stLocalPt,m_stVehicle.Heading,m_stVehicle.Side,m_stVehicle.Pos)//m_stVehicle.globalToLocal(stLocalPt);
					nExpandRadius = m_stVehicle.BRadius+szOrignTagBaseEt[i].BRadius
					if(stLocalPt.x>=0&&Math.abs(stLocalPt.y)<(nExpandRadius))
					{
						nNowDis = Math.sqrt(nExpandRadius*nExpandRadius - stLocalPt.y*stLocalPt.y);
						nX = stLocalPt.x - nNowDis;
						if(nX<=0)
							nX = stLocalPt.x+nNowDis;
						if(nClosedDistance>nX)
						{
							nClosedDistance = nX;
							stClosedObstacle = szOrignTagBaseEt[i];
							stClosedPoint.x = stLocalPt.x;
							stClosedPoint.y = stLocalPt.y;
						}
						
					}
				}
			}
			
			var stForce:Vector2d = new Vector2d(0,0);
			if(stClosedObstacle)
			{
				//距离越近产生的侧向力就越强
				var nMutliper:Number = 1 + (m_nBoxLength - stClosedPoint.x)/(m_nBoxLength);
				stForce.nY = (stClosedObstacle.BRadius - stClosedPoint.y)*nMutliper;
				var nBreakWeaight:Number = 0.2;
				stForce.nX = (stClosedObstacle.BRadius - stClosedPoint.x)*nBreakWeaight;
				
				stForce = TransformationHandle.Get().VectorToParentSpace(stForce,m_stVehicle.Heading,m_stVehicle.Side)
				
				return stForce;
			}
			
			
			
			return stForce;
		}
		
		/**
		 * 避开墙壁
		 * 要判断当前墙壁的法线与反弹力是否在同一方向
		 */
		public function WallObstacle():Vector2d
		{
			//为移动物体创造触须
			m_stVehicle.CreateFeels();
			
			var nNowDis:Number;
			var nClosedDis:Number = Infinity;
			var stClosedPoint:Vector2d;
			var stNowPoint:Vector2d = new Vector2d;
			var stForce:Vector2d = new Vector2d(0,0);
			
			var iWallIsExsit:int;
			var iFeelLen:int = m_stVehicle.Feels.length;
			var iWall2DLen:int = m_stVehicle.World.Wall2DSet.length;
			for(var i:int = 0;i<iFeelLen;++i)
			{
				iWallIsExsit = -1;
				for(var j:int = 0;j<iWall2DLen;++j)
				{
					//判断是否相交
					//求出当前交点到运动物体的距离然后比较
					var nD:Number = Vector2d.LineIntersection2D(m_stVehicle.Pos,m_stVehicle.Feels[i],
						m_stVehicle.World.Wall2DSet[j].From,m_stVehicle.World.Wall2DSet[j].To,stNowPoint);
					if(nD==-1)
						continue;
					if(nClosedDis>nD)
					{
						nClosedDis = nD;
						iWallIsExsit = j;
						stClosedPoint = stNowPoint;
					}
					
				}
				
				if(iWallIsExsit==-1)
					continue;
				var stOverShoot:Vector2d = stClosedPoint.SubVectorRet(m_stVehicle.Feels[i]);
				//判断当前反弹力是否和当前的墙壁法向量在同一方向
				var nDotNums:Number = Vector2d.Vect2DNormalize(stOverShoot).Dot(m_stVehicle.World.Wall2DSet[iWallIsExsit].Normal);
				if(nDotNums<0)
					nDotNums = -1;
				else 
					nDotNums = 1;	
				stForce = (m_stVehicle.World.Wall2DSet[iWallIsExsit].Normal.MulNumberRet(nDotNums)).MulNumberRet(stOverShoot.Length())
			}
			return stForce;
			
		}
		/**
		 * 插入
		 * 移向运动两个物体的终点
		 * @param stAgentLhs:要插入的物体A
		 * @param stAgentRhs:要插入的物体B
		 */
		public function Interpose(stAgentLhs:Vehicle,stAgentRhs:Vehicle):Vector2d
		{
			
			
			var stMidPt:Vector2d = Vector2d.Vect2DSegmentMidPoint(stAgentLhs.Pos,stAgentRhs.Pos);
			
			var nDis:Number = stMidPt.Distance(m_stVehicle.Pos);
			
			var nT:Number = nDis/m_stVehicle.MaxSpeed;
			
			var stPtLhs:Vector2d = stAgentLhs.Pos.AddVectorRet(stAgentLhs.Velocity.MulNumberRet(nT));
			var stPtRhs:Vector2d = stAgentRhs.Pos.AddVectorRet(stAgentRhs.Velocity.MulNumberRet(nT));
			
			stMidPt = Vector2d.Vect2DSegmentMidPoint(stPtLhs,stPtRhs);
			
			return Arrive(stMidPt,SteeringBehaviorInfo.DECELERATION_NORMAL);
		}
		
		private function GetHidingPosition(target:Vehicle , obs:BaseGameEntity,obsR:Number):Vector2d
		{
			var nDis:Number = obsR+SteeringBehaviorInfo.DiSTANCE_FROM_BOUNDARY;
			var stNorVec:Vector2d = Vector2d.Vect2DNormalize(obs.Pos.SubVectorRet(target.Pos));
			stNorVec.MulNumber(nDis);
			return obs.Pos.AddVectorRet(stNorVec);
		}
		
		/**
		 * 隐藏 当能早到隐藏点时 求最近隐藏点 并Arrive 当不能时 直接逃离
		 * @param target:Vehicle 表示当前的'猎人'
		 * @param szObstacle:BaseGameEntityInfo 表示当前的障碍物集合
		 */
		public function Hide(target:Vehicle,szObstacle:Vector.<BaseGameEntity>):Vector2d
		{
			var nDistance:Number = Infinity;
			var stHidePoint:Vector2d = new Vector2d;
			
			var stNowHidePoint:Vector2d;
			var nNowDis:Number;
			for(var i:int = 0;i<szObstacle.length;++i)
			{
				stNowHidePoint = GetHidingPosition(target , szObstacle[i],szObstacle[i].BRadius)
				nNowDis = m_stVehicle.Pos.DistanceSq(stNowHidePoint)
				
				if(nNowDis<nDistance)
				{
					nDistance = nNowDis;
					stHidePoint.nX = stNowHidePoint.nX;
					stHidePoint.nY = stNowHidePoint.nY;
				}
				
			}
			
			if(nDistance==Infinity)
			{
				return Evade(target);
			}
			
			return Arrive(stHidePoint,SteeringBehaviorInfo.DECELERATION_FAST)
			
		}
		
		/**
		 *路劲跟随  
		 *首先判断当前的初始点是否离运动物体很近 如果很近 则 直接追寻下一个点
		 *如果当前未完成 则 用Seek 否则用 Arrive
		 * @param stPath 表示当前的路劲
		 * @return
		 */
		public function FollowPath(stPath:Path):Vector2d
		{
			if(!m_stPath.visible)
				return new Vector2d(0,0)
			var nDis:Number = m_stVehicle.Pos.DistanceSq(stPath.CurrentWayPoint);
			if(nDis<SteeringBehaviorInfo.Get().m_dWayPointWeakDisSq)
				stPath.SetNextWayPoint();
			if(!stPath.IsFinished())
				return Seek(stPath.CurrentWayPoint)
			else 
				return Arrive(stPath.CurrentWayPoint,SteeringBehaviorInfo.DECELERATION_NORMAL)
		}
		
		/**
		 * 保持一定距离的偏移
		 * @param stLeader:Vehicle
		 * @param stOffsetPt:以领头为原点的局部坐标系的偏移位置
		 */
		public function OffsetPursuit(stLeader:Vehicle,stOffsetPt:Vector2d):Vector2d
		{
			var stWorldOffsetPos:Vector2d = TransformationHandle.Get().PointToParentSpace(stOffsetPt,stLeader.Heading,stLeader.Side,stLeader.Pos);
			
			var nDis:Number = stWorldOffsetPos.Distance(m_stVehicle.Pos);
			var nTs:Number = (nDis)/(m_stVehicle.MaxSpeed+stLeader.Speed);
			
			return Arrive(stWorldOffsetPos.AddVectorRet(stLeader.Velocity.MulNumberRet(nTs)),SteeringBehaviorInfo.DECELERATION_FAST)
		}
		
		/**
		 * Separation 分离
		 * 求得是相互的反作用力的合力
		 * @param szNeighbors 附近的运动的物体
		 */
		public function Separation(szNeighbors:Vector.<Vehicle>):Vector2d
		{
			var stForce:Vector2d = new Vector2d;
			var stAddForce:Vector2d;
			var iLn:int = szNeighbors.length
			
			for(var i:int = 0;i<iLn;++i)
			{
				if(szNeighbors[i].IsTagged()&&(szNeighbors[i]!=m_stVehicle))
				{
					
					stAddForce = m_stVehicle.Pos.SubVectorRet(szNeighbors[i].Pos);
					var nDis:Number = stAddForce.Length();
					if(nDis==0)
						continue;
					stAddForce = Vector2d.Vect2DNormalize(stAddForce).DivNumberRet(nDis);
					stForce.AddVector(stAddForce);
				}
			}
			
			return stForce;
		}
		
		public function SeparationPlus(szNeighbors:Vector.<BaseGameEntity>):Vector2d
		{
			var stForce:Vector2d = new Vector2d;
			var stAddForce:Vector2d;
			for(var i:int = 0;i<szNeighbors.length&&szNeighbors[i]!=null;++i)
			{
				stAddForce = m_stVehicle.Pos.SubVectorRet(szNeighbors[i].Pos);
				var nDis:Number = stAddForce.Length();
				if(nDis==0)
					continue;
				stAddForce = Vector2d.Vect2DNormalize(stAddForce).DivNumberRet(nDis);
				stForce.AddVector(stAddForce);
			}
			return stForce;
		}
		
		/**
		 * Alignment
		 * 默认合力方向为合速度方向 所以需要减去当前无图的速度朝向 这样的话得打的就是分力 且得到的就是合力方向
		 * @param szNeighbors 附近运动的物体
		 */
		public function Alignment(szNeighbors:Vector.<Vehicle>):Vector2d
		{
			var szNowHeading:Vector2d = new Vector2d;
			var iNowHeadingCount:int = 0;
			var iLn:int = szNeighbors.length;
			
			for(var i:int = 0;i<iLn;++i)
			{
				if(szNeighbors[i].IsTagged()&&szNeighbors[i]!=m_stVehicle)
				{
					szNowHeading.AddVector(szNeighbors[i].Heading);
					iNowHeadingCount++;
				}
			}
			
			if(iNowHeadingCount>0)
			{
				szNowHeading.DivNumber(iNowHeadingCount);
				szNowHeading.SubVector(m_stVehicle.Heading);
			}
			return szNowHeading;
		}
		
		public function AlignmentPlus(szNeighbors:Vector.<BaseGameEntity>):Vector2d
		{
			var szNowHeading:Vector2d = new Vector2d;
			var iNowHeadingCount:int = 0;
			
			for(var i:int = 0;i<szNeighbors.length&&szNeighbors[i]!=null;++i)
			{
				szNowHeading.AddVector(szNeighbors[i].Heading);
				iNowHeadingCount++;
			}
			
			if(iNowHeadingCount>0)
			{
				szNowHeading.DivNumber(iNowHeadingCount);
				szNowHeading.SubVector(m_stVehicle.Heading);
			}
			return szNowHeading;
			
		}
		
		/**
		 * Cohesion
		 * 同时向质心靠拢
		 * @param szNeighbors 
		 */
		public function Cohesion(szNeighbors:Vector.<Vehicle>):Vector2d
		{
			//质心
			var stCenterMass:Vector2d = new Vector2d;
			var iNerghborCount:int = 0;
			var iLn:int = szNeighbors.length;
			var stForce:Vector2d = new Vector2d;
			
			for(var i:int = 0;i<iLn;++i)
			{
				if(szNeighbors[i].IsTagged()&&szNeighbors[i]!=m_stVehicle)
				{
					stCenterMass.AddVector(szNeighbors[i].Pos);
					iNerghborCount++;
				}
			}
			
			if(iNerghborCount>0)
			{
				stCenterMass.DivNumber(iNerghborCount);
				stForce = Seek(stCenterMass);
			}
			return Vector2d.Vect2DNormalize(stForce);
		}
		
		public function CohesionPlus(szNeighbors:Vector.<BaseGameEntity>):Vector2d
		{
			var stCenterMass:Vector2d = new Vector2d;
			var iNerghborCount:int = 0;
			var stForce:Vector2d = new Vector2d;
			
			for(var i:int = 0;i<szNeighbors.length&&szNeighbors[i]!=null;++i)
			{
				stCenterMass.AddVector(szNeighbors[i].Pos);
				iNerghborCount++;
			}
			
			if(iNerghborCount>0)
			{
				stCenterMass.DivNumber(iNerghborCount);
				stForce = Seek(stCenterMass);
			}
			return Vector2d.Vect2DNormalize(stForce);
		}
		
		
		/**
		 * 计算当前运动状态
		 * 计算所有力的合力
		 */
		private function CalculatePrioritized():Vector2d
		{
			var stForce:Vector2d;
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_WALL_AVOIDANCE))
			{
				stForce = WallObstacle().MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightWallAvoidance);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_OBSTACLE_AVOIDANCE))
			{
				stForce = ObstacleAvoidance(m_stVehicle).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightObstacleAvoidance);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_EVADE))
			{
				stForce = Evade(m_stFocusVec).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightEnvade);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_FLEE))
			{
				stForce = Flee(m_stVehicle.World.CrossHair).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightSeek);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_SEPARATION))
			{
				if(!m_bCellSpaceOn)
					stForce = Separation(m_stVehicle.World.Agents).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightSeparation);
				else 
					stForce = SeparationPlus(m_stVehicle.World.CellSpace.Neighbors).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightSeparation);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_ALIGNMENT))
			{
				if(!m_bCellSpaceOn)
					stForce = Alignment(m_stVehicle.World.Agents).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightAlihnment);
				else 
					stForce = AlignmentPlus(m_stVehicle.World.CellSpace.Neighbors).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightAlihnment);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_COHESION))
			{
				if(!m_bCellSpaceOn)
					stForce = Cohesion(m_stVehicle.World.Agents).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightCohesion);
				else 
					stForce = CohesionPlus(m_stVehicle.World.CellSpace.Neighbors).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightCohesion);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_SEEK))
			{
				stForce = Seek(m_stVehicle.World.CrossHair).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightSeek);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_ARRIVE))
			{
				stForce = Arrive(m_stVehicle.World.CrossHair,SteeringBehaviorInfo.DECELERATION_NORMAL);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_WANDER))
			{
				stForce = Wander().MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightWander);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_PURSUIT))
			{
				stForce = Pursuit(m_stFocusVec);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_OFFSET_PURSUIT))
			{
				stForce = OffsetPursuit(m_stLeader,m_stOffsetPt).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightOffsetPursuit);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_INTERPOSE))
			{
				stForce = Interpose(m_stInterposVecLhs,m_stInterposVecRhs).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightInterpose);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_HIDE))
			{
				stForce = Hide(m_stHideVec,m_stVehicle.World.ObstacleSet).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightHide);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;	
			}
			
			if(SteeringBehaviorInfo.Get().On(m_iMask,SteeringBehaviorInfo.BEHAVIOR_TYPE_FOLLOW_PATH))
			{
				stForce = FollowPath(m_stPath).MulNumberRet(SteeringBehaviorInfo.Get().m_nWeightFollowPath);
				if(!AccumulateForce(m_stSteeringForce,stForce))
					return m_stSteeringForce;
			}
			
			return m_stSteeringForce;
		}
		
		private function AccumulateForce(stNowForce:Vector2d,stAddForce:Vector2d):Boolean
		{
			//计算当前力得大小
			var nNowForce:Number = stNowForce.Length();
			//当前该物体能够被给予最大的力
			var nRemainForce:Number = m_stVehicle.MaxForce - nNowForce;
			if(nRemainForce<0.0)
				return false;
			var nAddForce:Number = stAddForce.Length();
			if(nAddForce>nRemainForce)
				nAddForce = nRemainForce;
			stNowForce.AddVector(Vector2d.Vect2DNormalize(stAddForce).MulNumberRet(nAddForce));
			return true;
		}
		
		public function SeekOn():void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_SEEK;
		}
		
		public function SeekOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_SEEK;
		}
		
		public function FleeOn():void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_FLEE;
		}
		
		public function FleeOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_FLEE;
		}
		
		public function ArriveOn():void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_ARRIVE;
		}
		
		public function ArriveOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_ARRIVE;
		}
		
		public function PursuitOn(stVeicleInfo:Vehicle):void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_PURSUIT;
			m_stFocusVec = stVeicleInfo;
		}
		
		public function PursuitOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_PURSUIT;
			m_stFocusVec = null;
		}
		
		public function EvadeOn(stVeicleInfo:Vehicle):void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_EVADE;
			m_stFocusVec = stVeicleInfo;
		}
		
		public function EvadeOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_EVADE;
			m_stFocusVec = null;
		}
		
		public function WanderOn():void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_WANDER;
		}
		
		public function WanderOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_WANDER;
		}
		
		public function ObstacleAvoidaceOn():void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_OBSTACLE_AVOIDANCE;
		}
		
		public function ObstacleAvoidaceOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_OBSTACLE_AVOIDANCE;
		}
		
		public function WallAvoidaceOn():void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_WALL_AVOIDANCE;
		}
		
		public function WallAvoidaceOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_WALL_AVOIDANCE;
		}
		
		public function InterposeOn(stAgentLhs:Vehicle,stAgentRhs:Vehicle):void
		{
			if(stAgentLhs==null||stAgentRhs==null)
			{
				throw new Error("不能为空");
			}
			m_stInterposVecLhs = stAgentLhs;
			m_stInterposVecRhs = stAgentRhs;
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_INTERPOSE;
		}
		
		public function InterposeOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_INTERPOSE;
		}
		
		public function HideOn(stHideTar:Vehicle):void
		{
			if(stHideTar==null)
				throw new Error("不能为空")
			m_stHideVec = stHideTar;
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_HIDE;
		}
		
		public function HideOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_HIDE;
		}
		
		public function FollowPathOn(stPath:Path):void
		{
			m_stPath = stPath;
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_FOLLOW_PATH;
		}
		
		public function FollowPathOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_FOLLOW_PATH;	
		}
		
		public function OffsetPursuitOn(stLeader:Vehicle,stOffsetPos:Vector2d):void
		{
			m_stLeader = stLeader;
			m_stOffsetPt = stOffsetPos;
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_OFFSET_PURSUIT;
		}
		
		public function OffsetPursuitOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_OFFSET_PURSUIT
		}
		
		public function SeparationOn():void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_SEPARATION;
		}
		
		public function SeparationOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_SEPARATION;
		}
		
		public function AlignmentOn():void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_ALIGNMENT;
		}
		
		public function AlignmentOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_ALIGNMENT;
		}
		
		public function CohesionOn():void
		{
			m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_COHESION;
		}
		
		public function CohesionOff():void
		{
			m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_COHESION;
		}
		/**开启群集行为*/
		public function FlockingOn():void
		{
			//m_iMask |= SteeringBehaviorInfo.BEHAVIOR_TYPE_FLOCK;
			CohesionOn();
			AlignmentOn();
			SeparationOn();
			WanderOn();
		}
		
		public function FlockingOff():void
		{
			//m_iMask ^= SteeringBehaviorInfo.BEHAVIOR_TYPE_FLOCK;
			CohesionOff();
			AlignmentOff();
			SeparationOff();
			WanderOff();
		}
		
	}
}