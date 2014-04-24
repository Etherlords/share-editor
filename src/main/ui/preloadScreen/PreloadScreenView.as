package ui.preloadScreen 
{
	import flash.events.Event;
	import ui.Progress;
	import ui.style.StylesCollector;
	import ui.UIContainer;
	
	public class PreloadScreenView extends UIContainer 
	{
		private var progressBar:Progress;
		
		[Inject]
		public var styleCollector:StylesCollector;
		
		public function PreloadScreenView() 
		{
			inject(this);
			super();
		}
		
		public function set progress(value:Number):void
		{
			progressBar.progress = value;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			progressBar.x = (stage.stageWidth - progressBar.width) / 2;
			progressBar.y = (stage.stageHeight - progressBar.height) / 2 + 0.5;
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			progressBar = new Progress(styleCollector.getStyle("preloadProgress"));
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addComponent(progressBar);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			//progressBar.x = 
		}
		
	}

}