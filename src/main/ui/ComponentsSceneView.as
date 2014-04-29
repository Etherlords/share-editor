package ui 
{
	impui.contextMenuort core.datavalue.model.LazyProxy;
	import core.datavalue.model.ObjectProxy;
	import core.fileSystem.FsFile;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ui.contextMenu.ContextItem;
	import ui.contextMenu.ContextMenu;
	import ui.contextMenu.ContextMenuModel;
	import ui.contextMenu.ContextMenuEvent;
	import ui.events.FloderEvent;
	import ui.floderViewer.IconsFactory;
	import ui.style.Style;
	import ui.tree.Tree;

	
	public class ComponentsSceneView extends UIComponent
	{
		private var dataModel:ObjectProxy;
		
		private var flodersTree:Tree;
		private var filePreview:FilePreviewer;
		private var contextMenu:ContextMenu;
			
		public function ComponentsSceneView(dataModel:LazyProxy) 
		{
			this.dataModel = dataModel;
			super();
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			addToContext(new IconsFactory());
			
			for (var field:String in styles.styles.map)
			{
				var style:Style = styles.styles.map[field]
				var file:FsFile = new FsFile();
				file.name = field + '.style';
				file.content = style;
				file.path = '/';
				file.extension = 'style';
				vfs.directoriesList.addItem(field, file);
			}
			
			contextMenu = new ContextMenu();
			filePreview = new FilePreviewer(dataModel);
			
			vfs.directoriesList.index = 0;
			
			flodersTree = new Tree(null, vfs.directoriesList, 400, 551);
			
			flodersTree.addEventListener(FloderEvent.OPEN, onOpen);
			flodersTree.addEventListener(FloderEvent.SELECT, onSelect);
			flodersTree.addEventListener(FloderEvent.CONTEXT_MENU, onContextOpen);
		}
		
		private function onContextOpen(e:FloderEvent):void 
		{
			
			addComponent(contextMenu);
			
			var menuModel:ContextMenuModel = new ContextMenuModel();
			
			if (e.selected.isDerictory)
			{
				var createTypeMenu:ContextMenuModel = new ContextMenuModel();
				createTypeMenu.addItem(new ContextItem("New style file...", "newStyle"));
				createTypeMenu.addItem(new ContextItem("New png file...", "newPng"));
				createTypeMenu.addItem(new ContextItem("New jpg file...", "newJpg"));
				menuModel.addItem(new ContextItem("Create...", '', createTypeMenu));
			}
			else
			{
				menuModel.addItem(new ContextItem("Delete", "delete"));
			}
			
			contextMenu.show(menuModel);
			
			contextMenu.x = stage.mouseX;
			contextMenu.y = stage.mouseY;
		}
		
		private function onSelect(e:FloderEvent):void 
		{
			dataModel.selectedFile = e.selected;
		}
		
		private function onOpen(e:FloderEvent):void 
		{
			if(!e.selected.isDerictory)
				dataModel.openFile = e.selected;
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			contextMenu.addEventListener(ContextMenuEvent.SELECT_ITEM, onContextMenuSelect);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onContextMenuSelect(e:ContextMenuEvent):void 
		{
			if (contextMenu.parent)
				removeComponent(contextMenu);
				
			trace(e.selectedItem)
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			onResize();
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if (!contextMenu.hitTestPoint(e.stageX, e.stageY, true) && contextMenu.parent)
				removeComponent(contextMenu);
		}
		
		private function onResize(e:Event = null):void 
		{
			flodersTree.setSize(flodersTree.width, stage.stageHeight)
			invalidateLayout();
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addComponent(filePreview);
			addComponent(flodersTree);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			filePreview.x = 0;
			filePreview.y = 0;
			
			flodersTree.x = (stage.stageWidth - flodersTree.width);
			flodersTree.y = 0;// componentsListViewer.y + componentsListViewer.height + 2;
			
			//styleViewer.y = saveButton.y + saveButton.height + 2;
		}
		
	}

}