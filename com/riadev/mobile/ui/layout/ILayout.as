package com.riadev.mobile.ui.layout
{
	import flash.display.Sprite;

	/**
	 * 布局类的接口
	 * @author NeoGuo
	 * 
	 */	
	public interface ILayout
	{
		/**布局子元件*/
		function layoutChildren(container:Sprite,parentWidth:Number,parentHeight:Number):void;
	}
}