package services 
{
	import core.fileSystem.Directory;
	import core.fileSystem.FsFile;
	import core.fileSystem.IFS;
	import core.services.IService;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	public class FileSystemService extends EventDispatcher implements IService 
	{
		[Inject]
		public var vfs:IFS;
		
		private var fileCreationStrategies:Object = { };
		
		public function FileSystemService() 
		{
			fileCreationStrategies['png'] = createPngFile;
			fileCreationStrategies['jpg'] = createJpgFile;
			fileCreationStrategies['style'] = createStyleFile;
			fileCreationStrategies['ship'] = createShipFile;
		}
		
		public function createFile(extension:String, parent:Directory, name:String = "New File"):void
		{
			var fsFile:FsFile = new FsFile();
			fsFile.extension = extension;
			fsFile.name = name;
			fsFile.parent = parent;
			fsFile.nativeContent = new ByteArray();
			
			fsFile.content = buildFileContent(extension);
		}
		
		private function buildFileContent(extension:String):Object 
		{
			return fileCreationStrategies[extension]();
		}
		
		private function createPngFile():void 
		{
			trace('create png');
		}
		
		private function createJpgFile():void 
		{
			
		}
		
		private function createStyleFile():void 
		{
			
		}
		
		private function createShipFile():void 
		{
			
		}
		
		public function deleteFile(file:FsFile):void
		{
			
		}
		
		
	}

}