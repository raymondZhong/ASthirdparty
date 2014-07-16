package com.riadev.mobile.events
{
	import flash.events.Event;
	
	public class DataChangeEvent extends Event
	{
		public static const ITEM_CHANGE:String = "itemChange";
		
		public var selectedItem:Object;
		
		public function DataChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var evt:DataChangeEvent = new DataChangeEvent(type,bubbles,cancelable);
			evt.selectedItem = selectedItem;
			return evt;
		}
		
	}
}