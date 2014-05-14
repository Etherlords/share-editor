package  
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Entity;
	import core.external.KeyBoardController;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	public class GameCamera 
	{
		public var view3d:View3D;
		
		private var stage:Stage;
		private var _camera:Camera3D;
		private var controller:HoverController;
		
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		private var _isCameraMovie:Boolean;
		
		public var cameraModel:CameraModel;
		private var target:ObjectContainer3D;
		private var deltaVecotr:Vector3D = new Vector3D(0, 0, 0);
		private var keyBoardController:KeyBoardController;
		
		public function GameCamera(stage:Stage) 
		{
			this.stage = stage;
			keyBoardController = new KeyBoardController(stage);
			
			initilize();
		}
		
		public function setTracingObject(target:ObjectContainer3D):void
		{
			this.target = target;
			//controller.lookAtObject = target;
			deltaVecotr.y = 100
			controller.targetObject = target;
		}
		
		private function initilize():void 
		{
			//stage.addEventListener(MouseEvent['RIGHT_MOUSE_DOWN'], onMouseDown);
			//stage.addEventListener(MouseEvent['RIGHT_MOUSE_UP'], onMouseUp);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseWheel);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onLeftMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onLeftMouseUp);
			
			cameraModel = new CameraModel();
			cameraModel.minimumZoom = 1;
			
			_camera = new Camera3D()
			_camera.lens.far = 1200000;
			_camera.lens.near = 1;
			controller = new HoverController(camera, null, 189.5, 4, cameraModel.baseDitance, -90, 90, NaN, NaN, 3, 1, true);
			controller.lookAtPosition = new Vector3D();
			
			applyZoom();
		}
		
		private function onLeftMouseUp(e:MouseEvent):void 
		{
			leftMouseUp = false;
		}
		
		private function onLeftMouseDown(e:MouseEvent):void 
		{
			var viewRect:Rectangle = new Rectangle(view3d.x, view3d.y, view3d.width, view3d.height);
			
			var isContains:Boolean = viewRect.contains(e.stageX, e.stageY);
			
			if (!isContains)
				return;
				
			lastMouse = new Point(e.stageX, e.stageY);
			leftMouseUp = true;
		}
		
		public function render():void
		{
			if (_isCameraMovie) 
			{
				controller.panAngle = 1.0 * (stage.mouseX - lastMouseX) + lastPanAngle;
				controller.tiltAngle = 1.0 * (stage.mouseY - lastMouseY) + lastTiltAngle;
			}
			
			//if(target)
			//	controller.lookAtPosition = target.position.clone().add(deltaVecotr);
				
			controller.autoUpdate = false;
			controller.update(false);
		}
		
		private var lastMouse:Point;
		private var leftMouseUp:Boolean;
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			if (!leftMouseUp || !e.altKey)
				return;
				
			onStageMouseLeave();
			
			var point2:Point = new Point(e.stageX, e.stageY);
			var delta:Number = Point.distance(point2, lastMouse);
			
			if (lastMouse.y < point2.y || lastMouse.x < point2.x)
				delta *= -1;
			
			lastMouse = point2;
			
			cameraModel.zoom += delta;
			
			if (cameraModel.zoom < cameraModel.minimumZoom)
				cameraModel.zoom = cameraModel.minimumZoom;
				
			if (cameraModel.zoom > cameraModel.maximumZoom)
				cameraModel.zoom = cameraModel.maximumZoom;
				
			//if (cameraModel.zoom < 6)
			//	controller.minTiltAngle = -90
			//else
			//	controller.minTiltAngle = 4;
				
			applyZoom();
		}
		
		private function applyZoom():void
		{
			controller.distance = cameraModel.baseDitance * cameraModel.zoom / 100;
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			if (event.altKey)
				return;
				
			if (event.ctrlKey)
				return;
				
			var viewRect:Rectangle = new Rectangle(view3d.x, view3d.y, view3d.width, view3d.height);
			
			var isContains:Boolean = viewRect.contains(event.stageX, event.stageY);
			
			if (!isContains)
				return;
			
			lastPanAngle = controller.panAngle;
			lastTiltAngle = controller.tiltAngle;
			
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			
			_isCameraMovie = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onStageMouseLeave(event:Event = null):void
		{
			_isCameraMovie = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			_isCameraMovie = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		public function get camera():Camera3D 
		{
			return _camera;
		}
		
		public function get isCameraMovie():Boolean 
		{
			return _isCameraMovie;
		}
		
	}

}