package com.riadev.mobile.ui.layout
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * 列表式的垂直布局
	 * @author NeoGuo
	 * 
	 */	
	public class VerticalLayout implements ILayout
	{
		/**如果设置为true，将自动调整子元件的宽度为容器宽度*/
		public var matchContainerWidth:Boolean = false;
		/**项之间的间距*/
		public var gap:Number = 0;
		/**
		 * 构造方法
		 * @param matchContainerWidth
		 * @param gap
		 * 
		 */		
		public function VerticalLayout(matchContainerWidth:Boolean,gap:Number)
		{
			this.matchContainerWidth = matchContainerWidth;
			this.gap = gap;
		}
		/**
		 * 布局子元件
		 * @param container
		 * @param parentWidth
		 * @param parentHeight
		 * 
		 */		
		public function layoutChildren(container:Sprite, parentWidth:Number, parentHeight:Number):void
		{
			var num:Number = container.numChildren;
			var currentY:Number = 0;
			for (var i:int = 0; i < num; i++) 
			{
				var child:DisplayObject = container.getChildAt(i);
				child.x = 0;
				child.y = currentY;
				if(matchContainerWidth)
					child.width = parentWidth;
				currentY = child.y + child.height + gap;
			}
			
		}
	}
}