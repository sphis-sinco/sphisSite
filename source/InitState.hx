package;

import flixel.FlxState;
import polymod.Polymod;

class InitState extends FlxState
{
	var modDir:String = 'mods';

	override public function create()
	{
		super.create();

		var mods =
			#if nodefs
			new NodeFileSystem({modRoot: modDir}).readDirectory(modDir);
			#else
			#if cpp
			sys.FileSystem.readDirectory(modDir);
			#else
			[];
			#end
			#end

		loadMods(mods);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function loadMods(dirs:Array<String>)
	{
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
		});
	}

	public function onError(error:PolymodError)
	{
		trace('[${error.severity}] (${Std.string(error.code).toUpperCase()}): ${error.message}');
	}
}
