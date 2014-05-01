package ui 
{
	import core.datavalue.model.Moderator;
	import core.datavalue.model.ObjectProxy;
	import core.fileSystem.FsFile;
	import ui.shipBlueprint.ShipBlueprintPage;
	import ui.style.Style;
	import ui.styles.StylesViewer;
	
	public class FilePreviewer extends UIComponent 
	{
		private var stylesViewer:StylesViewer;
		private var dataModel:ObjectProxy;
		private var moderator:Moderator;
		private var shipBlueprintPage:ShipBlueprintPage;
		
		public function FilePreviewer(dataModel:ObjectProxy) 
		{
			this.dataModel = dataModel;
			moderator = new Moderator(this, dataModel);
			moderator.bind(previewForFile, "openFile");
			
			super(null);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			stylesViewer = new StylesViewer();
			shipBlueprintPage = new ShipBlueprintPage();
		}
		
		public function previewForFile():void
		{
			var file:FsFile = dataModel.openFile;
			
			removeComponents();
			
			if (file.extension == "style")
			{
				addComponent(stylesViewer);
				stylesViewer.showStyle(file.content as Style);
			}
			else if (file.extension == "ship")
			{
				addComponent(shipBlueprintPage);
				shipBlueprintPage.show(file);
			}
		}
		
		private function show(stylesViewer:StylesViewer):void 
		{
			addComponent(stylesViewer);
			//stylesViewer.showStyle(
		}
		
	}

}