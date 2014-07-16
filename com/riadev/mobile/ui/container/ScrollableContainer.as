package com.riadev.mobile.ui.container
{
	import com.riadev.mobile.ui.layout.ILayout;
	import com.riadev.mobile.ui.support.ScrollBar;
	import com.riadev.mobile.ui.support.ScrollControler;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * 这是一个用于移动设备的带滚动条的容器，用于显示超出的内容
	 * @author NeoGuo
	 *
	 */
	public class ScrollableContainer extends Sprite
	{
		/**@private*/
		private var _horizontalScrollEnabled:Boolean=true;
		/**@private*/
		private var _verticalScrollEnabled:Boolean=true;
		/**水平可滚动*/
		public function get horizontalScrollEnabled():Boolean
		{
			return _horizontalScrollEnabled;
		}
		public function set horizontalScrollEnabled(value:Boolean):void
		{
			_horizontalScrollEnabled = value;
			scrollControler.horizontalScrollEnabled = value;
			scrollBar.horizontalScrollEnabled = value;
		}
		/**垂直可滚动*/
		public function get verticalScrollEnabled():Boolean
		{
			return _verticalScrollEnabled;
		}
		public function set verticalScrollEnabled(value:Boolean):void
		{
			_verticalScrollEnabled = value;
			scrollControler.verticalScrollEnabled = value;
			scrollBar.verticalScrollEnabled = value;
		}

		/**添加到内部的显示对象，实际上添加到这个容器中*/
		protected var contentGroup:Sprite;
		/**遮罩*/
		protected var maskShape:Shape;
		/**容器宽度*/
		protected var containerWidth:Number=0;
		/**容器高度*/
		protected var containerHeight:Number=0;
		/**子元件宽度*/
		protected var _contentWidth:Number=0;
		/**子元件高度*/
		protected var _contentHeight:Number=0;
		/**@private*/
		private var _needUpdate:Boolean=false;
		/**样式对象*/
		private var style:Object;
		/**滚动控制器*/
		protected var scrollControler:ScrollControler;
		/**显示滚动位置*/
		protected var scrollBar:ScrollBar;
		/**@private*/
		private var _layout:ILayout;
		/**布局类实例，控制子元件的排列方式*/
		public function get layout():ILayout
		{
			return _layout;
		}
		public function set layout(value:ILayout):void
		{
			if(_layout == value)
				return;
			_layout = value;
			needUpdate = true;
		}

		/**是否需要更新显示列表*/
		public function get needUpdate():Boolean
		{
			return _needUpdate;
		}
		public function set needUpdate(value:Boolean):void
		{
			_needUpdate=value;
			if (_needUpdate)
			{
				if (!hasEventListener(Event.RENDER))
					addEventListener(Event.RENDER, updateDisplayList);
				if (stage != null)
					stage.invalidate();
			}
			else
			{
				removeEventListener(Event.RENDER, updateDisplayList);
			}
		}
		/**在度量计算量较大的情况下，可以传递这个方法，进行优化*/
		public var measureFunction:Function;
		/**开启虚拟滚动*/
		protected var useVirtualScroll:Boolean;
		/**@copy ScrollControler#virtualContentGroupX*/
		public function get virtualContentGroupX():Number
		{
			return scrollControler.virtualContentGroupX;
		}
		/**@copy ScrollControler#virtualContentGroupX*/
		public function get virtualContentGroupY():Number
		{
			return scrollControler.virtualContentGroupY;
		}
		
		/**速度值X，外部只读*/
		public function get speedX():Number
		{
			return scrollControler.speedX;
		}
		/**速度值Y，外部只读*/
		public function get speedY():Number
		{
			return scrollControler.speedY;
		}
		/**获取实际内容的宽度*/
		public function get contentWidth():Number
		{
			return _contentWidth;
		}
		/**获取实际内容的高度*/
		public function get contentHeight():Number
		{
			return _contentHeight;
		}
		
		/**
		 * 构造方法
		 * 这个方法只是做一些初始化的工作
		 */
		public function ScrollableContainer(useVirtualScroll:Boolean=false)
		{
			this.useVirtualScroll = useVirtualScroll;
			createChildren();
		}

		/**
		 * 创建内部所需的对象
		 */
		protected function createChildren():void
		{
			contentGroup=new Sprite();
			super.addChild(contentGroup);
			maskShape=new Shape();
			super.addChild(maskShape);
			contentGroup.mask=maskShape;
			style={bgColor: 0xFFFFFF, bgAlpha: 1};
			scrollControler = new ScrollControler(contentGroup,this);
			scrollControler.useVirtualScroll = useVirtualScroll;
			scrollBar = new ScrollBar();
			super.addChild(scrollBar);
			scrollControler.scrollBarRef = scrollBar;
		}

		/**下面override的这些方法，都是为了更正contentGroup可能导致的错误行为*/

		/**@private*/
		override public function addChild(child:DisplayObject):DisplayObject
		{
			contentGroup.addChild(child);
			needUpdate = true;
			return child;
		}

		/**@private*/
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			contentGroup.addChildAt(child, index);
			needUpdate = true;
			return child;
		}

		/**@private*/
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			contentGroup.removeChild(child);
			needUpdate = true;
			return child;
		}

		/**@private*/
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject=contentGroup.removeChildAt(index);
			needUpdate = true;
			return child;
		}

		/**@private*/
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			contentGroup.setChildIndex(child, index);
		}

		/**@private*/
		override public function getChildAt(index:int):DisplayObject
		{
			return contentGroup.getChildAt(index);
		}

		/**@private*/
		override public function getChildByName(name:String):DisplayObject
		{
			return contentGroup.getChildByName(name);
		}

		/**@private*/
		override public function getChildIndex(child:DisplayObject):int
		{
			return contentGroup.getChildIndex(child);
		}

		/**@private*/
		override public function get numChildren():int
		{
			return contentGroup.numChildren;
		}

		/**下面对于尺寸的定义，会被容器更改默认行为*/

		/**@private*/
		override public function get width():Number
		{
			return containerWidth;
		}
		override public function set width(value:Number):void
		{
			if (containerWidth == value)
				return;
			containerWidth=value;
			needUpdate=true;
		}

		/**@private*/
		override public function get height():Number
		{
			return containerHeight;
		}
		override public function set height(value:Number):void
		{
			if (containerHeight == value)
				return;
			containerHeight=value;
			needUpdate=true;
		}

		/**
		 * 当needUpdate为true，则会触发更新显示列表的方法
		 */
		protected function updateDisplayList(... args):void
		{
			if (stage == null || width <= 0 || height <= 0)
				return;
			//background
			drawBackground();
			//measure children size
			measure();
			//scroller
			contentGroup.x=0;
			contentGroup.y=0;
			scrollControler.virtualContentGroupX = 0;
			scrollControler.virtualContentGroupY = 0;
			scrollControler.parentWidth = width;
			scrollControler.parentHeight = height;
			scrollControler.contentWidth = _contentWidth;
			scrollControler.contentHeight = _contentHeight;
			scrollBar.parentWidth = width;
			scrollBar.parentHeight = height;
			scrollBar.contentWidth = _contentWidth;
			scrollBar.contentHeight = _contentHeight;
			needUpdate = false;
		}

		/**
		 * 计算子元素的尺寸
		 */
		protected function measure():void
		{
			if(measureFunction != null)
			{
				var returnObj:Object = measureFunction();
				_contentWidth = returnObj.width;
				_contentHeight = returnObj.height;
				drawContentBackground();
				return;
			}
			if(_layout != null)
				_layout.layoutChildren(contentGroup,containerWidth,containerHeight);
			var startWidth:Number=0;
			var startHeight:Number=0;
			for (var i:int=0; i < contentGroup.numChildren; i++)
			{
				var child:DisplayObject=contentGroup.getChildAt(i);
				var childPoint:Point=new Point(child.x + child.width, child.y + child.height);
				if (childPoint.x > startWidth)
					startWidth=childPoint.x;
				if (childPoint.y > startHeight)
					startHeight=childPoint.y;
			}
			_contentWidth=startWidth;
			_contentHeight=startHeight;
		}

		/**
		 * 通知显示列表失效，等候下一次渲染时处理
		 */
		public function invalidateDisplayList():void
		{
			needUpdate = true;
		}
		/**
		 * 立刻执行更新
		 */
		public function validateNow():void
		{
			updateDisplayList();
		}

		/**
		 * 获取样式属性的值
		 * @param styleName
		 * @return
		 */
		public function getStyle(styleName:String):*
		{
			return style[styleName];
		}

		/**
		 * 设置样式，目前只支持borderColor,bgColor,bgAlpha
		 * @param styleName
		 * @param value
		 */
		public function setStyle(styleName:String, value:*):void
		{
			if (style[styleName] == value)
				return;
			style[styleName]=value;
			needUpdate=true;
		}
		/**
		 * 绘制背景和边框
		 */
		protected function drawBackground():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			if (style["borderColor"] != null)
			{
				g.lineStyle(1, style["borderColor"], 1);
			}
			g.beginFill(style["bgColor"], style["bgAlpha"]);
			g.drawRect(0, 0, width, height);
			g.endFill();
			//draw mask
			g=maskShape.graphics;
			g.clear();
			g.beginFill(0x000000, 1);
			g.drawRect(1, 1, width - 2, height - 2);
			g.endFill();
		}
		/**
		 * 绘制内容容器的背景，主要是方便交互
		 */		
		protected function drawContentBackground():void
		{
			var g:Graphics=contentGroup.graphics;
			g.clear();
			g.beginFill(0x000000,0);
			g.drawRect(0,0,_contentWidth,_contentHeight);
			g.endFill();
		}
	}
}