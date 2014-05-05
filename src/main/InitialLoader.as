package  
{
	import flash.display.Loader;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	public class InitialLoader extends EventDispatcher 
	{
		private var loader:Loader = new Loader();
		private var isLoadProgress:Boolean = false;
		private var queue:Vector.<String> = new Vector.<String>;
		
		public var currentFile:String;
		public var crrentContent:Object;
		
		public function InitialLoader() 
		{
			super();
			
			initialize();
		}
		
		private function initialize():void 
		{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			crrentContent = loader.content;
			currentFile = queue.shift();
			
			dispatchEvent(new Event("progress"));
			
			loadCurrent();
		}
		
		public function addToLoad(url:String):void
		{
			addToQueue(url);
			
			if (!isLoadProgress)
				loadCurrent();	
		}
		
		private function addToQueue(url:String):void 
		{
			queue.push(url);
		}
		
		private function loadCurrent():void 
		{
			if (queue.length)
			{
				isLoadProgress = true
				loader.load(new URLRequest(queue[0]));
			}
			else
			{
				isLoadProgress = false;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}

}