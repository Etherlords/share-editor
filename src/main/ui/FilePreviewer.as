package ui 
{
	import core.datavalue.model.Moderator;
	import core.datavalue.model.ObjectProxy;
	import core.fileSystem.FsFile;
	import ui.style.Style;
	import ui.styles.StylesViewer;
	
	public class FilePreviewer extends UIComponent 
	{
		private var stylesViewer:StylesViewer;
		private var dataModel:ObjectProxy;
		private var moderator:Moderator;
		
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
		}
		
		public function previewForFile():void
		{
			var file:FsFile = dataModel.openFile;
			
			if (file.extension == "style")
			{
				addComponent(stylesViewer);
				stylesViewer.showStyle(file.content as Style);
			}
		}
		
		private function show(stylesViewer:StylesViewer):void 
		{
			addComponent(stylesViewer);
			//stylesViewer.showStyle(
		}
		
	}

}