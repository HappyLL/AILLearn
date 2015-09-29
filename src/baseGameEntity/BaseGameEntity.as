package baseGameEntity
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import baseGameEntity.info.BaseGameEntityInfo;
	
	import msg.Telegram;
	
	import vector.Vector2d;
	
	public class BaseGameEntity extends Sprite
	{
		private static var NEXTID:int = 0;
		
		private var m_iID:int;
		private var m_iEntityType:int;
		/**特殊标记*/
		private var m_bTag:Boolean;
		protected var m_stPos:Vector2d;
		/**当前物体的x,y上长度的缩放比*/
		protected var m_stScale:Vector2d;
		protected var m_nBoundingRadius:Number;
		
		public function BaseGameEntity(iEntityType:int = BaseGameEntityInfo.DEFAULT_ENTITY_TYPE,
									   stPos:Vector2d =null,nR:Number = 0.0,ForcedID:int = -1)
		{
			m_iID = NextVaildID();
			m_nBoundingRadius = nR;
			if(stPos==null)
				m_stPos = new Vector2d(1.0,1.0);
			else
				m_stPos = new Vector2d(stPos.nX,stPos.nY);
			m_stScale = new Vector2d(1.0,1.0);
			m_iEntityType = iEntityType;
			m_bTag = false;
			if(ForcedID>0)
				m_iID = ForcedID;
			if(stPos!=null)
			{
				this.x = stPos.nX;
				this.y = stPos.nY;
			}
		}
		
		private function NextVaildID():int
		{
			return NEXTID++;
		}
		
		public function Update(ts:Number):void
		{
		
		}
		
		public function HandleMessage(msg:Telegram):Boolean
		{
			return false;
		}
		
		public function set Pos(value:Vector2d):void
		{
			m_stPos.nX = value.nX;
			m_stPos.nY = value.nY;
			
			this.x = value.nX;
			this.y = value.nY;
			
		}
		
		public function get Pos():Vector2d
		{
			return m_stPos;
		}
		
		public function get BRadius():Number
		{
			return m_nBoundingRadius;
		}
		
		public function set BRadius(value:Number):void
		{
			m_nBoundingRadius = value;
		}
		
		public function get ID():int
		{
			return ID;
		}
		
		public function IsTagged():Boolean
		{
			return m_bTag;
		}
		
		public function Tagged():void
		{
			m_bTag = true;
		}
		
		public function UnTagged():void
		{
			m_bTag = false;
		}
		
		public function get Scale():Vector2d
		{
			return m_stScale;
		}
		/**
		 * 物体x,y轴方向上的缩放比例
		 */
		public function set ScaleVector(stVect:Vector2d):void
		{
			m_nBoundingRadius *= Math.max(stVect.nX,stVect.nY)/Math.max(m_stScale.nX,m_stScale.nY);
			m_stScale = stVect;
		}
		/**
		 * 物体x,y轴方向上的缩放比例
		 */
		public function set ScaleNumber(value:Number):void
		{
			m_nBoundingRadius *= value/(Math.max(m_stScale.nX,m_stScale.nY));
			m_stScale.nX = value;
			m_stScale.nY = value;
		}
		
		public function get EntityType():int
		{
			return m_iEntityType;
		}
		
		public function set EntityType(value:int):void
		{
			m_iEntityType = value;
		}
		/**
		 * 通过m_stPos是最先更新的 然后通过该函数来更新视图上的位置
		 */
		public function ChangeSpritePos():void
		{
			this.x = m_stPos.nX;
			this.y = m_stPos.nY;
		}
		
		public function Render():void
		{
			var stCenter:Shape = new Shape;
			stCenter.graphics.beginFill(0xffffff,0);
			stCenter.graphics.lineStyle(2,0x000000);
			stCenter.graphics.drawCircle(0,0,m_nBoundingRadius);
			stCenter.graphics.endFill();
			this.addChild(stCenter);
			
			var stText:TextField = new TextField;
			stText.htmlText = '<font size = "16" color = "#000000" face = "Arial">'+"("+this.x+","+this.y+")"+'</font>';
			stText.width = 200;
			stText.height = 200;
			this.addChild(stText);
			stText.x -= 50;
		}
		
	}
}