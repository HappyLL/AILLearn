package gameWorld
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import baseGameEntity.BaseGameEntity;
	import baseGameEntity.info.BaseGameEntityInfo;
	import baseGameEntity.vehicle.Vehicle;
	import baseGameEntity.wall.Wall2D;
	
	import cellSpacingPartition.CellSpacingPartition;
	
	import configXml.GameWordData;
	
	import path.Path;
	
	import tick.ITick;
	
	import vector.Vector2d;
	
	public class GameWorld extends Sprite implements ITick
	{
		private var m_nX:Number;
		private var m_nY:Number;
		
		private var m_stPath:Path;
		private var m_stVehicle:Vehicle;
		private var m_stPurVehicle:Vehicle;
		private var m_stEvadeVehicle:Vehicle;
		private var m_stCrossHairSp:Sprite;
		private var m_vstObstacles:Vector.<BaseGameEntity>;
		private var m_szWall2D:Vector.<Wall2D>;
		private var m_stStage:Stage;
		private var m_szAgent:Vector.<Vehicle>;
		
		private var m_stCellSpacingPartion:CellSpacingPartition;
		private var m_stCrossHair:Vector2d;
		private var m_bActive:Boolean;
		
		//private var m_nTestTime:Number = 4000;
		/**
		 * 初始化是右下角的点
		 */
		public function GameWorld(nCx:Number,nCy:Number,stage:Stage)
		{
			m_nX = nCx;
			m_nY = nCy;
			m_stStage = stage;
			m_stCrossHair = new Vector2d(m_nX/2,m_nY/2);
			
//			m_stPath = new Path(10,25,100,900,950,true);
//			m_stPath.Render();
//			this.addChild(m_stPath);
			
			m_stCellSpacingPartion = new CellSpacingPartition(5,5,500,500,10);
			
			var stSpawnPos:Vector2d = new Vector2d(nCx/2,
				nCy/2.0)
			m_stVehicle = new Vehicle(this,stSpawnPos,Math.random()*Math.PI*2,new Vector2d(0,0),
				BaseGameEntityInfo.VEHICLEMASS,BaseGameEntityInfo.MAXSTEERINGFORCE,BaseGameEntityInfo.MAXSPEED,BaseGameEntityInfo.MAXTURNRATEPERSECOND,
				BaseGameEntityInfo.VEHICLESCALE*5);
//			stSpawnPos = new Vector2d(nCx/2+Math.random()*nCx/2,
//						nCy/2.0+Math.random()*nCy/2)
//			m_stPurVehicle = new Vehicle(this,stSpawnPos,Math.random()*Math.PI*2,new Vector2d(0,0),
//				BaseGameEntityInfo.VEHICLEMASS,BaseGameEntityInfo.MAXSTEERINGFORCE,BaseGameEntityInfo.MAXSPEED,BaseGameEntityInfo.MAXTURNRATEPERSECOND,
//				BaseGameEntityInfo.VEHICLESCALE);
//			
//			stSpawnPos = new Vector2d(nCx/2+Math.random()*nCx/2,
//				nCy/2.0+Math.random()*nCy/2)
//			m_stEvadeVehicle = new Vehicle(this,stSpawnPos,Math.random()*Math.PI*2,new Vector2d(0,0),
//				BaseGameEntityInfo.VEHICLEMASS,BaseGameEntityInfo.MAXSTEERINGFORCE,BaseGameEntityInfo.MAXSPEED,BaseGameEntityInfo.MAXTURNRATEPERSECOND,
//				BaseGameEntityInfo.VEHICLESCALE);
			
//			m_stPurVehicle.Steering.HideOn(m_stVehicle);
//			m_stPurVehicle.Steering.ObstacleAvoidaceOn();
//			
//			m_stEvadeVehicle.Steering.HideOn(m_stVehicle);
//			m_stEvadeVehicle.Steering.ObstacleAvoidaceOn();
			//m_stPurVehicle.Steering.WanderOn();
			//m_stVehicle.Steering.OrMask(SteeringBehaviorInfo.BEHAVIOR_TYPE_SEEK);
			//m_stVehicle.Steering.SeekOn();
			//m_stVehicle.Steering.FleeOn();
			//m_stVehicle.Steering.InterposeOn(m_stPurVehicle,m_stEvadeVehicle);
			m_stVehicle.Steering.WanderOn();
			//m_stVehicle.Steering.ObstacleAvoidaceOn();
			//m_stVehicle.Steering.FollowPathOn(m_stPath);
			m_stVehicle.Steering.WallAvoidaceOn();
			this.addChild(m_stVehicle);
			m_stVehicle.scaleX = 0.5;
			m_stVehicle.scaleY = 0.5;
			m_stCellSpacingPartion.AddEntity(m_stVehicle);
			
			
			
//			m_stPurVehicle.Steering.PursuitOn(m_stVehicle);
			//m_stPurVehicle.Steering.OffsetPursuitOn(m_stVehicle,new Vector2d(-50,-50));
			//this.addChild(m_stPurVehicle);
//			
//			m_stEvadeVehicle.Steering.EvadeOn(m_stVehicle);
			//m_stEvadeVehicle.Steering.OffsetPursuitOn(m_stVehicle,new Vector2d(-50,50));
			//this.addChild(m_stEvadeVehicle);
			
			//DrawCrossHair();
			//DrawObstacles();
			//DrawWall2D();
			
			//m_stStage.addEventListener(MouseEvent.CLICK,OnChangeCrossHairPos);
			//setTimeout(TestFunction,m_nTestTime)
			m_szAgent = new Vector.<Vehicle>;
			var stVehicle:Vehicle;
//			
			for(var i:int = 0;i<100;++i)
			{
//				iFlag = 1;
//				if(i==0)
//					iFlag = 4;
//				var stSpawnPos:Vector2d = new Vector2d(nCx/2,nCy/2.0)
				stVehicle = new Vehicle(this,stSpawnPos,Math.random()*Math.PI*2,new Vector2d(0,0),
									BaseGameEntityInfo.VEHICLEMASS,BaseGameEntityInfo.MAXSTEERINGFORCE,BaseGameEntityInfo.MAXSPEED,BaseGameEntityInfo.MAXTURNRATEPERSECOND,
									BaseGameEntityInfo.VEHICLESCALE*2);
				this.addChild(stVehicle);
				stVehicle.Steering.FlockingOn();
				stVehicle.scaleX = 0.2;
				stVehicle.scaleY = 0.2;
				
//				if(i!=0)
//					stVehicle.Steering.PursuitOn(m_szAgent[0]);
//				else 
					stVehicle.Steering.EvadeOn(m_stVehicle);
					stVehicle.Steering.WallAvoidaceOn();
//				if(i!=0)
//				{
//					var iFlag:int = 1;
//					if(i%2==0)
//					//	iFlag = -1; 
//					//stVehicle.Steering.OffsetPursuitOn(m_szAgent[0],new Vector2d(-4*i,4*i*iFlag));
//				}
				m_szAgent.push(stVehicle);
				m_stCellSpacingPartion.AddEntity(stVehicle);
				
			}
			m_stVehicle.Steering.PursuitOn(m_szAgent[0]);
			//m_stVehicle.Steering.Pursuit(m_szAgent[0]);
			DrawWall2D();
		}
		
		public function GetVehicle():Vehicle
		{
			//return m_stVehicle;
			return m_szAgent[0]
		}
		
		public function TestFunction():void
		{
			var stSpawnPos:Vector2d = new Vector2d(Math.random()*m_nX,
				Math.random()*m_nY)
				
			m_stCrossHair.nX = stSpawnPos.nX;
			m_stCrossHair.nY = stSpawnPos.nY;
			
			m_stCrossHairSp.x = m_stCrossHair.nX;
			m_stCrossHairSp.y = m_stCrossHair.nY;
			m_stVehicle.Render();
			//m_nTestTime = m_nTestTime*0.96;
			m_stVehicle.MaxSpeed =m_stVehicle.MaxSpeed*1.08
			//setTimeout(TestFunction,m_nTestTime)
		}
		
		protected function OnChangeCrossHairPos(e:MouseEvent):void
		{
			// TODO Auto-generated method stub
			
			var stPt:Point = this.globalToLocal(new Point(e.stageX,e.stageY));
			m_stCrossHair.nX = stPt.x;
			m_stCrossHair.nY = stPt.y;
			
			m_stCrossHairSp.x = m_stCrossHair.nX;
			m_stCrossHairSp.y = m_stCrossHair.nY;
			//trace(m_stCrossHair.nX,m_stCrossHair.nY)
			
			
			//m_stVehicle.Render();
		}
		
		private function DrawWall2D():void
		{
			m_szWall2D = new Vector.<Wall2D>;
			var stWall2D:Wall2D;
			var stTo:Vector2d;
			var stFrom:Vector2d;
			var nDist:Number;
			var nAngle:Number;
			var vtPt:Vector.<Vector2d> = new Vector.<Vector2d>(4);
			vtPt[0] = new Vector2d(20,20);
			vtPt[1] = new Vector2d(480,20);
			vtPt[2] = new Vector2d(480,480);
			vtPt[3] = new Vector2d(20,480);
			for(var i:int = 0;i<GameWordData.Get().NUMSWALL2D;++i)
			{
				//nDist = 100*(1+Math.random());
				stFrom = vtPt[i]//new Vector2d(Math.random()*1440,Math.random()*900)
				//nAngle = 2*Math.PI*Math.random();
				stTo = vtPt[(i+1)%4];//new Vector2d(stFrom.nX+nDist*Math.cos(nAngle),stFrom.nY+nDist*Math.sin(nAngle));
				stWall2D = new Wall2D(stFrom,stTo);
				stWall2D.Render();
				this.addChild(stWall2D);
				stWall2D.visible = true;
				m_szWall2D.push(stWall2D);
			}
			
		}
		
		private function DrawObstacles():void
		{
			m_vstObstacles = new Vector.<BaseGameEntity>;
			var stObstacles:BaseGameEntity;
			var stPos:Vector2d;
			for(var i:int = 0;i<GameWordData.Get().NUMOBSTACLES;++i)
			{
				stPos = new Vector2d(Math.random()*1440,Math.random()*900);
				stObstacles = new BaseGameEntity(BaseGameEntityInfo.DEFAULT_ENTITY_TYPE,stPos,
					GameWordData.Get().NUMOBSTACLESRADIUS*(1+Math.random()));
				stObstacles.Render();
				this.addChild(stObstacles);
				stObstacles.visible = false;
				m_vstObstacles.push(stObstacles);
			}
		}
		
		private function DrawCrossHair():void
		{
			m_stCrossHairSp = new Sprite;
			m_stCrossHairSp.x = m_stCrossHair.nX;
			m_stCrossHairSp.y = m_stCrossHair.nY;
			var stCenter:Shape = new Shape;
			stCenter.graphics.beginFill(0xffffff,0);
			stCenter.graphics.lineStyle(2,0x000000);
			stCenter.graphics.drawCircle(0,0,10);
			stCenter.graphics.endFill();
			m_stCrossHairSp.addChild(stCenter);
			
			var stHor:Shape = new Shape;
			stHor.graphics.lineStyle(2,0x000000)
			stHor.graphics.moveTo(-25,0);
			stHor.graphics.lineTo(+25,0);
			m_stCrossHairSp.addChild(stHor);
			
			var stVel:Shape = new Shape;
			stVel.graphics.lineStyle(2,0x000000);
			stVel.graphics.moveTo(0,-25);
			stVel.graphics.lineTo(0,+25);
			m_stCrossHairSp.addChild(stVel);
			this.addChild(m_stCrossHairSp);
		}
		
		private var m_bShowWall2D:Boolean;
		public function ShowWall2D():void
		{
			if(m_bShowWall2D)
				return;
			m_bShowWall2D = true;
			for(var i:int = 0;i<m_szWall2D.length;++i)
			{
				m_szWall2D[i].visible = true;
			}
		}
		
		public function HideWall2D():void
		{
			m_bShowWall2D = false;
			for(var i:int = 0;i<m_szWall2D.length;++i)
			{
				m_szWall2D[i].visible = false;
			}
		}
		
		public function get Wall2DSet():Vector.<Wall2D>
		{
			return m_szWall2D;
		}
		
		public function ShowPath():void
		{
			if(m_stPath.parent)
				m_stPath.parent.removeChild(m_stPath);
			m_stPath = new Path(100,10+Math.random()*100,50+Math.random()*100,1200+Math.random()*50,600+Math.random()*50,true);
			this.addChildAt(m_stPath,0);
			m_stPath.Render();
			m_stPath.visible = true;
			m_stVehicle.Steering.FollowPathOn(m_stPath);
		}
		
		public function HidePath():void
		{
			if(m_stPath.parent)
				m_stPath.parent.removeChild(m_stPath);
			m_stPath.visible = false;
		}
		
		private var m_bShowObstacle:Boolean;
		public function ShowObstacle():void
		{
			if(m_bShowObstacle)
				return;
			m_bShowObstacle = true;
			for(var i:int = 0;i<m_vstObstacles.length;++i)
			{
				//var stPos:Vector2d =  new Vector2d(Math.random()*1440,Math.random()*900);
				//m_vstObstacles[i].Pos = stPos; 
				m_vstObstacles[i].visible = true;
			}
		}
		
		public function HideObstacle():void
		{
			if(!m_bShowObstacle)
				return;
			m_bShowObstacle = false;
			for(var i:int = 0;i<m_vstObstacles.length;++i)
			{
				m_vstObstacles[i].visible = false;
			}
		}
		
		public function get ObstacleSet():Vector.<BaseGameEntity>
		{
			return m_vstObstacles;
		}
		
		/**
		 * 利用标签来判断是否与要求物体接触
		 * @param stBaseEntity当前的物体
		 * @param nRange:当前检测距离
		 */
		public function TagObstaclesWithinViewRange(stBaseEntity:BaseGameEntity,nRange:Number):void
		{
			
			var nDisSq:Number;
			var nRadiusSq:Number;
			if(m_vstObstacles==null)
				return;
			for(var i:int = 0; i<m_vstObstacles.length;++i)
			{
				nDisSq = stBaseEntity.Pos.DistanceSq(m_vstObstacles[i].Pos);
				nRadiusSq = (nRange+m_vstObstacles[i].BRadius)*(nRange+m_vstObstacles[i].BRadius);
				m_vstObstacles[i].UnTagged();
				if(nDisSq<nRadiusSq&&m_vstObstacles[i].visible)
				{
					m_vstObstacles[i].Tagged();	
				}
				
			}
			
		}
		
		public function TagVehiclesWithinViewRange(stBaseEntity:BaseGameEntity,nRange:Number):void
		{
			TagNeighbors(stBaseEntity,m_szAgent,nRange);
		}
		
		/**
		 * 利用标签来判断是否与在领域半径内的物体接触
		 * @param stBaseEntity当前的物体
		 * @oaram szContainer 当前的容器
		 * @param nRange:当前检测距离
		 */
		public function TagNeighbors(stBaseEntity:BaseGameEntity,szContainer:*,nRange:Number):void
		{
			var nDisSq:Number;
			var nRadiusSq:Number;
			if(szContainer==null)
				return;
			for(var i:int = 0; i<szContainer.length;++i)
			{
				nDisSq = stBaseEntity.Pos.DistanceSq(szContainer[i].Pos);
				nRadiusSq = (nRange+szContainer[i].BRadius)*(nRange+szContainer[i].BRadius);
				szContainer[i].UnTagged();
				if(nDisSq<nRadiusSq&&szContainer[i]!=stBaseEntity&&szContainer[i].visible)
					szContainer[i].Tagged();
			}
		}
		
		public function get CxClient():Number
		{
			return m_nX;
		}
		
		public function get CyClient():Number
		{
			return m_nY;
		}
		
		public function get Agents():Vector.<Vehicle>
		{
			return m_szAgent;
		}
		
		public function get CrossHair():Vector2d
		{
			return m_stCrossHair;
		}
		
		public function get CellSpace():CellSpacingPartition
		{
			return m_stCellSpacingPartion;
		}
		
		/**
		 * 更新函数
		 */
		private function Update(iTs:int):void
		{
			
//			m_stPurVehicle.Update(iTs);
//			m_stEvadeVehicle.Update(iTs);
			var iLn:int = m_szAgent.length;
////			//for(var i:int = 0;i<iLn;++i)
////			//{
////				var k:int = (((iTs)%100)/10);
////				var j:int = (k+1)*10;
////				var f:int = k*10;
////				for(var i:int = f;i<j;++i)
////				{
////					m_szAgent[i].Update(10);
////				}
////			//}
			for(var i:int = 0;i<iLn;++i)
			{
				m_szAgent[i].Update(iTs);
			}
			
			m_stVehicle.Update(iTs);
		}
		
		/**
		 * 时钟信号函数
		 * @param uiTickCount 当前的Tick计数
		 */
		public function Tick(uiTickCount:uint):void
		{
			//if(uiTickCount%10==0)
				Update(uiTickCount);
			//if(uiTickCount%5==0)
				//UpdateRender();
		}
		
		private function UpdateRender():void
		{
			m_stVehicle.Render();
		}
		
		/**
		 * 启动Tick
		 * 被添加之后自动调用
		 */
		public function StartTick():void
		{
			m_bActive = true;	
		}
		
		/**
		 * 终止Tick
		 * 被移除之后自动调用
		 */
		public function EndTick():void
		{
			m_bActive = false;
		}
		
		/**
		 * Tick是否已经启用
		 * 应该在调用过StartTick()之后要返回true，
		 * 在调用过EndTick()之后要返回false。
		 */
		public function IsTickActive():Boolean
		{
			return m_bActive;
		}
		
		/**
		 * 返回类名
		 * 在Tick有问题的时候输出信息用
		 */
		public function GetName():String
		{
			return "GameWorld";
		}
		
	}
}