package  
{
	import core.codec.FileDecoderFactory;
	import core.datavalue.model.LazyProxy;
	import core.external.io.DesktopFileLoader;
	import core.fileSystem.external.DirectoryScaner;
	import core.fileSystem.external.LocalFileSystem;
	import core.fileSystem.external.VirtualDirectoryScaner;
	
	import core.services.FileDecodeService;
	import core.services.FileLoadingService;
	import display.ui.DisplayManager;
	import services.FileSystemService;
	import ui.ComponentsScene;
	import ui.CompSceneController;
	import ui.contextMenu.DirectoryContextMenu;
	import ui.contextMenu.FileContextMenu;
	import ui.FilesActionsController;
	import ui.preloadScreen.PreloaderScene;
	

	public class ClassesRef 
	{
		
		public static var resourceManager:ResourceManager;
		public static var keyboardMap:KeyboardMap;
		
		public static var directoryContextMenu:DirectoryContextMenu;
		public static var fileContextMenu:FileContextMenu;
		
		public static var lazyProxy:LazyProxy;
		
		public static var displayManager:DisplayManager;


		
		public static var fileDecoderFactory:FileDecoderFactory;
		public static var desktopFileLoader  :DesktopFileLoader;
		
		public static var fileLoadingService :FileLoadingService;
		public static var _FileDecodingService:FileDecodeService;
		
		public static var scenesController:CompSceneController;
		
		public static var componentsScene:ComponentsScene;
		public static var preloaderScene:PreloaderScene;
		
		public static var localFileSystem:LocalFileSystem;
		public static var virtdirscan:VirtualDirectoryScaner;
		public static var dir:DirectoryScaner;
		
		public static var fileSystemService:FileSystemService;
		public static var fileActonController:FilesActionsController;
	}

}