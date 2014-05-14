package ui.shipBlueprint 
{
	import characters.view.Socket;
	import core.datavalue.model.Moderator;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldType;
	import ui.CheckBox;
	import ui.effects.OverEffect;
	import ui.style.Style;
	import ui.TextWidthBackground;
	import ui.UIComponent;
	
	public class ShipSlotControllerView extends UIComponent 
	{
		private var slotTypeName:TextWidthBackground;
		private var slotName:TextWidthBackground;
		private var selectedView:CheckBox;
		private var moderator:Moderator;
		
		private var background:ScaleBitmap;
		
		private var _selected:Boolean = false;
		
		public var socket:Socket;
		
		public function ShipSlotControllerView(style:Style = null, socket:Socket = null, _width:Number = 100) 
		{
			this._width = _width;
			this.socket = socket;
			
			super(style);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			slotName.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			setEffect(new OverEffect());
		}
		
		override protected function configureChildren():void 
		{
			super.configureChildren();
			
			slotName.mouseInteraction = false;
			slotTypeName.mouseInteraction = false;
		}
		
		private function onTextInput(e:TextEvent):void 
		{
			
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			background = new ScaleBitmap(vfs.getFile('res/textures/ui/frame.png').content, "auto", false, new Rectangle(1, 1, 1, 1));
			slotName = new TextWidthBackground(styles.getStyle('newsTextFormat'));
			slotName.type = TextFieldType.INPUT;
			slotTypeName = new TextWidthBackground(styles.getStyle('newsTextFormat'));
			selectedView = new CheckBox(styles.getStyle("checkBoxStyle"), false);
			
			slotName.text = 'Name';
			slotTypeName.text = "Type";
		}
		
		override public function update():void 
		{
			super.update();
			
			slotName.text = socket.name;
			slotTypeName.text = socket.type.toString();
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addChild(background);
			addComponent(slotName);
			addComponent(slotTypeName);
			addComponent(selectedView);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			selectedView.x = 4;
			
			slotName.y = slotTypeName.y = 4;
			
			slotName.x = selectedView.x + selectedView.width + 4;
			slotTypeName.x = slotName.x + slotName.width + 4;
			
			this.height = slotTypeName.height + 8;
			
			slotTypeName.width = width - slotTypeName.x;
			
			selectedView.y = (this.height - selectedView.height) / 2;
			
			background.setSize(width, height);
		}
		
		public function get selected():Boolean 
		{
			return selectedView.selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			selectedView.selected = value;
		}
	}

}