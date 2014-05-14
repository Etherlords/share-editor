package ui.shipBlueprint 
{
	import characters.view.Socket;
	import core.external.io.DoubleOperator;
	import core.external.io.IntOperator;
	import core.external.io.StreamOperator;
	import core.external.io.UTFStringOperator;
	import core.external.io.Vector3DOperator;

	import flash.utils.ByteArray;
	
	public class ShipDataExtractor 
	{
		private var socketOperator:StreamOperator;
		
		public var shipCorpusPath:String = '';
		public var sockets:Vector.<Socket>
		
		public function ShipDataExtractor() 
		{
			initialize();
		}
		
		private function initialize():void 
		{
			socketOperator = new StreamOperator();
			socketOperator.addSerializer(new UTFStringOperator());
			socketOperator.addSerializer(new IntOperator());
			socketOperator.addSerializer(new Vector3DOperator());
			socketOperator.addSerializer(new Vector3DOperator());
			socketOperator.addSerializer(new DoubleOperator());
			
			socketOperator.addDeserializer(new UTFStringOperator());
			socketOperator.addDeserializer(new IntOperator());
			socketOperator.addDeserializer(new Vector3DOperator());
			socketOperator.addDeserializer(new Vector3DOperator());
			socketOperator.addDeserializer(new DoubleOperator());
		}
		
		public function encodeFile(ba:ByteArray):void
		{
			ba.position = 0;
			
			var socketCountOperator:IntOperator = new IntOperator();
			socketCountOperator.serialize(ba);
			
			var count:int = socketCountOperator.value as int;
			var sockets:Vector.<Socket> = new Vector.<Socket>;
			
			var shipCorpusOperator:UTFStringOperator = new UTFStringOperator();
			shipCorpusOperator.serialize(ba);
			shipCorpusPath = shipCorpusOperator.value as String;
			
			for (var i:int = 0; i < count; i++)
			{
				socketOperator.output = [];
				socketOperator.serialize(ba);
				
				var socket:Socket = new Socket();
				socket.name = socketOperator.output[0];
				socket.type = socketOperator.output[1];
				socket.position = socketOperator.output[2];
				socket.rotation = socketOperator.output[3];
				socket.scale = socketOperator.output[4];
				
				sockets.push(socket);
			}
			
			this.sockets = sockets;
		}
		
		public function extractInfo(sockets:Vector.<Socket>, shipCorpusPath:String):ByteArray
		{
			var fileData:ByteArray = new ByteArray();
			
			var socketCountOperator:IntOperator = new IntOperator();
			socketCountOperator.value = sockets.length;
			socketCountOperator.deserialize(fileData);
			
			var shipCorpusOperator:UTFStringOperator = new UTFStringOperator();
			shipCorpusOperator.value = shipCorpusPath;
			shipCorpusOperator.deserialize(fileData);
			
			for (var i:int = 0; i < sockets.length; i++)
			{
				var currentSocket:Socket = sockets[i];
				socketOperator.input = [currentSocket.name, currentSocket.type, currentSocket.position, currentSocket.rotation, currentSocket.scale];
				socketOperator.deserialize(fileData);
			}
			
			return fileData;
		}
		
	}

}