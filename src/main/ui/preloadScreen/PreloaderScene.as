package ui.preloadScreen 
{
	import flash.events.ProgressEvent;
	import ui.scenes.AbstractScene;
	import ui.style.StylesCollector;
	
	public class PreloaderScene extends AbstractScene 
	{
		
		public var styles:StylesCollector;
		private var preloadScreenView:PreloadScreenView;
		
		public function PreloaderScene() 
		{
			super();
		}
		
		override public function initialize():void 
		{
			describe('vfs', ProgressEvent.PROGRESS, onLoadProgress);
			
			preloadScreenView = new PreloadScreenView()
			sceneView = preloadScreenView;
		}
		
		private function onLoadProgress(e:ProgressEvent):void 
		{
			preloadScreenView.progress = e.bytesLoaded / e.bytesTotal;
		}
		
	}

}