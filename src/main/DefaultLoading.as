package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class DefaultLoading extends Sprite 
	{
		private var loadingProgress:String = '...';
		private var loaderText:String = "Now loading"
		private var text:TextField;
		
		private var i:int = 0;
		
		private var frameSkip:int = 15;
		private var frame:int = 0;
		
		public function DefaultLoading() 
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			text = new TextField();
			text.defaultTextFormat = new TextFormat('FixedSys', 15, 0xFFFFFF);
			
			text.autoSize = TextFieldAutoSize.LEFT;
			
			addChild(text);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			
			text.text = loaderText;
			
			text.x = (stage.stageWidth - text.textWidth) / 2;
			text.y = (stage.stageHeight - text.textHeight) / 2;
		}
		
		private function onFrame(e:Event = null):void 
		{
			frame++;
			
			if (frameSkip != frame)
			{
				return;
			}
			
			frame = 0;
			i++;
			
			if (i > loadingProgress.length)
				i = 0;
			
			text.text = loaderText + loadingProgress.substr(0, i);
			
		
		}
		
	}

}