package  
{
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	public class KeyboardMap extends Proxy
	{
		public var kyesMap:Object = { };
		
		private var defaultvalue:Object = {};
		public var target:Vector.<uint> = new Vector.<uint>;
		
		public function KeyboardMap() 
		{
			kyesMap['RotationX'] = 0; kyesMap['RotationY'] = 1; kyesMap['RotationZ'] = 2;
			kyesMap['PositionX'] = 3; kyesMap['PositionY'] = 4; kyesMap['PositionZ'] = 5;
			kyesMap['Scale'] = 6;
		}
		
		override flash_proxy function hasProperty(name:*):Boolean 
		{
			return name in target;
		}
		
		override flash_proxy function getProperty(name:*):* 
		{
			if (name.localName in  target)
				return target[name.localName]
			else
				return defaultvalue;
		}
		
		override flash_proxy function setProperty(name:*, value:*):void 
		{
			target[kyesMap[name.localName]] = (value as String).charCodeAt(0);
		}
		
	}

}