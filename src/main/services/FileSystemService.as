package services 
{
	import core.fileSystem.Directory;
	import core.fileSystem.FsFile;
	import core.fileSystem.IFS;
	import core.services.IService;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class FileSystemService extends EventDispatcher implements IService 
	{
		[Inject]
		public var vfs:IFS;
		
		public function FileSystemService() 
		{
			
		}
		
		public function deleteFile(file:FsFile):void
		{
			
		}
		
		public function createFile(extension:String, parent:Directory, name:String = "New File"):void
		{
			var fsFile:FsFile = new FsFile();
			fsFile.extension = extension;
			fsFile.name = name;
			fsFile.parent = parent;
			
			fsFile.content = buildFileContent(extension);
		}
		
		private function buildFileContent(extension:String):Object 
		{
			
		}
		
		
	}

}