package ui 
{
	import core.datavalue.model.ObjectProxy;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFieldType;
	import ui.floderViewer.FloderViewer;
	import ui.style.Style;
	
	public class Explorer extends UIComponent 
	{
		private var flodersView:FloderViewer;
		private var background:ScaleBitmap;
		private var text:Text;
		private var findText:Text;
		private var dataModel:ObjectProxy;
		public var saveButton:Button;
		
		public function Explorer(style:Style=null, dataModel:ObjectProxy = null) 
		{
			this.dataModel = dataModel;
			
			super(style);
		}
		
		override protected function preinitialzie():void 
		{
			super.preinitialzie();
			
			//dataModel.addEventListener(
		}
		
		private function onOpen(e:Event):void 
		{
			dataModel.openFile = flodersView.currentFile;
			//if(flodersView.currentFile.content is Style)
			//	styleViewer.showStyle(flodersView.currentFile.content);
		}
		
		private function onChange(e:Event):void 
		{
			dataModel.selectedFile = flodersView.currentFile;
			
			layoutChildren();
			text.text = flodersView.directory.path;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			flodersView.addEventListener(Event.CHANGE, onChange);
			flodersView.addEventListener(Event.OPEN, onOpen);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			text = new TextWidthBackground(styles.getStyle('componentsSceneText'));
			findText = new TextWidthBackground(styles.getStyle('componentsSceneText'));
			background = new ScaleBitmap(vfs.getFile("res/textures/ui/frame.png").content);
			flodersView = new FloderViewer(null, vfs.directoriesList, 'res/');
			saveButton = new Button(styles.getStyle("mainMenuButton"), "Save")
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addChild(background);
			addComponent(flodersView);
			addComponent(text);
			addComponent(findText);
			addComponent(saveButton);
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		override protected function configureChildren():void 
		{
			super.configureChildren();
			
			background.scale9Grid = new Rectangle(1, 1, 1, 1);
			
			var autocomplete:AutoCompleteManager = new AutoCompleteManager(findText.textField);
			autocomplete.completionMap.push('test', 'test2');
			findText.type = TextFieldType.INPUT;
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			//invaildLayout = false;
			
			//background.setSize(flodersView.width, flodersView.height);
			text.y = 1;
			findText.y = 1;
			
			flodersView.y = text.y + text.height + 2;
			background.y = flodersView.y-1;
			
			flodersView.x = 1;
			background.setSize(flodersView.width + 2, flodersView.height + 2);
			
			text.width = flodersView.width + 2 - 100;
			findText.width = 100;
			findText.x = text.x + text.width
			
			saveButton.x = background.width - saveButton.width;
			saveButton.y = background.y + background.height +2;
		}
		
	}

}