package ui.shipBlueprint 
{
	import characters.view.Socket;
	import core.datavalue.model.ObjectProxy;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import ui.Button;
	import ui.CheckBox;
	import ui.ScrollBar;
	import ui.ScrollContainer;
	import ui.style.Style;
	import ui.UIComponent;

	
	public class ShipSlotsController extends UIComponent 
	{
		private var background1:ScaleBitmap;
		private var background2:ScaleBitmap;
		
		public var addSlot:Button;
		public var deleteSlot:Button;
		
		private var slotsList:ScrollContainer;
		private var slotsListContainer:UIComponent;
		private var slotDataModel:ObjectProxy;
		
		public function ShipSlotsController(style:Style=null, slotDataModel:ObjectProxy = null, _width:Number = 200, _height:Number = 400) 
		{
			this.slotDataModel = slotDataModel;
			this._height = _height;
			this._width = _width;
			
			super(style);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			var buttonStyle:Style = styles.getStyle("mainMenuButton");
			
			background1 = new ScaleBitmap(vfs.getFile('res/textures/ui/frame.png').content, "auto", false, new Rectangle(1, 1, 1, 1));
			background2 = new ScaleBitmap(vfs.getFile('res/textures/ui/frame.png').content, "auto", false, new Rectangle(1, 1, 1, 1));
			
			addSlot = new Button(buttonStyle, 'Add');
			deleteSlot = new Button(buttonStyle, 'Remove');
			
			addSlot.width = deleteSlot.width = 80;
			addSlot.height = deleteSlot.height = 30;
			
			var scroll:ScrollBar = new ScrollBar(styles.getStyle('newsScrolStyle'));
			slotsList = new ScrollContainer(null, scroll, width, height - addSlot.height - 4 - 2);
			
			slotsListContainer = new UIComponent();
			slotsList.content = slotsListContainer;
		}
		
		private function realignSlots():void
		{
			var __y:Number = 0;
			for (var i:int = 0; i < slotsListContainer.numChildren; i++)
			{
				slotsListContainer.getChildAt(i).y = __y;
				
				__y += slotsListContainer.getChildAt(i).height + 4;
			}
			
			slotsListContainer.height = __y;
		}
		
		public function addSlotView(socket:Socket):void
		{
			var slotComponent:ShipSlotControllerView = new ShipSlotControllerView(null, socket, this.width);
			slotsListContainer.addComponent(slotComponent);
			
			slotComponent.addEventListener(MouseEvent.MOUSE_OVER, onSlotMouseOver);
			slotComponent.addEventListener(MouseEvent.MOUSE_OUT, onSlotOut);
			slotComponent.addEventListener(MouseEvent.CLICK, onSlotChoosed);
			
			invalidateLayout();
		}
		
		private function onSlotOut(e:MouseEvent):void 
		{
			slotDataModel.hightLightedSlot = null;
		}
		
		private function onSlotChoosed(e:MouseEvent):void 
		{
			if (e.target is CheckBox)
				return;
				
			var slotView:ShipSlotControllerView = e.currentTarget as ShipSlotControllerView;
			slotDataModel.selectedSlot = slotView.socket;
		}
		
		private function onSlotMouseOver(e:MouseEvent):void 
		{
			var slotView:ShipSlotControllerView = e.currentTarget as ShipSlotControllerView;
			slotDataModel.hightLightedSlot = slotView.socket;
		}
		
		public function clear():void
		{
			slotsListContainer.removeComponents();
		}
		
		public function removeSlotView(socket:Socket):Boolean 
		{
			var b:Boolean = false;
			
			for (var i:int = 0; i < slotsListContainer.numChildren; i++)
			{
				var shipSlotView:ShipSlotControllerView = (slotsListContainer.getChildAt(i) as ShipSlotControllerView);
				if (shipSlotView.socket == socket && shipSlotView.selected)
				{
					b = true;
					slotsListContainer.removeChildAt(i);
					break;
				}
			}
			
			if(b)
				realignSlots();
				
			return b;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addChild(background1);
			addChild(background2);
			
			addComponent(slotsList);
			addComponent(addSlot);
			addComponent(deleteSlot);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			realignSlots();
			
			addSlot.x = 2;
			addSlot.y = height - addSlot.height ;
			deleteSlot.x = addSlot.x + addSlot.width + 2;
			deleteSlot.y = addSlot.y;
			
			slotsList.y = 1;
			
			background2.y = addSlot.y - 2;
			
			background1.setSize(width, slotsList.height + 2);
			background2.setSize(width, addSlot.height + 4);
			
			//this.height += 2;
		}
	}

}