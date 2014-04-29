package ui.styles 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import ui.ImageViewer;
	import ui.style.Style;
	import ui.Text;
	import ui.TextWidthBackground;
	import ui.UIComponent;
	
	public class StylesViewer extends UIComponent 
	{
		private var uiElements:Vector.<UIComponent> = new Vector.<UIComponent>;
		private var background:ScaleBitmap;
		
		public var invaildLayaut:Boolean = true;
		
		public function StylesViewer(style:Style=null) 
		{
			super(style);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			background = new ScaleBitmap(vfs.getFile("res/textures/ui/frame.png").content);
			background.scale9Grid = new Rectangle(1, 1, 1, 1);
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			addChild(background);
		}
		
		public function showStyle(style:Style):void
		{
			invaildLayaut = true;
			for (var i:int = 0; i < uiElements.length; i++)
			{
				removeComponent(uiElements[i]);
			}
			
			uiElements = new Vector.<UIComponent>;
			
			for (var field:String in style.styles)
			{
				showField(style.styles[field], field);
			}
			
			update();
		}
		
		private function showField(fieldObject:Object, field:String):void 
		{
			var uiElement:UIComponent;
			if (fieldObject is BitmapData)
			{
				uiElement = showImage(fieldObject as BitmapData, field);
				uiElement.addEventListener(MouseEvent.CLICK, onElementClick);
			}
			else
			{
				uiElement = showAsText(fieldObject, field);
				uiElement.addEventListener(MouseEvent.CLICK, onElementClick);
			}
			
			
		}
		
		private function onElementClick(e:MouseEvent):void 
		{
			trace(e.target, e.currentTarget);
		}
		
		private function showImage(bitmapData:BitmapData, field:String):UIComponent
		{
			var uiComponent:ImageViewer = new ImageViewer(bitmapData);// , bitmapData.width, bitmapData.height);
			pushComponent(uiComponent, field);
			return uiComponent;
		}
		
		private function showAsText(value:Object, field:String):UIComponent
		{		
			var uiComponent:TextWidthBackground = new TextWidthBackground(styles.getStyle("componentsSceneText"));
			uiComponent.text = value.toString();
			pushComponent(uiComponent, field);
			
			return uiComponent;
		}
		
		private function pushComponent(uiComponent:UIComponent, field:String):void
		{
			uiElements.push(uiComponent);
			addComponent(uiComponent);
			
			var nameField:TextWidthBackground = new TextWidthBackground(styles.getStyle("componentsSceneText"));
			nameField.text = field;
			
			uiElements.push(nameField);
			addComponent(nameField);
		}
		
		override public function update():void 
		{
			super.update();
			
			validateLayout();
		}
		
		private function validateLayout():void
		{
			if (!invaildLayaut)
				return;
				
			invaildLayaut = false;
			
			var y:Number = 1;
			var x:Number = 1;
			
			//uiElements = uiElements.sort(sortOnType);
			
			for (var i:int = 0; i < uiElements.length; i++)
			{
				
				if (i % 2 == 1)
				{
					uiElements[i].x = x;
					uiElements[i].y = y;
					x = 1;
					y += uiElements[i-1].height + 5;
				}
				else
				{
					uiElements[i].x = x;
					uiElements[i].y = y;
					
					x += uiElements[i].width + 2;
				}
			}
			
			background.setSize(502, y - 4);
		}
		
		private function sortOnType(a:Object, b:Object):Number 
		{
			if (a is Text && !(b is Text))
				return 1;
			else if(a is Text && b is Text)
				return 0;
			else
				return -1;
		}
		
	}

}