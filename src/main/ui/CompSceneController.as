package ui 
{
	import display.ui.DisplayManager;
	import flash.events.Event;
	import ui.style.StylesCollector;
	
	public class CompSceneController 
	{
		[Inject]
		public var styleCollector:StylesCollector;
		
		public var displayManager:DisplayManager;
		
		
		public function CompSceneController() 
		{
			
		}
		
		public function initialize():void 
		{
			describe('vfs', Event.COMPLETE, onVfsReady);
			
			displayManager.scene = "preloaderScene";
		}
		
		private function onVfsReady(e:Event):void 
		{
			styleCollector.currentStyles();
			
			displayManager.scene = "componentsScene";
		}
		
	}

}