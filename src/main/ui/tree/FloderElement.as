package ui.tree 
{
	import core.fileSystem.Directory;
	import core.fileSystem.FsFile;
	import core.fileSystem.IFile;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ui.style.Style;
	
	public class FloderElement extends TreeElement 
	{
		private var treeNode:TreeNode;
		private var status:Bitmap
		private var statusContainer:Sprite;
		
		private var isOpen:Boolean = false;
		private var openPattern:BitmapData;
		private var closePattern:BitmapData;
		
		public function FloderElement(style:Style=null, item:IFile = null, size:Number=16) 
		{
			super(style, item, size);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			if ((item as Directory).length)
			{
				openPattern = vfs.getFile('res/textures/ui/tree/open.png').content;
				closePattern = vfs.getFile('res/textures/ui/tree/close.png').content;
				
				status = new Bitmap(closePattern);
				statusContainer = new Sprite();
				
				statusContainer.addChild(status);
			}                                                                                                                                    
				
			treeNode = new TreeNode();
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			if(status)
				addChild(statusContainer);
		}
		
		override protected function configureChildren():void 
		{
			super.configureChildren();
			
			treeNode.show(item as Directory);
		}
		
		override protected function onClick(e:MouseEvent):void 
		{
			super.onClick(e);
			
			if (status && e.target == statusContainer)
				openOperation();
		}
		
		override protected function onDoubleClick(e:MouseEvent):void 
		{
			if(!(item as Directory).length)
				return;
				
			super.onDoubleClick(e);
		}
		
		override protected function openOperation():void
		{
			super.openOperation();
			
			if (isOpen)
				close();
			else
				open();
				
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		private function close():void 
		{
			isOpen = false;
			status.bitmapData = closePattern;
			removeChild(treeNode);
		}
		
		public function open():void
		{
			isOpen = true;
			status.bitmapData = openPattern;
			addComponent(treeNode);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			if (status)
				statusContainer.y = (background.height - status.height) / 2;
			
			text.x = background.width + background.x;
			text.y = (background.height - text.height) / 2;
			
			treeNode.x = background.x + background.width + 2;
			treeNode.y = background.y + background.height + 2;
		}
		
	}

}