package ui.tree 
{
	import core.fileSystem.Directory;
	import core.fileSystem.IFile;
	import flash.events.Event;
	import ui.style.Style;
	import ui.UIComponent;
	
	public class TreeNode extends UIComponent 
	{
		private var nodeElements:Vector.<TreeElement> = new Vector.<TreeElement>;
		
		public function TreeNode(style:Style=null) 
		{
			super(style);
			
		}
		
		public function show(directory:Directory):void
		{
			directory.index = 0;
			for (var currentItem:IFile = directory.currentItem; directory.index < directory.length; currentItem = directory.nextItem)
			{	
				if (!currentItem)
					break;
					
				var treeElement:TreeElement;
			
				if (currentItem.isDerictory)
					treeElement = new FloderElement(null, currentItem);
				else
					treeElement = new TreeElement(null, currentItem);
					
				nodeElements.push(treeElement);
				addComponent(treeElement);
			}
			
			addEventListener(Event.CHANGE, onChangeElement);
			invalidateLayout();
		}
		
		private function onChangeElement(e:Event):void 
		{
			invalidateLayout();
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			var _y:Number = 0;
			for (var i:int = 0; i < nodeElements.length; i++)
			{
				nodeElements[i].y = _y;
				_y += nodeElements[i].measureHeight + 2
			}
		}
	}

}