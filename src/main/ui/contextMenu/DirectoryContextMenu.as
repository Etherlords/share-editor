package ui.contextMenu 
{

	public class DirectoryContextMenu extends ContextMenuModel 
	{
		
		public function DirectoryContextMenu() 
		{
			super();
			
			initialize();
		}
		
		private function initialize():void 
		{
			
			var createTypeMenu:ContextMenuModel = new ContextMenuModel();
			createTypeMenu.addItem(new ContextItem("New style file...", "style"));
			createTypeMenu.addItem(new ContextItem("New png file...", "png"));
			createTypeMenu.addItem(new ContextItem("New jpg file...", "jpg"));
			addItem(new ContextItem("Create...", '', createTypeMenu));
		}
		
	}

}