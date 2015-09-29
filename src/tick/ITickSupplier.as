/**
 * public interface ITickSupplier接口
 * @author ZhengShuang Wang
 * Copyright (c) 2014 上海欢乐互娱网络科技有限公司
 */

package tick
{
	public interface ITickSupplier
	{
		/**
		 * 添加一个普通的更新信号
		 * @param tick 需要更新信号的对象
		 */
		function AddNormalTick(addTick:ITick):void;
		
		/**
		 * 从普通时钟信号中删除对应对象
		 * @param removeTick 需要删除的对象
		 */
		function RemoveNormalTick(removeTick:ITick):void;
		
		/**
		 * 获得当前帧速率
		 */
		function GetFrameRate():uint;
	}
}