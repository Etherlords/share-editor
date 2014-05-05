package  
{
	import core.fileSystem.Directory;
	import core.fileSystem.external.LocalFileSystem;
	import core.fileSystem.FsFile;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Do not add many objects to queue only preloader ui or some like that
	 */
	
	public class DefaultUIManager extends EventDispatcher
	{
		private var initialLoader:InitialLoader = new InitialLoader();
		private var defaultDir:Directory;
		
		public function DefaultUIManager() 
		{
			var defaultVfs:LocalFileSystem = new LocalFileSystem();
			defaultDir = new Directory();
			
			defaultVfs.directoriesList = defaultDir;
			
			defaultDir.name = '/';
			defaultDir.path = '/'
			
			addToContext(defaultVfs);
			
			initialLoader.addEventListener('progress', onFileLoaded)
			initialLoader.addEventListener(Event.COMPLETE, onAllLoadingDone)
			
			initialLoader.addToLoad('/default/background.png');
			initialLoader.addToLoad('/default/progress.png');
		}
		
		private function onFileLoaded(e:Event):void 
		{
			var fileName:String = initialLoader.currentFile;
			fileName = fileName.substr(fileName.lastIndexOf('/')+1);
			
			defaultDir.addItem(fileName, new FsFile(fileName, '', getContent(initialLoader.crrentContent)));
		}
		
		private function getContent(crrentContent:Object):Object 
		{
			if (crrentContent is Bitmap)
				return crrentContent.bitmapData;
			else
				return crrentContent;
		}
		
		private function onAllLoadingDone(e:Event):void 
		{
			dispatchEvent(e);
		}
		
	}

}