package ui.shipBlueprint 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.primitives.CubeGeometry;
	import characters.Actor;
	import characters.view.ViewController;
	import core.datavalue.model.Moderator;
	import core.datavalue.model.ObjectProxy;
	import core.fileSystem.FsFile;
	import display.SceneController;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import ui.LineDrawer;
	import ui.style.Style;
	import ui.UIComponetBroadcaster;
	
	public class ShipBlueprintPage extends UIComponetBroadcaster
	{
		public var content:FsFile;
		
		private var displayController:SceneController;
		private var view3d:View3D;
		
		private var shipView:ViewController;
		private var shipModelControlPanel:ShipViewControlPanel;
		private var lineDrawer:LineDrawer;
		private var moderator:Moderator;
		private var meshContainer:ObjectContainer3D;
		
		[Inject(id="filesDataModel")]
		public var filesDataModel:ObjectProxy
		
		public function ShipBlueprintPage(style:Style=null) 
		{
			inject(this);
			
			moderator = new Moderator(this, filesDataModel);
			moderator.bind(onFileChange, "openFile");
			
			super(style);
			
			addScope('filePrompt');
		}
		
		private function onFileChange():void 
		{
			if (!(filesDataModel.openFile.content is ObjectContainer3D))
				return;
				
			var obj:ObjectContainer3D = filesDataModel.openFile.content;
			
			
				
			meshContainer.removeChildAt(0);
			meshContainer.addChild(filesDataModel.openFile.content);
		}
		
		override protected function initialize():void 
		{
			meshContainer = new ObjectContainer3D();
			
			meshContainer.addChild(new Mesh(new CubeGeometry(), DefaultMaterialManager.getDefaultMaterial()));
			shipView = new ViewController(meshContainer);
			
			var actor:Actor = new Actor(shipView);
			
			displayController.addDisplayObject(actor);
			
			shipModelControlPanel.selectModel.addEventListener(MouseEvent.CLICK, showFilePromt);
			
			addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}
		
		private function onWheel(e:MouseEvent):void 
		{
			meshContainer.scaleX = meshContainer.scaleY = meshContainer.scaleZ += e.delta;
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
		
		private function showFilePromt(e:MouseEvent):void 
		{
			broadcast(new Event("show"))
		}
		
		private function onModelSelected(e:Event):void 
		{
			
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
			
			var position:Vector3D = new Vector3D(shipView.displayObject.x, shipView.displayObject.y, shipView.displayObject.z);
			position = view3d.project(position);
			
			trace(meshContainer.minX, meshContainer.maxX, meshContainer.minY, meshContainer.maxY);
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF);
			this.graphics.drawRect(
								view3d.x + meshContainer.minX * meshContainer.scaleX / 2 + position.x,
								view3d.y + meshContainer.minY * meshContainer.scaleY / 2 + position.y,
								meshContainer.maxX * meshContainer.scaleX,
								meshContainer.maxY * meshContainer.scaleY);
		}
		
		public function show(content:FsFile):void
		{
			this.content = content;
			
		}
		
	}

}