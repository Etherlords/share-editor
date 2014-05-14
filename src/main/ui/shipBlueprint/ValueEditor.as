package ui.shipBlueprint 
{
	import characters.view.Socket;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldType;
	import ui.events.TextEvent;
	import ui.style.Style;
	import ui.TextWidthBackground;
	import ui.UIComponent;
	
	public class ValueEditor extends UIComponent 
	{
		private var socket:Socket;
		
		private var fieldToBind:String;
		private var hintLabel:String;
		private var hint:TextWidthBackground;
		private var edit:TextWidthBackground;
		private var valueConversionFunction:Function;
		private var objectToModel:String;
		
		private var _selected:Boolean = false;
		private var background:ScaleBitmap;
		
		private var currentValue:Number;
		
		public function ValueEditor(style:Style=null, hintLabel:String = '', fieldToBind:String = '', objectToModel:String = '', socket:Socket = null, valueConversionFunction:Function = null) 
		{
			this.objectToModel = objectToModel;
			this.valueConversionFunction = valueConversionFunction;
			this.hintLabel = hintLabel;
			this.fieldToBind = fieldToBind;
			this.socket = socket;
			
			super(style);
		}
		
		public function setModel(socket:Socket):void 
		{
			this.socket = socket;
			
			var value:Object = socket[objectToModel];
			
			if (fieldToBind)
				value = value[fieldToBind];
			
			edit.text = setValue(value).toString();
			edit.textField.setSelection(edit.text.length, edit.text.length);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			background = new ScaleBitmap(vfs.getFile('res/textures/ui/frame.png').content, 'auto', false, new Rectangle(1, 1, 1, 1));
			hint = new TextWidthBackground(styles.getStyle('newsTextFormat'));
			edit = new TextWidthBackground(styles.getStyle('newsTextFormat'));
		}
		
		override protected function configureChildren():void 
		{
			super.configureChildren();
			
			edit.textField.restrict = ('-0-9.');
			hint.text = hintLabel;
			edit.text = '0';
			edit.type = TextFieldType.INPUT;
			
			edit.textField.selectable = false;
			hint.mouseInteraction = false;
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			
			edit.addEventListener(TextEvent.TEXT_ENTER, onTextEnter);
			//edit.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		}
		
		public function move(delta:Number):void
		{
			if (!socket)
				return;
				
			currentValue += delta;
			
			edit.text = setValue(currentValue).toString();
		}
		
		public function onWheel(e:MouseEvent):void 
		{
			if (!socket)
				return;
				
			var valueAsNumber:Number = Number(edit.text);

			var delta:Number = e.delta;
			if (e.ctrlKey)
				delta /= 100;
			else if(e.shiftKey)
				delta *= 10;
				
			valueAsNumber += delta;
			
			edit.text = setValue(valueAsNumber).toString();
			edit.textField.setSelection(edit.text.length, edit.text.length);
		}
		
		private function onTextEnter(e:TextEvent):void 
		{
			var value:Number = setValue(edit.text) as Number;
			edit.text = value.toString();
			
			if(fieldToBind)
				socket[objectToModel][fieldToBind] = value;
			else
				socket[objectToModel] = value;
		}
		
		private function setValue(value:Object):Object
		{
			if (!socket)
				return null;
			
			var numericValue:Number = Number(value.toFixed(4));
				
			if (Boolean(valueConversionFunction))
				numericValue = valueConversionFunction(numericValue);
				
			if (isNaN(numericValue))
				numericValue = currentValue;
				
			numericValue = Number(numericValue.toFixed(4));
			
			if (fieldToBind)
				socket[objectToModel][fieldToBind] = numericValue;
			else
				socket[objectToModel] = numericValue;
			
			socket.applyPositionAndRotation();
			
			currentValue = numericValue;
			
			return numericValue;
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addComponent(hint);
			addComponent(edit);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			edit.x = hint.x + hint.width + 4;
			
			this.width = edit.x + edit.width;
			this.height = edit.height;
			
			background.setSize(this.width, this.height);
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if (value == _selected)
				return;
				
			_selected = value;
			
			if (value)
			{
				stage.focus = edit.textField;
				edit.textField.selectable = true;
				edit.textField.setSelection(edit.text.length, edit.text.length);
				
				addChild(background);
			}
			else
			{
				edit.textField.selectable = false;
				removeChild(background);
			}
		}
	}

}