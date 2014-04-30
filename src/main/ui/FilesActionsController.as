package ui 
{
	import core.fileSystem.Directory;
	import services.FileSystemService;
	import ui.contextMenu.events.ContextMenuEvent;

	public class FilesActionsController 
	{
		[Inject]
		public var fileSystemService:FileSystemService;
		
		private var fileActionsMap:Object = { };
		
		public function FilesActionsController() 
		{
			
		}
		
		public function initialize():void 
		{
			
		}
		
		public function invorkFileContextMenuCommand(e:ContextMenuEvent):void 
		{
			trace(e);
			var ident:String = e.selectedItem.ident;
			if (ident && ident != 'delete')
			{
				fileSystemService.createFile(ident, e.extradata as Directory);
			}
		}
		
	}

}