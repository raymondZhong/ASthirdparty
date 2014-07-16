package com.riadev.mobile.ui.support
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	/**
	 * 滚动控制类，非显示对象
	 * @author NeoGuo
	 * 
	 */
	public class ScrollControler
	{
		/**对ScrollBar实例的引用*/
		public var scrollBarRef:ScrollBar;
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
		
		/**包含内容的容器，引用ScrollableContainer的contentGroup*/
		private var contentGroup:Sprite;
		/**容器的父级，即ScrollableContainer*/
		private var parent:Sprite;
		/**X轴速度*/
		private var _speedX:int=0;
		/**Y轴速度*/
		private var _speedY:int=0;
		/**手指的水平方向，即内容的水平滚动方向*/
		private var directionX:String="left"; //or right,手指方向
		/**手指的垂直方向，即内容的垂直滚动方向*/
		private var directionY:String="up"; //or down,手指方向
		/**在启动缓动之前，先跟随鼠标*/
		private var fllowMouse:Boolean=false;
		/**光标坐标点距离起点的位移X*/
		private var currentMouseOffsetX:Number=0;
		/**光标坐标点距离起点的位移Y*/
		private var currentMouseOffsetY:Number=0;
		/**启动拖放时的坐标点X*/
		private var startX:Number;
		/**启动拖放时的坐标点Y*/
		private var startY:Number;
		/**结束拖放时的坐标点X*/
		private var endX:Number;
		/**结束拖放时的坐标点Y*/
		private var endY:Number;
		/**启动拖放时的时间*/
		private var startTime:Number;
		/**结束拖放时的时间*/
		private var endTime:Number;
		
		/**开启虚拟滚动*/
		public var useVirtualScroll:Boolean = false;
		/**一旦开启虚拟滚动，则以此值为计算依据，实际值将永远是0*/
		public var virtualContentGroupX:Number = 0;
		/**@copy #virtualContentGroupX*/
		public var virtualContentGroupY:Number = 0;
		
		/**速度值X，外部只读*/
		public function get speedX():Number
		{
			return _speedX;
		}
		/**速度值Y，外部只读*/
		public function get speedY():Number
		{
			return _speedY;
		}
		
		/**
		 * 构造方法
		 * @param container 包含内容的容器，即ScrollableContainer的contentGroup
		 * @param parent 父级，即ScrollableContainer
		 */		
		public function ScrollControler(contentGroup:Sprite, parent:Sprite)
		{
			this.contentGroup=contentGroup;
			this.parent=parent;
			initContainer();
		}
		/**
		 * 什么也不做，等待容器添加到显示列表
		 */		
		private function initContainer():void
		{
			contentGroup.addEventListener(Event.ADDED_TO_STAGE,addListeners);
			contentGroup.addEventListener(Event.REMOVED_FROM_STAGE,clear);
		}
		/**
		 * 当容器添加到显示列表，则注册事件侦听
		 * @param event
		 */		
		protected function addListeners(event:Event):void
		{
			contentGroup.addEventListener(MouseEvent.MOUSE_DOWN, containerMouseHandler);
			contentGroup.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
		}
		/**
		 * 对鼠标事件的处理(在移动设备上，单点Touch事件会自动映射为MouseEvent)
		 * @param event
		 */		
		private function containerMouseHandler(event:Event):void
		{
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				contentGroup.stage.addEventListener(MouseEvent.MOUSE_MOVE, containerMouseHandler);
				contentGroup.stage.addEventListener(MouseEvent.MOUSE_UP, containerMouseHandler);
			}
			else if (event.type == MouseEvent.MOUSE_MOVE)
			{
				contentGroup.mouseChildren = false;
				startX=parent.mouseX;
				startY=parent.mouseY;
				startTime=getTimer();
				if(useVirtualScroll)
				{
					currentMouseOffsetX=parent.mouseX - virtualContentGroupX;
					currentMouseOffsetY=parent.mouseY - virtualContentGroupY;
				}
				else
				{
					currentMouseOffsetX=parent.mouseX - contentGroup.x;
					currentMouseOffsetY=parent.mouseY - contentGroup.y;
				}
				fllowMouse=true;
				contentGroup.stage.removeEventListener(MouseEvent.MOUSE_MOVE, containerMouseHandler);
				contentGroup.stage.addEventListener(MouseEvent.MOUSE_UP, containerMouseHandler);
				contentGroup.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				parent.dispatchEvent(new Event("startScroll"));
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				endX=parent.mouseX;
				endY=parent.mouseY;
				endTime=getTimer();
				var timeOffset:Number=endTime - startTime;
				directionX=(endX <= startX) ? "left" : "right";
				directionY=(endY <= startY) ? "up" : "down";
				_speedX=(endX - startX) / (timeOffset / 20);
				_speedY=(endY - startY) / (timeOffset / 20);
				currentMouseOffsetX=0;
				currentMouseOffsetY=0;
				fllowMouse=false;
				checkXRange();
				checkYRange();
				contentGroup.stage.removeEventListener(MouseEvent.MOUSE_MOVE, containerMouseHandler);
				contentGroup.stage.removeEventListener(MouseEvent.MOUSE_UP, containerMouseHandler);
			}
		}
		/**
		 * 当光标离开Flash区域，则停止拖动
		 * @param event
		 * 
		 */		
		private function mouseLeaveHandler(event:Event):void
		{
			fllowMouse=false;
			checkXRange();
			checkYRange();
		}
		/**
		 * 每一次Flash Player帧循环要处理的方法（依赖FPS），通过速度值的递减或递增实现缓动效果
		 * @param event
		 */		
		private function enterFrameHandler(event:Event):void
		{
			if (fllowMouse)
			{
				if(horizontalScrollEnabled)
				{
					if(useVirtualScroll)
						virtualContentGroupX=parent.mouseX - currentMouseOffsetX;
					else
						contentGroup.x=parent.mouseX - currentMouseOffsetX;
				}
				if(verticalScrollEnabled)
				{
					if(useVirtualScroll)
						virtualContentGroupY=parent.mouseY - currentMouseOffsetY;
					else
						contentGroup.y=parent.mouseY - currentMouseOffsetY;
				}
				if(useVirtualScroll)
					scrollBarRef.update(virtualContentGroupX,virtualContentGroupY);
				else
					scrollBarRef.update(contentGroup.x,contentGroup.y);
				return;
			}
			if (Math.abs(_speedX) < 4)
				_speedX=0;
			if (Math.abs(_speedY) < 4)
				_speedY=0;
			if(_speedX == 0 && _speedY == 0)
			{
				scrollBarRef.clear();
				contentGroup.mouseChildren = true;
				parent.dispatchEvent(new Event("endScroll"));
				contentGroup.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				return;
			}
			if(useVirtualScroll)
			{
				virtualContentGroupX+=_speedX;
				virtualContentGroupY+=_speedY;
			}
			else
			{
				contentGroup.x+=_speedX;
				contentGroup.y+=_speedY;
			}
			checkXRange();
			checkYRange();
			if (directionX == "left")
				_speedX+=1;
			else
				_speedX-=1;
			if (directionY == "up")
				_speedY+=1;
			else
				_speedY-=1;
			if(useVirtualScroll)
				scrollBarRef.update(virtualContentGroupX,virtualContentGroupY);
			else
				scrollBarRef.update(contentGroup.x,contentGroup.y);
		}
		
		/**检查X值，确定不超出允许范围*/
		private function checkXRange():void
		{
			if(contentWidth <= parentWidth)
			{
				_speedX=0;
				contentGroup.x=0;
				virtualContentGroupX=0;
				return;
			}
			var currentGroupX:Number = useVirtualScroll?virtualContentGroupX:contentGroup.x;
			if (currentGroupX + contentWidth <= parentWidth)
			{
				_speedX=0;
				if(useVirtualScroll)
					virtualContentGroupX=parentWidth - contentWidth;
				else
					contentGroup.x=parentWidth - contentWidth;
				return;
			}
			if (currentGroupX >= 0)
			{
				_speedX=0;
				contentGroup.x=0;
				virtualContentGroupX=0;
				return;
			}
		}
		
		/**检查Y值，确定不超出允许范围*/
		private function checkYRange():void
		{
			if(contentHeight <= parentHeight)
			{
				_speedY=0;
				contentGroup.y=0;
				virtualContentGroupY=0;
				return;
			}
			var currentGroupY:Number = useVirtualScroll?virtualContentGroupY:contentGroup.y;
			if (currentGroupY + contentHeight <= parentHeight)
			{
				_speedY=0;
				if(useVirtualScroll)
					virtualContentGroupY=parentHeight - contentHeight;
				else
					contentGroup.y=parentHeight - contentHeight;
				return;
			}
			if (currentGroupY >= 0)
			{
				_speedY=0;
				contentGroup.y=0;
				virtualContentGroupY=0;
				return;
			}
		}
		/**
		 * 清理
		 */		
		private function clear(...args):void
		{
			contentGroup.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			contentGroup.removeEventListener(MouseEvent.MOUSE_DOWN, containerMouseHandler);
			contentGroup.removeEventListener(MouseEvent.MOUSE_UP, containerMouseHandler);
		}
		
	}
}