package ui 
{
	import ui.style.Style;
	
	public class Page extends UIComponent 
	{
		
		public function Page(style:Style=null) 
		{
			super(style);
			
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			var scrollBar:ScrollBar;
			var scroll:ScrollContainer = new ScrollContainer();
		}
		
	}

}