package com.riadev.mobile.ui.support
{
	import com.greensock.TweenLite;
	
	import flash.display.Graphics;
	import flash.display.Shape;

	/**
	 * 只用于显示滚动位置，不可交互
	 * @author NeoGuo
	 * 
	 */	
	public class ScrollBar extends Shape
	{
		/**水平可滚动*/
		public var horizontalScrollEnabled:Boolean=true;
		/**垂直可滚动*/
		public var verticalScrollEnabled:Boolean=true;
		
		/**实际内容宽度*/
		public var contentWidth:Number = 0;
		/**实际内容高度*/
		public var contentHeight:Number = 0;
		/**容器约束宽度*/
		public var parentWidth:Number = 0;
		/**容器约束高度*/
		public var parentHeight:Number = 0;
		
		/**线段与边界的距离*/
		private var paddingValue:Number = 10;
		/**线段的粗细程度*/
		private var lineStroke:Number = 10;
		/**
		 * 构造方法
		 */		
		public function ScrollBar()
		{
			super();
		}
		/**
		 * 更新当前的显示图形
		 * @param scrollX contentGroup的x坐标
		 * @param scrollY contentGroup的y坐标
		 */		
		public function update(scrollX:Number,scrollY:Number):void
		{
			var g:Graphics = this.graphics;
			g.clear();
			//draw horizontal graphics
			if(horizontalScrollEnabled && contentWidth > parentWidth)
			{
				g.lineStyle(lineStroke+2,0x000000,0.5);
				var endY:Number = parentHeight-paddingValue;
				g.moveTo(paddingValue,endY);
				g.lineTo(parentWidth-paddingValue,endY);
				g.lineStyle(lineStroke,0xFFFFFF,1);
				var lineWidth:Number = (parentWidth-2*paddingValue)*(parentWidth/contentWidth);
				var lineStartX:Number = -scrollX/(contentWidth-parentWidth)*(parentWidth-2*paddingValue-lineWidth) + paddingValue;
				if(lineStartX<paddingValue)
				{
					lineWidth -= (paddingValue-lineStartX);
					lineStartX = paddingValue;
				}
				if(lineStartX+lineWidth > parentWidth-paddingValue)
				{
					lineWidth -= lineStartX+lineWidth-(parentWidth-paddingValue);
				}
				g.moveTo(lineStartX,endY);
				g.lineTo(lineStartX+lineWidth,endY);
			}
			//draw vertical graphics
			if(verticalScrollEnabled && contentHeight > parentHeight)
			{
				g.lineStyle(lineStroke+2,0x000000,0.5);
				var endX:Number = parentWidth-paddingValue;
				g.moveTo(endX,paddingValue);
				g.lineTo(endX,parentHeight-paddingValue);
				g.lineStyle(lineStroke,0xFFFFFF,1);
				var lineHeight:Number = (parentHeight-2*paddingValue)*(parentHeight/contentHeight);
				var lineStartY:Number = -scrollY/(contentHeight-parentHeight)*(parentHeight-2*paddingValue-lineHeight) + paddingValue;
				if(lineStartY<paddingValue)
				{
					lineHeight -= (paddingValue-lineStartY);
					lineStartY = paddingValue;
				}
				if(lineStartY+lineHeight > parentHeight-paddingValue)
				{
					lineHeight -= lineStartY+lineHeight-(parentHeight-paddingValue);
				}
				g.moveTo(endX,lineStartY);
				g.lineTo(endX,lineStartY+lineHeight);
			}
		}
		/**
		 * 清理
		 */		
		public function clear():void
		{
			TweenLite.to(this,0.5,{alpha:0,onComplete:reset});
		}
		/**
		 * 重置
		 */		
		private function reset():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			alpha = 1;
		}
	}
}