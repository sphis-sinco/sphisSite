package;

import flixel.FlxState;
import polymod.Polymod;
import polymod.fs.PolymodFileSystem.IFileSystem;
#if sys
import polymod.fs.SysFileSystem;
#elseif nodefs
import polymod.fs.NodeFileSystem;
#else
import polymod.fs.MemoryFileSystem;
#end

class InitState extends FlxState
{
	public static var modDir:String = 'mods';
	public static var fileSystem:IFileSystem;

	override public function create()
	{
		super.create();

		loadMods();
	}

	static function getFileSystem():IFileSystem
	{
		#if sys
		return new SysFileSystem({modRoot: modDir});
		#elseif nodefs
		return new NodeFileSystem({modRoot: modDir});
		#else
		return new MemoryFileSystem({modRoot: modDir});
		#end
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function loadMods()
	{
		var dirs:Array<String> = [];

		try
		{
			if (!getFileSystem().exists(modDir))
				return;

			dirs = getFileSystem().readDirectory(modDir);
			trace(dirs);
		}
		catch (e)
		{
			trace(e);
			return;
		}

		var framework =
			#if nodefs
			Framework.OPENFL_WITH_NODE;
			#else
			Framework.OPENFL;
			#end

		var results = Polymod.init({
			modRoot: modDir,
			dirs: dirs,
			errorCallback: onError,
			ignoredFiles: Polymod.getDefaultIgnoreList(),
			framework: framework,
			assetPrefix: '',
			useScriptedClasses: true,
			loadScriptsAsync: #if html5 true #else false #end
		});

		for (mod in results)
		{
			trace('Found mod: ${mod.id}');
		}
	}

	public function onError(error:PolymodError)
	{
		trace('[${error.severity}] (${Std.string(error.code).toUpperCase()}): ${error.message}');
	}
}
