package baseGameEntity.vehicle
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import baseGameEntity.behavior.SteeringBehavior;
	import baseGameEntity.behavior.SteeringBehaviorInfo;
	import baseGameEntity.entityFunctionTemplates.EntityFunctionTemplates;
	import baseGameEntity.info.BaseGameEntityInfo;
	import baseGameEntity.moveEntity.MoveEntity;
	import baseGameEntity.smoother.Smoother;
	
	import configXml.GameWordData;
	
	import gameWorld.GameWorld;
	
	import transformation.TransformationHandle;
	
	import vector.Vector2d;
	import vector.VectorInfo;
	
	public class Vehicle extends MoveEntity
	{
		//private var gow
		private var m_stSprite:Sprite;
		//当前运动体的形状
		private var m_stShape:Shape;
		
		private var m_stGOW:GameWorld;
		private var m_stSteerBehavior:SteeringBehavior;
		private var m_stHeadingSmoother:Smoother;
		private var m_stSmoothedHeading:Vector2d;
		private var m_bSmoothingOn:Boolean;
		private var m_nTimeElapsed:Number;
		private var m_szVehicleVB:Vector.<Vector2d>;
		private var m_szVehicleVBTMP:Vector.<Vector2d>;
		private var m_szFeels:Vector.<Vector2d>;
		private var m_szPoint:Vector.<Number>;
		private var m_stOldPos:Vector2d;
		
		//private var m_stTestShape:Shape;
		//private var m_bFirstRender:Boolean;
		
		public function Vehicle(stWorld:GameWorld,stPos:Vector2d,
								nRotation:Number,stVelocity:Vector2d,nMass:Number,nMaxForce:Number,
								nMaxSpeed:Number,nMaxTurnRate:Number,nScale:Number
		)
		{
			//var stHeading:Vector2d = new Vector2d(VehicleInfo.Get().m_szPointOfVeh[0][0],VehicleInfo.Get().m_szPointOfVeh[0][1]);
			//stHeading = stPos.SubVectorRet(stHeading);
			//stHeading.Normalize();
			super(stPos,nScale,stVelocity,nMaxSpeed,
				new Vector2d(1,0),
				nMass,new Vector2d(nScale,nScale),nMaxTurnRate,nMaxForce);
			
			m_stGOW = stWorld;
			m_stSmoothedHeading = new Vector2d(0,0)
			m_bSmoothingOn = false;
			m_nTimeElapsed = 0;
			InitializeBuffer();
			m_stSteerBehavior = new SteeringBehavior(this);
			m_stHeadingSmoother = new Smoother(Vehicle,GameWordData.Get().NumSamplesForSmoothing,new Vector2d(0,0));
			m_szFeels = new Vector.<Vector2d>(3);
			
			ChangeSpritePos();
			DrawMySelf();
			m_stOldPos = new Vector2d;
			//Render();
		}
		
		public function DrawMySelf():void
		{
			
			
			m_stSprite = new Sprite;
			this.addChild(m_stSprite);
			
			m_stShape = new Shape;
			m_stSprite.addChild(m_stShape);
			DrawVehicleShape(m_szVehicleVB);
		}
		
		//当前物体运动的形状
		private function DrawVehicleShape(szVehicleVB:Vector.<Vector2d>):void
		{
			m_stShape.graphics.clear();
			
			//var vt:Vector.<Number> = new Vector.<Number>;
			for(var i:int = 0;i<szVehicleVB.length;++i)
			{
//				vt.push(szVehicleVB[i].nX);
//				vt.push(szVehicleVB[i].nY);
				m_szPoint[i<<1] = szVehicleVB[i].nX;
				m_szPoint[(i<<1)|1] = szVehicleVB[i].nY;
			}
			
			m_stShape.graphics.beginFill(0x0000FF,1);
			m_stShape.graphics.lineStyle(2,0x0000FF);
			m_stShape.graphics.drawTriangles(m_szPoint);
			//m_stShape.graphics.drawCircle(0,0,m_nBoundingRadius);
			m_stShape.graphics.endFill();
			
//			m_stShape.graphics.lineStyle(2,0x000000)
//			m_stShape.graphics.moveTo(0,0);
//			var stX:Vector2d = m_stHeading.MulNumberRet(100);
//			m_stShape.graphics.lineTo(stX.nX,stX.nY);
//			
//			m_stShape.graphics.lineStyle(2,0x000000)
//			m_stShape.graphics.moveTo(0,0);
//			var stY:Vector2d = m_stSide.MulNumberRet(100);
//			m_stShape.graphics.lineTo(stY.nX,stY.nY);
			
			//m_stSprite.addChild(m_stShape)
			
			//InitializeBuffer();
//			m_stTestShape = new Shape;
//			m_stTestShape.graphics.beginFill(0xffff00);
//			m_stTestShape.graphics.drawCircle(50,50,10)
//			m_stTestShape.graphics.endFill();
//			this.addChild(m_stTestShape);
			//m_stShape.rotation=0
				//trace("Shape",m_stShape.x,m_stShape.y);
				
			//var stPoint:Shape = new Shape;
//			m_stShape.graphics.lineStyle(2,0x000000);
//			m_stShape.graphics.moveTo(0,0)
//			m_stShape.graphics.lineTo(0,30);
//			m_stShape.graphics.endFill();
			//m_stSprite.addChild(m_stShape);
			//Render();
				
		}
		
		private function InitializeBuffer():void
		{
			m_szVehicleVB = new Vector.<Vector2d>;
			m_szVehicleVBTMP = new Vector.<Vector2d>(3);
			m_szPoint = new Vector.<Number>(6);
			
			var szVechiclePoint:Vector.<Vector2d> 
							= new Vector.<Vector2d>;
			szVechiclePoint.push(new Vector2d(VehicleInfo.Get().m_szPointOfVeh[0][0],VehicleInfo.Get().m_szPointOfVeh[0][1]));
			szVechiclePoint.push(new Vector2d(VehicleInfo.Get().m_szPointOfVeh[1][0],VehicleInfo.Get().m_szPointOfVeh[1][1]));
			szVechiclePoint.push(new Vector2d(VehicleInfo.Get().m_szPointOfVeh[2][0],VehicleInfo.Get().m_szPointOfVeh[2][1]));
			for(var i:int = 0;i<BaseGameEntityInfo.NUMVEHICLEVERTS;++i)
			{
				if(i<szVechiclePoint.length)
				{
					m_szVehicleVB.push(szVechiclePoint[i]);
				}
			}
			
		}
		
		public override function Update(nTimeElapsed:Number):void
		{
			
			m_nTimeElapsed = 1;
			//IsRotateHeadingToFacePosition(this.World.CrossHair);
//			if(nTimeElapsed%10==0)
//				Render();
			//nTimeElapsed = m_nTimeElapsed;
//			if(Vector2d.IsSimaEqualVector2d(this.World.CrossHair,this.Pos,VectorInfo.EPS_ST))
//			{
//				//Render();
//				return;
//			}
			//trace("Update");
			m_stOldPos.Copy(this.Pos);
			var stSteeingForce:Vector2d;
			//算出当前受到的力
			stSteeingForce = m_stSteerBehavior.Calculate();
			//算出当前的加速度
			var stAcceleration:Vector2d = stSteeingForce.DivNumberRet(m_nMass);
			//加速度乘以时间+原始的速度
			m_stVelocity.AddVector(stAcceleration.MulNumberRet(m_nTimeElapsed));
			//判断当前速度是否超过最大值
			m_stVelocity.Truncate(m_nMaxSpeed);
			//更新位置
			m_stPos.AddVector(m_stVelocity.MulNumberRet(m_nTimeElapsed));
			//速度更新完之后我们需要更新物体的朝向,首先判断当前是否为0向量
			if(m_stVelocity.LengthSq()>0.0000001)
			{
				//返回的当前向量的正交向量
				m_stHeading = Vector2d.Vect2DNormalize(m_stVelocity);
				m_stSide = m_stHeading.Perp();
				//trace(m_stHeading.Dot(m_stSide))
				//Render();
				if(nTimeElapsed%2==0)
					Render();
			}
			
			//EntityFunctionTemplates.EnforceNonPenetrationConstraint(this,this.World.CellSpace.Neighbors);
			//判断当前的位置有没有出界
			Vector2d.WrapAround(m_stPos,m_stGOW.CxClient,m_stGOW.CyClient);
			//空间划分暂时不需要用到
			if(m_stSteerBehavior.IsSpacePartitioningOn())
			{
				World.CellSpace.UpdateEntity(this,m_stOldPos);
			}
			if(IsSmoothingOn())
			{
				m_stHeadingSmoother = m_stHeadingSmoother.Update(Heading()); 
			}
			
			ChangeSpritePos();
			//Render();
			//IsRotateHeadingToFacePosition(m_st);
//			this.x = m_stPos.nX;
//			this.y = m_stPos.nY;
		}
		
		public function get Steering():SteeringBehavior
		{
			return m_stSteerBehavior;
		}
		
		public function get World():GameWorld
		{
			return m_stGOW;
		}
		
		public function get SmoothedHeading():Vector2d
		{
			return m_stSmoothedHeading;
		}
		
		public function get bSmoothingOn():Boolean
		{
			return m_bSmoothingOn;
		}
		
		public function get Feels():Vector.<Vector2d>
		{
			return m_szFeels;
		}
		
		public function IsSmoothingOn():void
		{
			m_bSmoothingOn = true;
		}
		
		public function IsSmoothingOff():void
		{
			m_bSmoothingOn = false;
		}
		
		public function ToggleSmoothing():void
		{
			m_bSmoothingOn = !m_bSmoothingOn;
		}
		
		public function CreateFeels():void
		{
			m_szFeels[0] = m_stPos.AddVectorRet(m_stHeading.MulNumberRet(SteeringBehaviorInfo.Get().m_dWallDetectionFeelerLength));
			
			var stTemp:Vector2d = new Vector2d(m_stHeading.nX,m_stHeading.nY);
			
			m_szFeels[1] = m_stPos.AddVectorRet(Vector2d.Vec2DRotateAroundOrigin(stTemp,35/180*Math.PI));
			
			m_szFeels[2] = m_stPos.AddVectorRet(Vector2d.Vec2DRotateAroundOrigin(stTemp,-35/180*Math.PI));
			
		}
		
		
		public override function Render():void
		{
			//trace(m_stVelocity.nX,m_stVelocity.nY);
			
			//trace(m_stRenderHeading.nX,m_stRenderHeading.nY);
			
			//trace(m_stHeading.nX,m_stHeading.nY);
			//trace("\n")
//			if(Vector2d.IsSimaEqualVector2d(m_stRenderHeading,m_stHeading,VectorInfo.EPS))
//				return;
			//var stTarPos:Vector2d = this.m_stGOW.CrossHair;
			//trace(this.Pos.nX,this.Pos.nY);
			//trace(stTarPos.nX,stTarPos.nY);
			//trace(m_stHeading.nX,m_stHeading.nY);
			//stTarPos = stTarPos.SubVectorRet(this.Pos);
			//stTarPos.Normalize();
//			var iTag:int = m_stHeading.Sign(stTarPos);
//			if(iTag==1)
//			{
//				iTag = -1;
//			}
//			else if(iTag==2)
//			{
//				iTag = 1;
//			}


//			var iTag:int = m_stRenderHeading.Sign(m_stHeading);
//			if(iTag==1)
//			{
//				iTag = -1;
//			}
//			else if(iTag==2)
//			{
//				iTag = 1;
//			}
//			if(iTag==0)
//			{
//				return;
//			}
//			
//			var iNums:Number =  m_stHeading.Dot(m_stRenderHeading)/*m_stHeading.Sign(Vector2d.Vect2DNormalize(this.m_stGOW.CrossHair)*/;
//			if(iNums>1.0)
//				iNums = 1.0;
//			else if(iNums<-1.0)
//				iNums = -1.0;
//			var nRad:Number = Math.acos(iNums);
//			if(nRad<VectorInfo.EPS)
//				return;
//			if(nRad>m_nMaxTurnRate) nRad = m_nMaxTurnRate;
			//var nAngel:Number = nRad*180/Math.PI
			//m_stShape.rotation += nAngel*m_stHeading.Sign(this.m_stGOW.CrossHair)*(-1);
//			var iHNumsX:Number,iSNumsX:Number;
//			var iHNumsY:Number,iSNumsY:Number;
//			iHNumsX = m_stHeading.nX;
//			iHNumsY = m_stHeading.nY;
//			iSNumsX = m_stSide.nX;
//			iSNumsY = m_stSide.nY;
//			var a:Number,c:Number;
//			var na:Number,nc:Number;
//			var stMatrix:Matrix = m_stSprite.transform.matrix;
//			if(stMatrix==null)
//				stMatrix = new Matrix;
//			a = stMatrix.a;c = stMatrix.c;
//			na = m_stHeading.nX;nc = m_stHeading.nY;
//			var nTmp:Number = (na*a+nc*c)/(a*a+c*c);
//			if(nTmp>1.0)
//				nTmp = 1.0;
//			else if(nTmp<-1.0)
//				nTmp = -1.0;
//			var nRad:Number = Math.acos((nTmp));
//			stMatrix.rotate(nRad);
//			//var stNewMatrix:Matrix = new Matrix(m_stHeading.nX,m_stSide.nX,m_stHeading.nY,m_stSide.nY);
//			//stMatrix.concat(stNewMatrix);
//			m_stSprite.transform.matrix = stMatrix;
//			trace("Bf: a: "+a+" c: "+c);
//			trace('Af: a: '+na+" c: "+nc);
//			trace(m_stHeading.nX,m_stHeading.nY);
//			trace("nAngle: "+nRad*180/Math.PI);
			//trace(m_stShape.scaleX,m_stShape.scaleY);
//			var nowMatrix:Matrix = new Matrix;
//			nowMatrix.a = m_stHeading.nX;
//			nowMatrix.b = m_stHeading.nY;
//			nowMatrix.c = -m_stHeading.nY;
//			nowMatrix.d = m_stHeading.nX;
//			nowMatrix.tx = 0;
//			nowMatrix.ty = 0;
//			stMatrix.concat(nowMatrix);
//			trace(m_stSprite.x,m_stSprite.y);
//			trace(m_stShape.x,m_stShape.y);
//			trace(this.x,this.y);
			
			for(var i:int = 0;i<m_szVehicleVB.length;++i)
			{
				m_szVehicleVBTMP[i] = TransformationHandle.Get().VectorToParentSpace(m_szVehicleVB[i],m_stHeading,m_stSide);
			}
			DrawVehicleShape(m_szVehicleVBTMP);
			
			//stMatrix.setTo(m_stHeading.nX,m_stHeading.nY,m_stSide.nX,m_stSide.nY,0,0);
			
			//stMatrix.rotate(nRad*m_stHeading.Sign(Vector2d.Vect2DNormalize(this.m_stGOW.CrossHair))*-1);
			//m_stShape.transform.matrix = stMatrix;
			//m_stSprite.rotation+=nAngel*iTag;
//			if(!m_bFirstRender)
//			{
//				m_stHeading = stTarPos;
//				m_bFirstRender = true;
//			}
			//m_stRenderHeading = stTarPos;
			//m_stSprite.transform.matrix = stMatrix;
			
			//m_stRenderHeading.nX = m_stHeading.nX;
			//m_stRenderHeading.nY = m_stHeading.nY;
		}
		
	}
}