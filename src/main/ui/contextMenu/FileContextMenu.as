package ui.contextMenu 
{

	public class FileContextMenu extends ContextMenuModel 
	{
		
		public function FileContextMenu() 
		{
			super();
			
			initialize();
		}
		
		private function initialize():void 
		{
			addItem(new ContextItem("Delete", "delete"));
		}
		
	}

}