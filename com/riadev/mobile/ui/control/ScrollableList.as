package com.riadev.mobile.ui.control
{
	import com.riadev.mobile.events.DataChangeEvent;
	import com.riadev.mobile.ui.container.ScrollableContainer;
	import com.riadev.mobile.ui.layout.ILayout;
	import com.riadev.mobile.ui.layout.VerticalLayout;
	import com.riadev.mobile.ui.renderer.IItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	/**
	 * 可滚动列表
	 * @author NeoGuo
	 * 
	 */	
	public class ScrollableList extends Sprite
	{
		/**用可滚动的容器来承载数据项*/
		protected var container:ScrollableContainer;
		/**布局类*/
		protected var layout:ILayout;
		/**项目渲染器类*/
		public var itemRenderer:Class;
		
		/**列表项间距*/
		protected var itemGap:Number;
		/**是否开启虚拟滚动。在数据量大的时候，虚拟滚动可以节省一些性能，但要求每个itemRenderer必须高度相同*/
		protected var useVirtualScroll:Boolean = false;
		
		/**@private*/
		private var _dataProvider:Array;
		/**数据源*/
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
			if(useVirtualScroll)
			{
				virtualItemArr = [];
				var itemHeight:Number = (itemRenderer as Object).itemHeight;
				for (var i:int = 0; i < dataProvider.length; i++)
				{
					var virtualItem:VirtualItemRenderer = new VirtualItemRenderer(dataProvider[i]);
					virtualItem.y = i*(itemHeight+itemGap);
					virtualItemArr.push(virtualItem);
				}
			}
			createItemRenderer();
		}
		
		/**@private*/
		private var _selectedItem:Object;
		/**当前选中项*/
		public function get selectedItem():Object
		{
			return _selectedItem;
		}
		public function set selectedItem(value:Object):void
		{
			if(_selectedItem == value)
				return;
			_selectedItem = value;
			var currentItemNum:Number = container.numChildren;
			for (var i:int = 0; i < currentItemNum; i++) 
			{
				var child:IItemRenderer = container.getChildAt(i) as IItemRenderer;
				if(child.data == _selectedItem)
					child.selected = true;
				else
					child.selected = false;
			}
		}
		/**虚拟滚动时，需要的显示对象数量*/
		protected var needNumber:int;
		/**虚拟项数组*/
		protected var virtualItemArr:Array = [];
		/**需要更新显示的虚拟项数组*/
		protected var needUpdateItemArr:Array = [];
		/**是否处于滚动状态*/
		protected var inScrollState:Boolean = false;
		/**多长时间验证某一项是否被点击了*/
		protected var validateItemClickTime:Number = 200;
		/**
		 * 构造方法
		 * 这个方法只是做一些初始化的工作
		 */
		public function ScrollableList(itemRenderer:Class,itemGap:Number=0,useVirtualScroll:Boolean=false)
		{
			this.itemRenderer = itemRenderer;
			this.itemGap = itemGap;
			this.useVirtualScroll = useVirtualScroll;
			createChildren();
		}
		/**
		 * 创建内部所需的对象
		 */
		protected function createChildren():void
		{
			container = new ScrollableContainer(useVirtualScroll);
			container.horizontalScrollEnabled = false;
			if(useVirtualScroll)
			{
				container.measureFunction = measureFunction;
				container.addEventListener("startScroll",contentScrollHandler);
				container.addEventListener("endScroll",contentScrollHandler);
			}
			else
			{
				container.addEventListener("startScroll",changeScrollState);
				container.addEventListener("endScroll",changeScrollState);
			}
			layout = new VerticalLayout(true,itemGap);
			container.layout = layout;
			super.addChild(container);
		}
		
		/**对于List，不能由用户代码添加显示对象，它不是容器，所以禁止操作下面的方法*/
		
		/**@private*/
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return throwError();
		}
		/**@private*/
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return throwError();
		}
		/**@private*/
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return throwError();
		}
		/**@private*/
		override public function removeChildAt(index:int):DisplayObject
		{
			return throwError();
		}
		
		/**下面对于尺寸的定义，会被容器更改默认行为*/
		
		/**@private*/
		override public function get width():Number
		{
			return container.width;
		}
		override public function set width(value:Number):void
		{
			if (container.width == value)
				return;
			container.width = value;
			if(useVirtualScroll)
				createItemRenderer();
		}
		/**@private*/
		override public function get height():Number
		{
			return container.height;
		}
		override public function set height(value:Number):void
		{
			if (container.height == value)
				return;
			container.height=value;
			if(useVirtualScroll)
				createItemRenderer();
		}
		
		/**
		 * 获取样式属性的值
		 * @param styleName
		 * @return
		 */
		public function getStyle(styleName:String):*
		{
			return container.getStyle(styleName);
		}
		
		/**
		 * 设置样式，目前只支持borderColor,bgColor,bgAlpha
		 * @param styleName
		 * @param value
		 */
		public function setStyle(styleName:String, value:*):void
		{
			container.setStyle(styleName,value);
		}
		/**
		 * 根据数据源，创建列表项
		 */		
		protected function createItemRenderer():void
		{
			//clear first
			var currentItemNum:Number = container.numChildren;
			for (var i:int = 0; i < currentItemNum; i++) 
			{
				if((itemRenderer as Object).reclaim != null)
					(itemRenderer as Object).reclaim(container.removeChildAt(0));
			}
			//create ItemRenderer
			var child:IItemRenderer;
			if(useVirtualScroll)
			{
				if(width <= 0 || height <=0)
					return;
				var itemHeight:Number = (itemRenderer as Object).itemHeight;
				needNumber = Math.ceil(height/itemHeight)+1;
				for (i = 0; i < needNumber; i++)
				{
					if((itemRenderer as Object).createInstance != null)
						child = (itemRenderer as Object).createInstance();
					else
						child = new itemRenderer();
					child.data = dataProvider[i];
					child.y = i*(itemHeight+itemGap);
					if(!child.hasEventListener(MouseEvent.MOUSE_DOWN))
						child.addEventListener(MouseEvent.MOUSE_DOWN,itemClickHanlder);
					container.addChild(child as DisplayObject);
					child.width = width;
				}
			}
			else
			{
				for (var j:int = 0; j < dataProvider.length; j++) 
				{
					if((itemRenderer as Object).createInstance != null)
						child = (itemRenderer as Object).createInstance();
					else
						child = new itemRenderer();
					child.data = dataProvider[j];
					if(!child.hasEventListener(MouseEvent.MOUSE_DOWN))
						child.addEventListener(MouseEvent.MOUSE_DOWN,itemClickHanlder);
					container.addChild(child as DisplayObject);
				}
			}
		}
		/**
		 * 当数据列表项被点击，设置selectedItem
		 * @param event
		 */		
		protected function itemClickHanlder(event:Event):void
		{
			setTimeout(validateItemClick,validateItemClickTime,event.currentTarget);
		}
		/**
		 * 因为移动设备的屏幕，MouseDown和MouseMove经常同时触发，造成判断错误，所以需要延迟对于点击事件的判断
		 * @param child
		 */		
		protected function validateItemClick(child:Object):void
		{
			if(inScrollState)
				return;
			if(selectedItem != child.data)
			{
				var itemChangeEvent:DataChangeEvent = new DataChangeEvent(DataChangeEvent.ITEM_CHANGE);
				itemChangeEvent.selectedItem = child.data;
				dispatchEvent(itemChangeEvent);
			}
			selectedItem = child.data;
		}
		/**
		 * 在开启虚拟滚动时，由这个方法计算虚拟的内容高度
		 * @return 
		 */		
		protected function measureFunction():Object
		{
			var cotentHeight:Number = _dataProvider.length*((itemRenderer as Object).itemHeight+itemGap);
			return {width:width,height:cotentHeight};
		}
		/**
		 * 当"虚拟的滚动"被触发时，处理显示列表中的内容
		 * @param event
		 */		
		protected function contentScrollHandler(event:Event):void
		{
			if(event.type == "startScroll")
			{
				addEventListener(Event.ENTER_FRAME,changeChildrenLocation);
				inScrollState = true;
			}
			else
			{
				inScrollState = false;
				if(container.virtualContentGroupY==0 || container.virtualContentGroupY==(container.height-container.contentHeight))
				{
					changeChildrenLocation();
				}
				removeEventListener(Event.ENTER_FRAME,changeChildrenLocation);
			}
		}
		/**
		 * 计算子元件的位置，仅在虚拟滚动时使用
		 * @param event
		 */		
		protected function changeChildrenLocation(...args):void
		{
			if(container.virtualContentGroupY > 0 || container.virtualContentGroupY < -(container.contentHeight-container.height))
			{
				return;
			}
			var itemHeight:Number = (itemRenderer as Object).itemHeight;
			//表记
			var dataLength:int = virtualItemArr.length;
			needUpdateItemArr.length = 0;
			var virtualItem:VirtualItemRenderer;
			var currentItemY:Number;
			for (var i:int = 0; i < dataLength; i++) 
			{
				virtualItem = virtualItemArr[i];
				currentItemY = virtualItem.y+container.virtualContentGroupY;
				if(currentItemY > -itemHeight && currentItemY < container.height)
				{
					needUpdateItemArr.push(virtualItem);
				}
			}
			//定位
			dataLength = needUpdateItemArr.length;
			if(dataLength < container.numChildren)
			{
				container.getChildAt(container.numChildren-1).y = -itemHeight;
			}
			for (i = 0; i < dataLength; i++) 
			{
				virtualItem = needUpdateItemArr[i];
				currentItemY = virtualItem.y+container.virtualContentGroupY;
				var displayItem:IItemRenderer = container.getChildAt(i) as IItemRenderer;
				if(displayItem.data != virtualItem.data)
					displayItem.data = virtualItem.data;
				displayItem.y = currentItemY;
			}
		}
		/**改变inScrollState的值*/
		protected function changeScrollState(event:Event):void
		{
			if(event.type == "startScroll")
				inScrollState = true;
			else
				inScrollState = false;
		}
		/**抛出错误*/
		private function throwError():*
		{
			throw new Error("List不是容器，禁止操作此方法");
			return null;
		}
		
	}
}
/**
 * 虚拟数据项
 * @author NeoGuo
 * 
 */
class VirtualItemRenderer
{
	public var data:Object;
	public var x:Number;
	public var y:Number;
	
	public function VirtualItemRenderer(data:Object)
	{
		this.data = data;
	}
	
}