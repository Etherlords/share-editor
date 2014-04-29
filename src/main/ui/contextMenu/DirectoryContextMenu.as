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
			createTypeMenu.addItem(new ContextItem("New style file...", "newStyle"));
			createTypeMenu.addItem(new ContextItem("New png file...", "newPng"));
			createTypeMenu.addItem(new ContextItem("New jpg file...", "newJpg"));
			addItem(new ContextItem("Create...", '', createTypeMenu));
		}
		
	}

}