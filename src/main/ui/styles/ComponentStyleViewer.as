package ui.styles 
{
	import core.datavalue.model.events.ProxyEvent;
	import core.datavalue.model.ObjectProxy;
	import ui.style.Style;
	import ui.UIComponent;
	
	public class ComponentStyleViewer extends UIComponent 
	{
		private var styleViewer:StylesViewer;
		private var dataModel:ObjectProxy;
		
		
		public function ComponentStyleViewer(dataModel:ObjectProxy) 
		{
			this.dataModel = dataModel;
			super(null);
		}
		
		override protected function preinitialzie():void 
		{
			super.preinitialzie();
			
			dataModel.addEventListener(ProxyEvent.UPDATE_EVENT, onUpdate);
		}
		
		private function onUpdate(e:ProxyEvent):void 
		{
			
		}
		
		public function showStyle(content:*):void 
		{
			styleViewer.showStyle(content);
			layoutChildren();
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			styleViewer = new StylesViewer();
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addComponent(styleViewer);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
		}
		
	}

}