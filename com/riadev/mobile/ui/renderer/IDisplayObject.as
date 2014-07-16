package com.riadev.mobile.ui.renderer
{
	/**
	 * 显示对象接口
	 * @author NeoGuo
	 * 
	 */	
	public interface IDisplayObject
	{
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get alpha():Number;
		function set alpha(value:Number):void;
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
	}
}