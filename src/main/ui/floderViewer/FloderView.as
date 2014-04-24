package ui.floderViewer 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import ui.effects.OverEffect;
	import ui.UIComponent;
	
	public class FloderView extends UIComponent 
	{
		private var _selected:Boolean = false;
		
		private var chrome:ScaleBitmap;
		
		private var _bitmapData:BitmapData;
		private var backGround:Bitmap;
		private var size:Number;
		private var label:TextField;
		private var _name:String;
		public var file:Object;
		
		public function FloderView(file:Object, bitmapData:BitmapData = null, size:Number = 32, name:String = 'default') 
		{
			this.file = file;
			this._name = name;
			this.size = size;
			_bitmapData = bitmapData;
			
			_width = size;
			_height = size;
			
			super(style);
		}
		
		override protected function buildStyleSheet():void 
		{
			super.buildStyleSheet();
			
			setEffect(new OverEffect());
		}
		
		override protected function configureChildren():void 
		{
			super.configureChildren();
			backGround.width = backGround.height = size;
			
			chrome.visible = _selected;
			
			var format:TextFormat = new TextFormat(null, null,  null, null, null, null, null, null, TextFormatAlign.CENTER);
			label.defaultTextFormat = format
			label.width = size;
			//label.height = 40;
			label.multiline = true;
			label.wordWrap = true;
			
			label.background = true;
			label.backgroundColor = 0xFFFFFF;
			
			label.text = _name;
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			backGround = new Bitmap(_bitmapData);
			label = new TextField();
			
			var chromePattern:BitmapData = new BitmapData(3, 3, false, 0xAAAAFF);
			chromePattern.setPixel(1, 1, 0x6666FF);
			
			chrome = new ScaleBitmap(chromePattern);
			chrome.scale9Grid = new Rectangle(1, 1, 1, 1);
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addChild(chrome);
			addChild(backGround);
			addChild(label);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			label.height = label.textHeight + 5;
			label.x = (backGround.width - label.width) / 2;
			label.y = backGround.height;
		}
		
		public function get bitmapData():BitmapData 
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void 
		{
			_bitmapData = value;
			backGround.bitmapData = value;
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
			
			chrome.visible = _selected;
			
			if (_selected)
			{
				chrome.setSize(this.width, this.height);
			}
		}
		
	}

}