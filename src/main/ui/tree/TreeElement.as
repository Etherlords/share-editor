package ui.tree 
{
	import core.fileSystem.IFile;
	import core.fileSystem.IFS;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import ui.events.FloderEvent;
	import ui.floderViewer.IconsFactory;
	import ui.style.Style;
	import ui.style.StylesCollector;
	import ui.Text;
	import ui.UIComponent;
	
	public class TreeElement extends UIComponent 
	{
		protected var size:Number;
		protected var item:IFile;
		
		private var status:Bitmap;
		
		protected var selectedBackground:ScaleBitmap;
		protected var background:Bitmap;
		protected var text:Text;
		
		[Inject]
		public var iconFactory:IconsFactory;
		
		[Inject]
		public var styles:StylesCollector;
		
		[Inject]
		public var vfs:IFS;
		
		private var _selected:Boolean;
		
		public function TreeElement(style:Style=null, item:IFile = null, size:Number = 16) 
		{
			this.item = item;
			this.size = size;
			
			inject(this);
			
			super(style);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			this.doubleClickEnabled = true;
			
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.CONTEXT_MENU, onRightClick);
		}
		
		private function onRightClick(e:MouseEvent):void 
		{
			e.preventDefault();
			e.stopImmediatePropagation();
			
			if (e.target != this)
				return;
				
			if (!_selected)
				dispatchEvent(new FloderEvent(FloderEvent.SELECT, true, false, item));
				
			dispatchEvent(new FloderEvent(FloderEvent.CONTEXT_MENU, true, false, item));	
		}
		
		protected function onClick(e:MouseEvent):void 
		{
			if (e.target != this)
				return;
				
			if (this._selected)
				return;
			
			dispatchEvent(new FloderEvent(FloderEvent.SELECT, true, false, item));
		}
		
		protected function onDoubleClick(e:MouseEvent):void 
		{
			if (e.target != this)
				return;
				
			openOperation();
		}
		
		protected function openOperation():void
		{
			dispatchEvent(new FloderEvent(FloderEvent.OPEN, true, false, item));
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			background = new Bitmap(iconFactory.getIcon(item));
			selectedBackground = new ScaleBitmap(vfs.getFile("res/textures/ui/frame.png").content);
			
			text = new Text(styles.getStyle("standartText"));
			
			text.width = 200;
			text.mouseEnabled = false;
			text.mouseChildren = false;
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addChild(selectedBackground);
			addChild(background);
			
			addComponent(text);
		}
		
		override protected function configureChildren():void 
		{
			super.configureChildren();
			
			text.text = item.name;
			background.width = background.height = size;
			selectedBackground.scale9Grid = new Rectangle(1, 1, 1, 1);
			selectedBackground.setSize(text.width, text.height);
			//background.width = background.height = size;
			selectedBackground.visible = false;
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			background.x = 18;
			text.x = background.width + background.x;
			text.y = (background.height - text.height) / 2;
			
			selectedBackground.x = text.x;
			selectedBackground.y = text.y;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if (_selected == value)
				return;
			
			_selected = value;
			
			selectedBackground.visible = value;
		}
		
	}

}