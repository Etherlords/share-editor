package ui.shipBlueprint 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.primitives.CubeGeometry;
	import characters.Actor;
	import characters.view.ViewController;
	import core.fileSystem.FsFile;
	import display.SceneController;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import ui.LineDrawer;
	import ui.style.Style;
	import ui.UIComponent;
	
	public class ShipBlueprintPage extends UIComponent 
	{
		public var content:FsFile;
		
		private var displayController:SceneController;
		private var view3d:View3D;
		
		private var shipView:ViewController;
		private var shipModelControlPanel:ShipViewControlPanel;
		private var lineDrawer:LineDrawer;
		
		public function ShipBlueprintPage(style:Style=null) 
		{
			super(style);
			
			initialize();
		}
		
		private function initialize():void 
		{
			var obj:ObjectContainer3D = new ObjectContainer3D();
			
			obj.addChild(new Mesh(new CubeGeometry(), DefaultMaterialManager.getDefaultMaterial()));
			shipView = new ViewController(obj);
			
			var actor:Actor = new Actor(shipView);
			
			displayController.addDisplayObject(actor);
		}
		
		private function createViewport():void
		{
			view3d = new View3D(null, null, null, false, Context3DProfile.BASELINE_EXTENDED);
			view3d.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			
			view3d.antiAlias = 100;
			addChild(view3d);
			
			view3d.width = 500;
			view3d.height = 400;
			
			displayController = new SceneController(view3d);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			view3d.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			view3d.stage3DProxy.clear();
			view3d.stage3DProxy.present();
			//removeChild(view3d);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			view3d.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			createViewport();
			
			shipModelControlPanel = new ShipViewControlPanel();
			lineDrawer = new LineDrawer(styles.getStyle("mainMenu"), null, true);
		}
		
		override protected function configureChildren():void 
		{
			super.configureChildren();
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addComponent(shipModelControlPanel);
			addComponent(lineDrawer);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			shipModelControlPanel.x = shipModelControlPanel.y = 25;
			view3d.y = shipModelControlPanel.y + shipModelControlPanel.height;
			view3d.x = shipModelControlPanel.x;
			
			lineDrawer.path.clear();
			lineDrawer.path.push(view3d.x, view3d.y);
			lineDrawer.path.push(view3d.x + view3d.width, view3d.y);
			lineDrawer.path.push(view3d.x + view3d.width, view3d.y + view3d.height);
			lineDrawer.path.push(view3d.x, view3d.y + view3d.height);
		}
		
		override public function update():void 
		{
			super.update();
			
			displayController.update();
			
			shipView.displayObject.rotationX++;
		}
		
		public function show(content:FsFile):void
		{
			this.content = content;
			
		}
		
	}

}