package com.riadev.mobile.ui.renderer
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 一个简单的带图标的ItemRenderer
	 * @author NeoGuo
	 * 
	 */
	public class IconItemRenderer extends Sprite implements IItemRenderer
	{
		/**如果使用虚拟滚动，需要声明此静态属性，列表将以此作为每一项的高度*/
		public static var itemHeight:Number = 100;
		
		/**@private*/
		private var _data:Object;
		private var _selected:Boolean = false;
		private var itemWidth:Number = 0;
		private var labelDisplay:TextField;
		private var iconLoader:Loader;
		private var currentText:String;
		private var currentIconURL:String;
		
		/**被回收的实例的存储数组*/
		private static var instanceArr:Array = [];
		/**
		 * 创建实例的工厂方法，如果有缓存则先取缓存，否则创建新对象
		 * @return 
		 */		
		public static function createInstance():IItemRenderer
		{
			if(instanceArr.length > 0)
				return instanceArr.pop();
			else
				return new IconItemRenderer();
		}
		/**
		 * 回收不再需要的实例，等候下一次调用
		 * @param obj
		 */		
		public static function reclaim(obj:IItemRenderer):void
		{
			obj.clear();
			instanceArr.push(obj);
		}
		/**
		 * 构造方法
		 */		
		public function IconItemRenderer()
		{
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			mouseChildren = false;
		}
		/**
		 * 当实例被添加到显示列表，则进行初始化
		 * @param event
		 */		
		protected function addedToStageHandler(event:Event):void
		{
			if(labelDisplay == null)
			{
				labelDisplay = new TextField();
				labelDisplay.width = itemWidth - 100;
				labelDisplay.height = 30;
				labelDisplay.x = 100;
				labelDisplay.y = (itemHeight-30)/2;
				var textFormat:TextFormat = new TextFormat(null,24,null,true);
				labelDisplay.defaultTextFormat = textFormat;
				labelDisplay.selectable = false;
				addChild(labelDisplay);
				iconLoader = new Loader();
				iconLoader.x = 20;
				iconLoader.y = 20;
				addChild(iconLoader);
			}
			dataChange();
			drawBackground();
		}
		/**
		 * 当数据变更，处理UI界面的显示
		 */
		protected function dataChange():void
		{
			if(stage==null)
				return;
			if(currentText != data["label"])
				labelDisplay.text = data["label"];
			if(currentIconURL != data["icon"])
				iconLoader.load(new URLRequest(data["icon"]));
			currentText = data["label"];
			currentIconURL = data["icon"];
		}
		/**数据对象*/
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
			dataChange();
			selected = false;
		}
		/**是否被选中*/
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value)
				return;
			_selected = value;
			if(parent != null)
				drawBackground();
		}
		
		/**@private*/
		override public function get width():Number
		{
			return itemWidth;
		}
		override public function set width(value:Number):void
		{
			itemWidth = value;
			if(parent != null)
				drawBackground();
		}
		/**@private*/
		override public function get height():Number
		{
			return itemHeight;
		}
		/**
		 * 绘制背景
		 */		
		private function drawBackground():void
		{
			if(itemWidth == 0) 
				return;
			labelDisplay.width = itemWidth - 100;
			var g:Graphics = this.graphics;
			g.clear();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(itemWidth,itemHeight,90,0,0);
			if(_selected)
				g.beginGradientFill(GradientType.LINEAR,[0xFF0000,0x00FF00],[1,1],[1,255],matrix);
			else
				g.beginGradientFill(GradientType.LINEAR,[0xFFFFFF,0xCCCCCC],[1,1],[1,255],matrix);
			g.drawRect(0,0,itemWidth,itemHeight);
			g.endFill();
		}
		/**
		 * 清理
		 */		
		public function clear():void
		{
			x = 0;
			y = 0;
			_selected = false;
		}
		
	}
}