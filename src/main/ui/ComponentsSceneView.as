package ui 
{
	import core.datavalue.model.LazyProxy;
	import core.datavalue.model.ObjectProxy;
	import core.fileSystem.Directory;
	import core.fileSystem.FsFile;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ui.contextMenu.ContextMenu;
	import ui.contextMenu.DirectoryContextMenu;
	import ui.contextMenu.events.ContextMenuEvent;
	import ui.contextMenu.FileContextMenu;
	import ui.events.FloderEvent;
	import ui.floderViewer.FloderViewer;
	import ui.floderViewer.IconsFactory;
	import ui.style.Style;
	import ui.tree.Tree;

	
	public class ComponentsSceneView extends UIComponetBroadcaster
	{
		private var dataModel:ObjectProxy;
		
		private var flodersTree:Tree;
		private var filePreview:FilePreviewer;
		private var contextMenu:ContextMenu;
		private var filePromt:Explorer;
		
		public var filesDataModel:ObjectProxy;
			
		public function ComponentsSceneView(dataModel:LazyProxy, filesDataModel:ObjectProxy) 
		{
			this.filesDataModel = filesDataModel;
			this.dataModel = dataModel;
			super();
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			filePromt = new Explorer(null, filesDataModel);
			filePromt.addEventListener(Event.OPEN, onFileSelected);
			
			vfs.directoriesList.index = 0;
			
			var styleDir:Directory = new Directory();
			styleDir.name = 'style';
			styleDir.parent = vfs.directoriesList.currentItem;
			
			for (var field:String in styles.styles.map)
			{
				var style:Style = styles.styles.map[field]
				var file:FsFile = new FsFile();
				file.name = field + '.style';
				file.content = style;
				file.path = '/';
				file.extension = 'style';
				styleDir.addItem(field, file);
			}
			
			vfs.directoriesList.currentItem.addItem("styles", styleDir);
			
			contextMenu = new ContextMenu();
			contextMenu.addScope("FileSystemContextMenu");
			
			filePreview = new FilePreviewer(dataModel);
			
			vfs.directoriesList.index = 0;
			
			flodersTree = new Tree(null, vfs.directoriesList.currentItem as Directory, 400, 551);
			
			flodersTree.addEventListener(FloderEvent.OPEN, onOpen);
			flodersTree.addEventListener(FloderEvent.SELECT, onSelect);
			flodersTree.addEventListener(FloderEvent.CONTEXT_MENU, onContextOpen);
		}
		
		private var directoryMenu:DirectoryContextMenu = new DirectoryContextMenu();
		private var fileContextMenu:FileContextMenu = new FileContextMenu();
		
		private function onContextOpen(e:FloderEvent):void 
		{
			
			if (e.selected.isDerictory)
				contextMenu.show(directoryMenu, e.selected);
			else
				contextMenu.show(fileContextMenu, e.selected);
			
			addComponent(contextMenu);
			
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
			
			describe("filePrompt", "show", onShowFilePromt);
		}
		
		private function onFileSelected(e:Event):void 
		{
			filesDataModel.update();
			removeComponent(filePromt);
		}
		
		private function onShowFilePromt(e:Event):void 
		{
			//filePromt.directory = vfs.directoriesList;
			//filePromt.setView();
			
			if(!filePromt.parent)
				addComponent(filePromt);
		}
		
		private function onContextMenuSelect(e:ContextMenuEvent):void 
		{
			if (contextMenu.parent)
				removeComponent(contextMenu);
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