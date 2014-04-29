package ui.tree 
{
	import core.fileSystem.Directory;
	import core.fileSystem.IFS;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import ui.events.FloderEvent;
	import ui.ScrollBar;
	import ui.ScrollContainer;
	import ui.style.Style;
	import ui.style.StylesCollector;
	import ui.UIComponent;
	
	public class Tree extends UIComponent 
	{
		private var directory:Directory;
		private var scrollContainer:ScrollContainer;
		private var floderElement:FloderElement;
		private var background:ScaleBitmap;
		
		private var selectedItem:TreeElement;
		
		public function Tree(style:Style=null, directory:Directory = null, width:Number = 200, height:Number = 500) 
		{
			_height = height;
			_width = width;
			
			this.directory = directory;
			super(style);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			var scrollStyle:Style = new Style();
			scrollStyle.fillStyle(new <String>[
				"background=@res/textures/ui/scroll/background.png", "slider=@res/textures/ui/scroll/slider.png",
			]);
			
			var contianerStyle:Style = new Style();
			contianerStyle.fillStyle(new <String>[
				"background=@res/textures/ui/frame.png"
			]);
			
			background = new ScaleBitmap(vfs.getFile("res/textures/ui/frame.png").content);
			var scrollBar:ScrollBar = new ScrollBar(scrollStyle)
			scrollContainer = new ScrollContainer(contianerStyle, scrollBar, _width - 3, _height - 2);
			
			floderElement = new FloderElement(null, directory);
			floderElement.open();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			floderElement.addEventListener(Event.CHANGE, onChangeFloders);
			floderElement.addEventListener(FloderEvent.OPEN, onOpen);
			floderElement.addEventListener(FloderEvent.SELECT, onSelect);
		}
		
		private function onSelect(e:FloderEvent):void 
		{
			if (selectedItem)
				selectedItem.selected = false;
				
			selectedItem = e.target as TreeElement;
			selectedItem.selected = true;
		}
		
		private function onOpen(e:FloderEvent):void 
		{
			
		}
		
		private function onChangeFloders(e:Event):void 
		{
			
		}
		
		override protected function configureChildren():void 
		{
			super.configureChildren();
			
			background.scale9Grid = new Rectangle(1, 1, 1, 1);
			scrollContainer.content = floderElement;
			setSize(_width, _height);
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addChild(background);
			addComponent(scrollContainer);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			scrollContainer.setSize(_width - 3, _height - 3);
			background.setSize(_width, _height);
			
			scrollContainer.x = 3;
			scrollContainer.y = 1;
		}
	}

}