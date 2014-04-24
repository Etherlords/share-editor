package ui.styles 
{
	import core.datavalue.model.Moderator;
	import core.datavalue.model.ObjectProxy;
	import flash.events.MouseEvent;
	import ui.Button;
	import ui.CheckBox;
	import ui.CheckBoxWithLabel;
	import ui.LineDrawer;
	import ui.LinePath;
	import ui.Progress;
	import ui.ProgressFilled;
	import ui.ScrollBar;
	import ui.Slider;
	import ui.style.Style;
	import ui.style.StylesCollector;
	import ui.Text;
	import ui.TextWidthBackground;
	import ui.UIComponent;
	
	public class ComponentsViewer extends UIComponent 
	{
		private var componentsList:Vector.<Function>;
		private var buttons:Vector.<Button> = new Vector.<Button>
		
		private var _height:Number;
		private var _width:Number;
		
		private var currentSelected:Button;
		private var currentComponent:UIComponent;
		private var dataModel:ObjectProxy;
		
		[Inject]
		public var styles:StylesCollector;
		
		private var moderator:Moderator;
		
		public function ComponentsViewer(width:Number, height:Number, dataModel:ObjectProxy) 
		{
			this.dataModel = dataModel;
			moderator = new Moderator(this, dataModel);
			moderator.bind(previewComponent, "openFile");
			
			inject(this);
			this.width = width;
			this.height = height;
			
			super(null);
		}
		
		override public function get height():Number 
		{
			return _height;
		}
		
		override public function set height(value:Number):void 
		{
			_height = value;
		}
		
		override public function get width():Number 
		{
			return _width;
		}
		
		override public function set width(value:Number):void 
		{
			_width = value;
		}
		
		override protected function preinitialzie():void 
		{
			super.initialize();
			
			componentsList = new Vector.<Function>;
			
			componentsList.push(createComponent(Button), createComponent(CheckBox), createComponent(CheckBoxWithLabel));
			componentsList.push(createComponent(Progress), createComponent(ProgressFilled), createComponent(ScrollBar));
			componentsList.push(createComponent(Slider), createComponent(Text), createComponent(TextWidthBackground));
			componentsList.push(createPath());
		}
		
		private function createPath():Function 
		{
			var f:Function =  function(style:Style):UIComponent
			{
				var linePath:LineDrawer = new LineDrawer(style);
				linePath.path.push(0, 0);
				linePath.path.push(50, 0);
				linePath.path.push(50, 50);
				linePath.path.push(0, 50);
				
				return linePath
			}
			
			f['name'] = LineDrawer['toString']();
			
			return f;
		}
		
		private function createComponent(clazz:Class):Function
		{
			var f:Function = function(style:Style):UIComponent
			{
				return new clazz(style)
			}
			
			f['name'] = clazz.toString();
			
			return f;
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			for (var i:int = 0; i < componentsList.length; i++)
			{
				var name:String = componentsList[i]['name'];
				var button:Button = new Button(styles.getStyle("newsButton"), name.substring(7, name.length-1));
				button.width = 100;
				button.height = 20;
				
				buttons.push(button);
				
				button.addEventListener(MouseEvent.MOUSE_DOWN, onSelectedComponent);
			}
		}
		
		private function onSelectedComponent(e:MouseEvent):void 
		{
			var button:Button = e.target as Button;
			
			if (currentSelected)
				currentSelected.selected = false;
				
			currentSelected = button;
			currentSelected.selected = true;
			
			previewComponent();
		}
		
		private function previewComponent():void
		{
			var constructor:Function;
			for (var i:int = 0; i < buttons.length; i++)
			{
				if (buttons[i] == currentSelected)
					constructor = componentsList[i];
			}
			
			if (currentComponent && currentComponent.parent)
				removeChild(currentComponent);
				
			if (dataModel.openFile && dataModel.openFile.content is Style)
			{
				try
				{
					currentComponent = constructor(dataModel.openFile.content);
					currentComponent.update();
				}
				catch (e:Error)
				{
					return;
				}
				
				addComponent(currentComponent);
				
				currentComponent.y = buttons[buttons.length - 1].y + buttons[buttons.length - 1].height + 2;
			}
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			for (var i:int = 0 ; i < buttons.length; i++)
			{
				this.addChild(buttons[i]);
			}
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			var x:Number = 0;
			var y:Number = 0;
			
			for (var i:int = 0; i < buttons.length; i++)
			{
				if (x + buttons[i].width > _width)
				{
					x = 0;
					y += buttons[i].height;
				}
				
				buttons[i].x = x;
				buttons[i].y = y;
				
				x += buttons[i].width;
			}
		}
		
	}

}