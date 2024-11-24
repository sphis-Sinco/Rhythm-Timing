package funkin;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.Assets;
import openfl.utils.AssetType;

/**
 * A core class which handles determining asset paths.
 */
class Paths
{
	static var currentLevel:Null<String> = null;

	public static function setCurrentLevel(name:Null<String>):Void
	{
		if (name == null)
		{
			currentLevel = null;
		}
		else
		{
			currentLevel = name.toLowerCase();
		}
	}

	public static function stripLibrary(path:String):String
	{
		var parts:Array<String> = path.split(':');
		if (parts.length < 2)
			return path;
		return parts[1];
	}

	public static function getLibrary(path:String):String
	{
		var parts:Array<String> = path.split(':');
		if (parts.length < 2)
			return 'preload';
		return parts[0];
	}

	static function getPath(file:String, type:AssetType, library:Null<String>):String
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath:String = getLibraryPathForce(file, currentLevel);
			if (Assets.exists(levelPath, type))
				return levelPath;
		}

		var levelPath:String = getLibraryPathForce(file, 'shared');
		if (Assets.exists(levelPath, type))
			return levelPath;

		return getPreloadPath(file);
	}

	public static function getLibraryPath(file:String, library = 'preload'):String
	{
		return if (library == 'preload' || library == 'default') getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	static inline function getLibraryPathForce(file:String, library:String):String
	{
		return '$library:assets/$library/$file';
	}

	static inline function getPreloadPath(file:String):String
	{
		return 'assets/$file';
	}

	public static function frag(key:String, ?library:String):String
	{
		return getPath('shaders/$key.frag', TEXT, library);
	}

	public static function vert(key:String, ?library:String):String
	{
		return getPath('shaders/$key.vert', TEXT, library);
	}

	public static function xml(key:String, ?library:String):String
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	public static function json(key:String, ?library:String):String
	{
		return getPath('data/$key.json', TEXT, library);
	}
}