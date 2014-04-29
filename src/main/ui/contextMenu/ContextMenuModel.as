package ui.contextMenu 
{
	public class ContextMenuModel 
	{
		public var items:Vector.<ContextItem> = new Vector.<ContextItem>;
		
		public function ContextMenuModel() 
		{
			
		}
		
		public function addItem(item:ContextItem):void
		{
			items.push(item);
		}
		
		public function get length():int
		{
			return items.length;
		}
	}

}