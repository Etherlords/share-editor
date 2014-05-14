package ui.shipBlueprint 
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.DirectionalLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.ColorMultiPassMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.WireframeCube;
	import characters.Actor;
	import characters.view.Socket;
	import characters.view.ViewController;
	import core.datavalue.model.Moderator;
	import core.datavalue.model.ObjectProxy;
	import core.Delegate;
	import core.fileSystem.Directory;
	import core.fileSystem.FsFile;
	import display.SceneController;
	import flash.display.Stage;
	import flash.display3D.Context3DProfile;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import ui.Button;
	import ui.LineDrawer;
	import ui.style.Style;
	import ui.UIComponetBroadcaster;
	
	public class ShipBlueprintPage extends UIComponetBroadcaster
	{
		static private const NORMAL_SOCKET_COLOR:Number = 0x9999FF;
		static private const SELECTED_SOCKET_COLOR:Number = 0x3333FF;
		
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
		
		private var defaultMaterial:ColorMultiPassMaterial = new ColorMultiPassMaterial();
		private var shipSlotControll:ShipSlotsController;
		private var saveButton:Button;
		private var saveAsButton:Button;
		
		private var socketsList:Vector.<Socket> = new Vector.<Socket>;
		
		private var slotDataModel:ObjectProxy = new ObjectProxy(true);
		
		private var slotsModerator:Moderator;
		private var slotEditPanel:SlotEditPanel;
		
		[Inject]
		public var __stage:Stage
		
		public function ShipBlueprintPage(style:Style=null) 
		{
			inject(this);
			
			slotsModerator = new Moderator(this, slotDataModel);
			slotsModerator.bind(onSlotSelected, 'selectedSlot');
			slotsModerator.bind(onSlotOver, 'hightLightedSlot');
			
			light = new DirectionalLight();
			lightPicker = new StaticLightPicker([light]);;
			defaultMaterial.lightPicker = lightPicker
			
			moderator = new Moderator(this, filesDataModel);
			moderator.bind(onFileChange, "openFile");
			
			super(style);
			
			addScope('filePrompt');
		}
		
		private var lastHightLighted:Socket;
		
		private function onSlotOver():void 
		{
			
			if (lastHightLighted)
			{
				((lastHightLighted.content.getChildAt(1) as Mesh).material as ColorMaterial).color = NORMAL_SOCKET_COLOR;
			}
			
			lastHightLighted = slotDataModel.hightLightedSlot;
			
			if (!lastHightLighted)
				return;
			
			((lastHightLighted.content.getChildAt(1) as Mesh).material as ColorMaterial).color = SELECTED_SOCKET_COLOR;
		}
		
		private var lastSelected:Socket;
		
		private function onSlotSelected():void 
		{
			if (lastSelected)
			{
				(lastSelected.content.getChildAt(1) as Mesh).showBounds = false;
			}
			
			lastSelected = slotDataModel.selectedSlot;
			(lastSelected.content.getChildAt(1) as Mesh).showBounds = true;
			
			slotEditPanel.show(slotDataModel.selectedSlot);
		}
		
		private var slotModelSelectedFlag:Boolean = false;
		private var gameCamera:GameCamera;
		private var currentCorpusFile:FsFile;
		private var lightPicker:StaticLightPicker;
		private var trident:Trident;
		private var light:DirectionalLight;
		
		private function onSlotModelSelect(e:Event):void 
		{
			slotModelSelectedFlag = true;
			broadcast(new Event("show"))
		}
		
		private function onFileChange():void 
		{
			if (!(filesDataModel.openFile.content is ObjectContainer3D))
				return;
				
			var obj:ObjectContainer3D = filesDataModel.openFile.content;
			
			var meshes:Vector.<Mesh> = new Vector.<Mesh>();
			findMeshes(obj, meshes);
			
			for (var i:int = 0; i < meshes.length; i++)
			{
				if (slotModelSelectedFlag)
				{
					meshes[i].material = new ColorMaterial(NORMAL_SOCKET_COLOR, 0.5);
					meshes[i].mouseChildren = true;
					meshes[i].mouseEnabled = true;
				}
				else
				{
					meshes[i].material = new ColorMaterial(0xCCCCCC, 1);
					meshes[i].material = new ColorMaterial(0xCCCCCC, 1);
					meshes[i].material.lightPicker = lightPicker;
				}
			}
			
			if (!meshes.length)
				return;
				
			meshes[0] = meshes[0].clone() as Mesh;
			
			if (slotModelSelectedFlag)
			{
				slotEditPanel.setModel(meshes[0]);
			}
			else
			{
				currentCorpusFile = filesDataModel.openFile;
				meshContainer.removeChildAt(1);
				meshContainer.addChild(meshes[0]);
			}
		}
		
		[Inline]
		private function findMeshes(obj:ObjectContainer3D, meshes:Vector.<Mesh>):void
		{
			if (obj is Mesh)
			{
				meshes.push(obj)
				return;
			}
				
			for (var i:int = 0; i < obj.numChildren; i++)
			{

				findMeshes(obj.getChildAt(i), meshes);
			}
		}
		
		private function createBaseContent():void
		{
			meshContainer = new ObjectContainer3D();
			meshContainer.mouseChildren = meshContainer.mouseEnabled = true;
			
			shipView = new ViewController(meshContainer);
			//gameCamera.setTracingObject(meshContainer);
			
			var trident:Trident = new Trident(400);
			//trident.ignoreTransform = true;
			trident.y -= 500
			
			meshContainer.addChild(trident);
			meshContainer.addChild(new WireframeCube());// (new WireframeCube(), DefaultMaterialManager.getDefaultMaterial()));
			
			var actor:Actor = new Actor(shipView);
			
			displayController.addDisplayObject(actor);
		}
		
		override protected function initialize():void 
		{
			shipModelControlPanel.selectModel.addEventListener(MouseEvent.CLICK, showFilePromt);
			shipSlotControll.addSlot.addEventListener(MouseEvent.CLICK, onSlotAdd);
			shipSlotControll.deleteSlot.addEventListener(MouseEvent.CLICK, onRemoveSlot);
			
			addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			
			slotEditPanel.addEventListener("selectModel", onSlotModelSelect);
			saveButton.addEventListener(MouseEvent.CLICK, onSaveClick);
			saveAsButton.addEventListener(MouseEvent.CLICK, onSaveAsClick);
		}
		
		private function onSaveAsClick(e:MouseEvent):void 
		{
			var shipDataExtractor:ShipDataExtractor = new ShipDataExtractor();
			content = content.clone() as FsFile;
			content.nativeContent = shipDataExtractor.extractInfo(socketsList, currentCorpusFile? currentCorpusFile.path:"");
			
			var file:File = new File(content.nativePath);
			file.browseForSave('Save the file bitch');
			file.addEventListener(Event.SELECT, Delegate.create(onFileToSaveSelect, file));
		}
		
		private function onFileToSaveSelect(e:Event, file:File):void 
		{
			
			
			content.name = file.name;
			(vfs.getFile(content.parent.path) as Directory).addItem(file.name, content);
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(content.nativeContent, 0, content.nativeContent.length);
			stream.close();
			
			broadcastFor('global', new Event('updateFiles'));
		}
		
		private function onSaveClick(e:MouseEvent):void 
		{
			var shipDataExtractor:ShipDataExtractor = new ShipDataExtractor();
			content.nativeContent = shipDataExtractor.extractInfo(socketsList, currentCorpusFile? currentCorpusFile.path:"");
			
			var file:File = new File(content.nativePath);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(content.nativeContent, 0, content.nativeContent.length);
			stream.close();
		}
		
		private function onRemoveSlot(e:MouseEvent = null):void 
		{
			
			for (var i:int = 0; i < socketsList.length; i++)
			{
				
				if (shipSlotControll.removeSlotView(socketsList[i]))
				{
					socketsList.splice(i, 1);
					onRemoveSlot();
					break;
				}

			}
		}
		
		private function onSlotAdd(e:MouseEvent):void 
		{
			var socket:Socket = new Socket();
			socket.name = 'Default Name';
			socket.type = 0;
			
			socketsList.push(socket);
			placeSocket(socket);
		}
		
		private function placeSocket(socket:Socket):void
		{
			shipSlotControll.addSlotView(socket);
			shipView.addSocket(socket);
			
			var container:ObjectContainer3D = new ObjectContainer3D();
			var socketFrame:Mesh = new Mesh(new CubeGeometry(), new ColorMaterial(NORMAL_SOCKET_COLOR, 0.5));
			
			var trident:Trident = new Trident(100);
			
			container.addChild(trident);
			container.addChild(socketFrame);
			
			socket.addContent(container);
			
			container.addEventListener(MouseEvent3D.CLICK, Delegate.create(onSocketClicked, socket));
			container.addEventListener(MouseEvent3D.MOUSE_OVER, Delegate.create(onSocketOver, socket));
			container.addEventListener(MouseEvent3D.MOUSE_OUT, Delegate.create(onSocketOut, socket));
			
			container.mouseChildren = socketFrame.mouseEnabled = true;
		}
		
		private function onSocketOut(e:MouseEvent3D, socket:Socket):void 
		{
			slotDataModel.hightLightedSlot = null;
		}
		
		private function onSocketClicked(e:MouseEvent3D, socket:Socket):void 
		{
			slotDataModel.selectedSlot = socket;
		}
		
		private function onSocketOver(e:MouseEvent3D, socket:Socket):void 
		{
			slotDataModel.hightLightedSlot = socket;
		}
		
		private function onWheel(e:MouseEvent):void 
		{
			if(e.target == view3d)
				meshContainer.scaleX = meshContainer.scaleY = meshContainer.scaleZ += e.delta;
		}
		
		private function createViewport():void
		{
			gameCamera = new GameCamera(__stage);
			
			view3d = new View3D(null, gameCamera.camera, null, false, Context3DProfile.BASELINE);
			view3d.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			view3d.antiAlias = 16;
			addChild(view3d);
			
			view3d.width = __stage.stageWidth - 750;
			view3d.height = __stage.stageHeight - 400;
			
			gameCamera.view3d = view3d;
			
			displayController = new SceneController(view3d);
		}
		
		private function onRemovedFromStage(e:Event):void 
		{
			view3d.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			//view3d.stage3DProxy.clear();
			//view3d.stage3DProxy.present();
			view3d.visible = false;
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
			shipSlotControll = new ShipSlotsController(null, slotDataModel, 300, view3d.height);
			slotEditPanel = new SlotEditPanel(null, view3d.width);
			
			lineDrawer = new LineDrawer(styles.getStyle("mainMenu"), null, true);
			
			saveButton = new Button(styles.getStyle("mainMenuButton"), "Save");
			saveAsButton = new Button(styles.getStyle("mainMenuButton"), "Save As");
			
			saveAsButton.width = 80;
			saveButton.width = 80;
			saveAsButton.height = 30;
			saveButton.height = 30;
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
			addComponent(slotEditPanel);
			addComponent(lineDrawer);
			addComponent(shipSlotControll);
			addComponent(saveButton);
			addComponent(saveAsButton);
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
			
			shipSlotControll.x = view3d.x + view3d.width + 4;
			shipSlotControll.y = view3d.y;
			
			saveButton.x = shipSlotControll.x + shipSlotControll.width - saveButton.width;
			saveButton.y = shipSlotControll.y + shipSlotControll.height + 4;
			
			saveAsButton.x = saveButton.x - saveButton.width - 4
			saveAsButton.y = saveButton.y;
			
			slotEditPanel.x = view3d.x;
			slotEditPanel.y = view3d.y + view3d.height + 4;
		}
		
		override public function update():void 
		{
			super.update();
			
			
			
			light.rotationX = view3d.camera.rotationX;
			light.rotationY = view3d.camera.rotationY;
			light.rotationZ = view3d.camera.rotationZ;
			
			
			gameCamera.render();
			displayController.update();
			
			//shipView.displayObject.rotationX++;
			
			/*var position:Vector3D = new Vector3D(shipView.displayObject.x, shipView.displayObject.y, shipView.displayObject.z);
			position = view3d.project(position);
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xFFFFFF);
			this.graphics.drawRect(
								view3d.x + meshContainer.minX * meshContainer.scaleX / 2 + position.x,
								view3d.y + meshContainer.minY * meshContainer.scaleY / 2 + position.y,
								meshContainer.maxX * meshContainer.scaleX,
								meshContainer.maxY * meshContainer.scaleY);
			*/
		}
		
		public function show(content:FsFile):void
		{
			var i:int;
			
			this.content = content;
			
			view3d.visible = true;
			
			for (i = 0; i < socketsList.length; i++)
				shipView.removeSocket(socketsList[i]);
			
			//displayController.clear();
			shipSlotControll.clear();
			
			if(!shipView)
				createBaseContent();
			
			var shipDataExtractor:ShipDataExtractor = new ShipDataExtractor();
			shipDataExtractor.encodeFile(content.nativeContent);
			socketsList = shipDataExtractor.sockets;
			var shipPath:String = shipDataExtractor.shipCorpusPath;
			
			filesDataModel.openFile = vfs.getFile(shipPath);
			filesDataModel.update();
			
			for (i = 0; i < socketsList.length; i++)
			{
				placeSocket(socketsList[i]);
			}	
			
			
		}
		
	}

}