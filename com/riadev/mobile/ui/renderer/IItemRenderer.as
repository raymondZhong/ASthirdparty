package com.riadev.mobile.ui.renderer
{
	import flash.events.IEventDispatcher;

	/**
	 * 列表的项接口
	 * @author NeoGuo
	 * 
	 */	
	public interface IItemRenderer extends IDisplayObject,IEventDispatcher
	{
		function get data():Object;
		function set data(value:Object):void;
		
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		
		function clear():void;
	}
}