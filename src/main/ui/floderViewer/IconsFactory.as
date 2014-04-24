package ui.floderViewer 
{
	import core.fileSystem.Directory;
	import core.fileSystem.FsFile;
	import core.fileSystem.IFS;
	import flash.display.BitmapData;

	public class IconsFactory 
	{
		[Inject]
		public var vfs:IFS;
		
		public function IconsFactory() 
		{
			inject(this);
		}
		
		public function getIcon(file:*):BitmapData
		{
			var fileAsFsFile:FsFile = file as FsFile;
			
			if (file is Directory)
				return vfs.getFile('res/textures/ui/floders/floder.png').content;
			else if (fileAsFsFile && (fileAsFsFile.extension == 'png' || fileAsFsFile.extension == 'jpg'))
			{
				return vfs.getFile('res/textures/ui/floders/image.png').content;
			}
			else if (fileAsFsFile && fileAsFsFile.extension == 'style')
			{
				return vfs.getFile('res/textures/ui/floders/style.png').content;
			}
			else if (fileAsFsFile.extension == "obj" || fileAsFsFile.extension == "awd")
			{
				return vfs.getFile('res/textures/ui/floders/3dimage.png').content;
			}
			else
			{
				return vfs.getFile('res/textures/ui/floders/png.png').content;
			}
		}
		
	}

}