package ui.contextMenu.events 
{
	import flash.events.Event;
	import ui.contextMenu.ContextItem;
	
	public class ContextMenuEvent extends Event 
	{
		public static var SELECT_ITEM:String = 'selectContextMenuItem';
		
		public var selectedItem:ContextItem;
		
		public function ContextMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, selectedItem:ContextItem = null) 
		{
			super(type, bubbles, cancelable);
			this.selectedItem = selectedItem;
		}
		
		override public function clone():Event 
		{
			return new ContextMenuEvent(type, bubbles, cancelable, selectedItem);
		}
		
	}

}