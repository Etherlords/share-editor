package ui.contextMenu 
{

	public class ContextItem 
	{
		public var ident:String;
		public var name:String;
		
		public var submenu:ContextMenuModel;
		
		public function ContextItem(name:String = '', ident:String = '', submenu:ContextMenuModel = null) 
		{
			this.ident = ident;
			this.submenu = submenu;
			this.name = name;
			
		}
		
		public function initSubmenu():void
		{
			submenu = new ContextMenuModel()
		}
		
		public function toString():String 
		{
			return "[ContextItem ident=" + ident + " name=" + name + " submenu=" + submenu + "]";
		}
	}

}