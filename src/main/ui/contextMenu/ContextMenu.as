package ui.contextMenu 
{
	import core.Delegate;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import ui.Button;
	import ui.contextMenu.events.ContextMenuEvent;
	import ui.style.Style;
	import ui.UIComponent;
	
	public class ContextMenu extends UIComponent 
	{
		private var elements:Vector.<UIComponent> = new Vector.<UIComponent>;
		
		private var subMenu:ContextMenu;
		private var width:Number;
		private var height:Number;
		private var background:ScaleBitmap;
		
		static private const BORDER_PADDING:Number = 5;
		
		public function ContextMenu(style:Style = null, width:Number = 150, height:Number = 400) 
		{
			this.height = height;
			this.width = width;
			
			super(style);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			background = new ScaleBitmap(vfs.getFile('res/textures/ui/frame.png').content);
			background.scale9Grid = new Rectangle(1, 1, 1, 1);
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addChild(background);
		}
		
		public function show(menuModel:ContextMenuModel):void
		{
			if (subMenu)
			{
				removeComponent(subMenu)
				subMenu = null;
			}
			
			var i:int;
			for (i = 0; i < elements.length; i++)
			{
				removeComponent(elements[i]);
			}
			
			elements = new Vector.<UIComponent>;
			
			for (i = 0; i < menuModel.length; i++)
			{
				var item:ContextItem = menuModel.items[i];
				var element:Button = new Button(styles.getStyle('newsButton'), item.submenu? ("\t" + item.name + "\t>"):item.name);
				
				if (!item.submenu)
					element.addEventListener(MouseEvent.CLICK, Delegate.create(onMenuItemClick, item));
				else
				{
					element.addEventListener(MouseEvent.CLICK, Delegate.create(showSubMenu, item));
				}
					
				element.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				
				element.width = width - (BORDER_PADDING * 2);
				element.height = 25;
				
				elements.push(element);
				
				addComponent(element);
			}
			
			invalidateLayout();
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			if (subMenu)
			{
				removeComponent(subMenu);
				subMenu = null;
			}
		}
		
		private function showSubMenu(e:MouseEvent, item:ContextItem):void 
		{
			if (subMenu)
			{
				removeComponent(subMenu);
				subMenu = null;
			}
			
			var button:Button = e.currentTarget as Button;
			
			subMenu = new ContextMenu();
			subMenu.show(item.submenu);
			
			addComponent(subMenu);
			
			var p:Point = new Point(subMenu.width + width, 0);
			p = localToGlobal(p);
				
			if (p.x > stage.stageWidth)
				subMenu.x = -width;
			else
				subMenu.x = width;
			subMenu.y = button.y;
		}
		
		private function onMenuItemClick(e:MouseEvent, item:ContextItem):void 
		{
			dispatchEvent(new ContextMenuEvent(ContextMenuEvent.SELECT_ITEM, true, false, item));
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			var h:Number = BORDER_PADDING;
			for (var i:int = 0; i < elements.length; i++)
			{
				elements[i].y = h;
				elements[i].x = BORDER_PADDING;
				h += elements[i].height + 2;
				
			}
			
			height = h + BORDER_PADDING - 2;
			background.setSize(width, height)
		}
		
	}

}