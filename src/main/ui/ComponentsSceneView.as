package ui 
{
	import core.datavalue.model.LazyProxy;
	import core.datavalue.model.ObjectProxy;
	import core.fileSystem.FsFile;
	import core.fileSystem.IFS;
	import flash.display.Stage;
	import flash.events.Event;
	import ui.events.FloderEvent;
	import ui.floderViewer.IconsFactory;
	import ui.style.Style;
	import ui.style.StylesCollector;
	import ui.tree.Tree;
	
	public class ComponentsSceneView extends UIComponent
	{
		[Inject]
		public var vfs:IFS;
		
		[Inject]
		public var styles:StylesCollector;
		
		[Inject]
		public var __stage:Stage;
		
		private var dataModel:ObjectProxy = new LazyProxy(100);
		
		private var flodersTree:Tree;
		private var filePreview:FilePreviewer;
			
		public function ComponentsSceneView() 
		{
			inject(this);
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
			
			filePreview = new FilePreviewer(dataModel);
			
			vfs.directoriesList.index = 0;
			
			flodersTree = new Tree(null, vfs.directoriesList, 400, 551);
			
			flodersTree.addEventListener(FloderEvent.OPEN, onOpen);
			flodersTree.addEventListener(FloderEvent.SELECT, onSelect);
			flodersTree.addEventListener(FloderEvent.CONTEXT_MENU, onContextOpen);
		}
		
		private function onContextOpen(e:FloderEvent):void 
		{
			trace(e);
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
			
			__stage.addEventListener(Event.RESIZE, onResize);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			onResize();
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