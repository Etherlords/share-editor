package ui.shipBlueprint 
{
	import away3d.containers.View3D;
	import display.SceneController;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import ui.style.Style;
	import ui.UIComponent;
	
	public class ShipBlueprintPage extends UIComponent 
	{
		private var displayController:SceneController;
		
		public function ShipBlueprintPage(style:Style=null) 
		{
			super(style);
		}
		
		private function createViewport():void
		{
			view = new View3D(null, null, null, false, Context3DProfile.BASELINE_EXTENDED);
			view.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			view.antiAlias = 100;
			
			displayController = new SceneController(view);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			createViewport();
		}
		
		override public function update():void 
		{
			super.update();
			
			displayController.update();
		}
		
		public function show():void
		{
			
		}
		
	}

}