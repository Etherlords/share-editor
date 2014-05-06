package ui.shipBlueprint 
{
	import flash.geom.Rectangle;
	import ui.Button;
	import ui.style.Style;
	import ui.UIComponent;
	
	public class ShipViewControlPanel extends UIComponent 
	{
		public var selectModel:Button;
		public var clearAll:Button;
		private var background:ScaleBitmap;
		
		public function ShipViewControlPanel(style:Style=null) 
		{
			super(style);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			var buttonStyle:Style = styles.getStyle("mainMenuButton");
			
			background = new ScaleBitmap(vfs.getFile('res/textures/ui/frame.png').content, "auto", false, new Rectangle(1, 1, 1, 1));
			selectModel = new Button(buttonStyle, 'Select Model');
			clearAll = new Button(buttonStyle, 'Clear All');
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addChild(background)
			addComponent(selectModel);
			addComponent(clearAll);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			selectModel.width = clearAll.width = 80;
			selectModel.height = clearAll.height = 30;
			
			selectModel.x = 5;
			selectModel.y = 5;
			clearAll.x = selectModel.x + selectModel.width + 5;
			clearAll.y = selectModel.y;
			
			width = clearAll.x + clearAll.width + 5;
			height = clearAll.y + clearAll.height + 5;
			
			background.setSize(width, height)
		}
		
	}

}