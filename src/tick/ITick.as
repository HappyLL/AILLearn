/**
 * ITick类
 * @author ZhengShuang Wang
 * Copyright (c) 2014 上海欢乐互娱网络科技有限公司
 */

package tick
{
	public interface ITick
	{
		/**
		 * 时钟信号函数
		 * @param uiTickCount 当前的Tick计数
		 */
		function Tick(uiTickCount:uint):void;
		
		/**
		 * 启动Tick
		 * 被添加之后自动调用
		 */
		function StartTick():void;
		
		/**
		 * 终止Tick
		 * 被移除之后自动调用
		 */
		function EndTick():void;
		
		/**
		 * Tick是否已经启用
		 * 应该在调用过StartTick()之后要返回true，
		 * 在调用过EndTick()之后要返回false。
		 */
		function IsTickActive():Boolean;
		
		/**
		 * 返回类名
		 * 在Tick有问题的时候输出信息用
		 */
		function GetName():String;
	}
}