package  
{
	/**
	 * ...
	 * @author 
	 */
	public class CameraModel 
	{
		private var _zoom:Number = 140;
		private var _minimumZoom:Number = 5;
		private var _maximumZoom:Number = 160;
		
		private var _baseDitance:Number = 1000;
		
		public function CameraModel() 
		{
			
		}
		
		public function get baseDitance():Number 
		{
			return _baseDitance;
		}
		
		public function set baseDitance(value:Number):void 
		{
			_baseDitance = value;
		}
		
		public function get zoom():Number 
		{
			return _zoom;
		}
		
		public function set zoom(value:Number):void 
		{
			_zoom = value;
		}
		
		public function get minimumZoom():Number 
		{
			return _minimumZoom;
		}
		
		public function set minimumZoom(value:Number):void 
		{
			_minimumZoom = value;
		}
		
		public function get maximumZoom():Number 
		{
			return _maximumZoom;
		}
		
		public function set maximumZoom(value:Number):void 
		{
			_maximumZoom = value;
		}
		
	}

}