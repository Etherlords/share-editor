package ui.shipBlueprint 
{
	import away3d.containers.ObjectContainer3D;
	import characters.view.Socket;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import ui.Button;
	import ui.events.TextEvent;
	import ui.style.Style;
	import ui.TextWidthBackground;
	import ui.UIComponent;
	
	public class SlotEditPanel extends UIComponent 
	{
		[Inject]
		public var keysMap:KeyboardMap;
		
		private var editType:Button;
		private var selectModel:Button;
		
		private var editName:TextWidthBackground;
		
		private var background:ScaleBitmap;
		
		private var socket:Socket;
		private var editors:Vector.<ValueEditor> = new Vector.<ValueEditor>;
		
		public function SlotEditPanel(style:Style=null, _width:Number = 400, _height:Number = 300) 
		{
			inject(this);
			
			this._height = _height;
			this._width = _width;
			
			super(style);
		}
		
		public function show(socket:Socket):void
		{
			this.socket = socket;
			
			this.editName.text = socket.name;
			this.editType.label = socket.type.toString();
			
			for (var i:int = 0; i < editors.length; i++)
			{
				editors[i].setModel(socket);
			}
		}
		
		public function setModel(obj:ObjectContainer3D):void 
		{
			var container:ObjectContainer3D = socket.content;
			
			container.removeChildAt(1);
			container.addChild(obj);
		}
		
		override protected function createChildren():void 
		{
			super.createChildren();
			
			background = new ScaleBitmap(vfs.getFile('res/textures/ui/frame.png').content, 'auto', false, new Rectangle(1, 1, 1, 1));
			editName = new TextWidthBackground(styles.getStyle('newsTextFormat'));
			editType = new Button(styles.getStyle("mainMenuButton"));
			selectModel = new Button(styles.getStyle("mainMenuButton"));
			
			createEditor('RotationX(Q)', 'rotation', 'x', angleConversion);
			createEditor('RotationY(W)', 'rotation', 'y', angleConversion);
			createEditor('RotationZ(E)', 'rotation', 'z', angleConversion);
			
			createEditor('PositionX(A)', 'position', 'x');
			createEditor('PositionY(S)', 'position', 'y');
			createEditor('PositionZ(D)', 'position', 'z');
			
			createEditor('Scale(X)', 'scale');
		}
		
		private function angleConversion(a:Number):Number
		{
			if (a < 0)
				a = 360 + a;
				
			if(a >= 360)
				a = a - (360 * Math.floor(a / 360));
				
			return a;
		}
		
		private function createEditor(hintLabel:String, objectToModel:String, fieldToBind:String = null, conversionFunction:Function = null):void
		{
			var valueEditor:ValueEditor = new ValueEditor(null, hintLabel, fieldToBind, objectToModel, null, conversionFunction);
			valueEditor.addEventListener(MouseEvent.MOUSE_DOWN, onEditorClick);
			editors.push(valueEditor);
			
			addComponent(valueEditor);
		}
		
		override protected function initialize():void 
		{
			super.initialize();
			editName.addEventListener(TextEvent.TEXT_ENTER, onTextInput);
			selectModel.addEventListener(MouseEvent.CLICK, onSelecModelClick);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onSelecModelClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event("selectModel"));
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			if (!e.ctrlKey || isMouseUp)
				return;
				
			var point2:Point = new Point(e.stageX, e.stageY);
			var delta:Number = Point.distance(point2, lastMouse) * 1.4;
			
			if (lastMouse.y < point2.y || lastMouse.x < point2.x)
				delta *= -1;
			
			lastMouse = point2;
			
			if (currentSelectedEditor)
				currentSelectedEditor.move(delta);
		}
		
		private function mouseUp(e:MouseEvent):void 
		{
			isMouseUp = true;
		}
		
		private var lastMouse:Point = new Point();
		private var isMouseUp:Boolean = true;
		
		private function mouseDown(e:MouseEvent):void 
		{
			isMouseUp = false;
			lastMouse.setTo(e.stageX, e.stageY);
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if (currentSelectedEditor)
			{
				currentSelectedEditor.onWheel(e);
			}
		}
		
		private function onEditorClick(e:MouseEvent):void 
		{
			e.preventDefault();
			e.stopImmediatePropagation();
			
			var editor:ValueEditor = e.currentTarget as ValueEditor;
			
			if (currentSelectedEditor)
			{
				if (currentSelectedEditor == editor)
					return;
				else
					currentSelectedEditor.selected = false;
			}
			
			currentSelectedEditor = editor;
			editor.selected = true;
		}
		
		private var currentSelectedEditor:ValueEditor;
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			var key:uint = e.keyCode;
			
			for (var i:int = i; i < keysMap.target.length; i++)
			{
				if (keysMap.target[i] == key)
				{
					if(currentSelectedEditor)
						currentSelectedEditor.selected = false;
						
					currentSelectedEditor = editors[i];
					currentSelectedEditor.selected = true;
				}
			}
		}
		
		private function onTextInput(e:TextEvent):void 
		{
			socket.name = e.text;
			//slotModel.update();
		}
		
		override protected function configureChildren():void 
		{
			super.configureChildren();
			
			editType.height = 25;
			selectModel.height = 25;
			selectModel.width = editName.width = editType.width;
			
			editName.type = TextFieldType.INPUT;
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			addChild(background);
			addComponent(editName);
			addComponent(editType);
			addComponent(selectModel);
		}
		
		override protected function layoutChildren():void 
		{
			super.layoutChildren();
			
			editName.x = 4;
			editName.y = 4;
			
			editType.x = 4;
			editType.y = editName.y + editName.height + 4;
			
			selectModel.x = 4;
			selectModel.y = editType.y + editType.height + 4;
			
			background.setSize(width, height);
			
			var __x:Number = 4;
			var __y:Number = selectModel.y + selectModel.height + 4;
			
			for (var i:int = 0; i < editors.length; i++)
			{
				editors[i].x = __x;
				editors[i].y = __y;
				__y += editors[i].height + 4;
			}
		}
	}

}