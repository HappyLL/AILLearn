package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	
	import baseGameEntity.info.BaseGameEntityInfo;
	
	import gameWorld.GameWorld;
	
	import tick.Ticker;

	[SWF(width="1440", height="900", frameRate="60")]
	public class Steering extends Sprite
	{
		private var m_stGOW:GameWorld;
		private var m_stTicker:Ticker;
		
		private var m_iAlphphaKey:int;
		
		private var m_stText:TextField;
		private var m_iNums:int = 0;
		
		public function Steering()
		{
			if(this.stage)
			{
				OnAddToStage(null);
			}
			else 
			{
				this.addEventListener(Event.ADDED_TO_STAGE,OnAddToStage);	
			}
		
		}
		
		protected function OnAddToStage(e:Event):void
		{
			m_stGOW = new GameWorld(1440,900,this.stage);
			this.stage.addChild(m_stGOW);
			m_stTicker = new Ticker(stage.frameRate);
			m_stTicker.AddNormalTick(m_stGOW);
			this.stage.addEventListener(Event.ENTER_FRAME,OnEnterFrame);
			m_stTicker.Start();
			
			m_stText = new TextField;
			m_stText.htmlText = '<font size = "18" face = "Arial" color = "#FF0000">'+"SteerForce:(W/E) "+m_stGOW.GetVehicle().MaxForce+
				"\n"+"MaxSpeed:(J/K) "+m_stGOW.GetVehicle().MaxSpeed+'</font>';
			m_stText.autoSize = TextFieldAutoSize.LEFT;
			m_stText.selectable = false;
			m_stText.mouseEnabled = false;
			addChild(m_stText);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,OnKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,OnKeyUp);
		}
		
		protected function OnKeyDown(e:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			switch(e.charCode-32)
			{
				case Keyboard.W:
					m_iAlphphaKey|=(1<<22);
					break;
				case Keyboard.S:
					m_iAlphphaKey|=(1<<4);
					break;
				case Keyboard.J:
					m_iAlphphaKey|=(1<<9);
					break;
				case Keyboard.K:
					m_iAlphphaKey|=(1<<10);
					break;
				case Keyboard.N:
					m_iAlphphaKey|=(1<<12);
					break;
				case Keyboard.H:
					m_iAlphphaKey|=(1<<13);
					break;
				
			}
				
			
		}
		
		protected function OnKeyUp(e:KeyboardEvent):void
		{
			// TODO Auto-generated method stub
			switch(e.charCode-32)
			{
				case Keyboard.W:
					m_iAlphphaKey&=(0x7fffffff^(1<<22));
					break;
				case Keyboard.S:
					m_iAlphphaKey&=(0x7fffffff^(1<<4));
					break;
				case Keyboard.J:
					m_iAlphphaKey&=(0x7fffffff^(1<<9));
					break;
				case Keyboard.K:
					m_iAlphphaKey&=(0x7fffffff^(1<<10));
					break;
				case Keyboard.N:
					m_iAlphphaKey&=(0x7fffffff^(1<<12));
					break;
				case Keyboard.H:
					m_iAlphphaKey&=(0x7fffffff^(1<<13));
					break;
			}
			
		}
		
		private function OnEnterFrame(e:Event):void
		{
			m_stTicker.Signal();
			KeyStatus();
		}
		
		private function KeyStatus():void
		{
			//w
			m_iNums++;
			if(m_iNums%5!=0)
				return;
			m_iNums = 0;
			if(m_iAlphphaKey&(1<<22))
			{
				m_stGOW.GetVehicle().MaxForce++;
			}
			else if(m_iAlphphaKey&(1<<4))
			{
				m_stGOW.GetVehicle().MaxForce--;
				if(m_stGOW.GetVehicle().MaxForce<0)
					m_stGOW.GetVehicle().MaxForce = 0;
			}
			else if(m_iAlphphaKey&(1<<9))
			{
				m_stGOW.GetVehicle().MaxSpeed++;
			}
			else if(m_iAlphphaKey&(1<<10))
			{
				m_stGOW.GetVehicle().MaxSpeed--;
				if(m_stGOW.GetVehicle().MaxSpeed<0)
					m_stGOW.GetVehicle().MaxSpeed = 0;
			}
			else if(m_iAlphphaKey&(1<<12))
			{
				//m_stGOW.ShowWall2D();
				//m_stGOW.ShowObstacle();
				m_stGOW.ShowPath();
			}
			else if(m_iAlphphaKey&(1<<13))
			{
				//m_stGOW.HideObstacle();
				//m_stGOW.HideWall2D();
				m_stGOW.HidePath();
			}
			
			m_stText.htmlText = '<font size = "18" face = "Arial" color = "#FF0000">'+"SteerForce:(W/E) "+m_stGOW.GetVehicle().MaxForce+
				"\n"+"MaxSpeed:(J/K) "+m_stGOW.GetVehicle().MaxSpeed+'</font>';
				
		}
		
		
	}
}