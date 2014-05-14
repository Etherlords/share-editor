package  
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.System;
	import ui.style.StylesCollector;
	
	public class ComponentsStartUp extends Sprite 
	{
		private static const classRef:ClassesRef = new ClassesRef();
		private var defaultLoading:DefaultLoading;
		
		public function ComponentsStartUp() 
		{
			super();
			
			if (stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			stage.align = 'TL';
			stage.scaleMode = 'noScale';
			
			var defaultUI:DefaultUIManager = new DefaultUIManager();
			defaultUI.addEventListener(Event.COMPLETE, onDefaultUIReady);
			
			defaultLoading = new DefaultLoading();
			
			addChild(defaultLoading);
			
			addToContext(stage);
			
			NativeApplication.nativeApplication.openedWindows[0].width = Capabilities.screenResolutionX
			NativeApplication.nativeApplication.openedWindows[0].height = Capabilities.screenResolutionY
		}
		
		private function onDefaultUIReady(e:Event):void 
		{
			removeChild(defaultLoading);
			
			addToContext(StylesCollector.instance);
			
			var XMLBootsTrap:XMLBootstrap = new XMLBootstrap();
			XMLBootsTrap.loadConfig('./config/main.xml');
		}
		
	}

}