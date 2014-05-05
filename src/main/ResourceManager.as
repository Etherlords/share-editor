package  
{
	import core.broadcasting.AbstractEventBroadcaster;
	import core.fileSystem.events.FileEvent;
	import core.fileSystem.external.IDirectoryScaner;
	import core.fileSystem.IFS;
	import core.services.FileLoadingService;
	import flash.events.Event;
	import flash.events.ProgressEvent;

	public class ResourceManager extends AbstractEventBroadcaster
	{
		[Inject]
		public var directoryScaner:IDirectoryScaner;
		
		[Inject]
		public var fileSystem:IFS;
		
		[Inject]
		public var fileLoadingService:FileLoadingService;
		
		public function ResourceManager() 
		{
			
		}
		
		public function initialize():void
		{
			directoryScaner.addEventListener(Event.COMPLETE, onScanComplete);
		}
		
		private function onScanComplete(e:Event):void 
		{
			fileLoadingService.loadFiles(fileSystem.directoriesList);
			fileLoadingService.addEventListener(Event.COMPLETE, onLoadingComplete);
			fileLoadingService.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
		}
		
		private function onLoadingComplete(e:Event):void 
		{
			broadcast(e);
		}
		
		private function onLoadProgress(e:ProgressEvent):void 
		{
			broadcast(e);
		}
		
	}

}