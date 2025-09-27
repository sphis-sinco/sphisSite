package;

import flixel.FlxState;
import polymod.Polymod;

class InitState extends FlxState
{
	override public function create()
	{
		super.create();

		loadMods([]);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function loadMods(dirs:Array<String>)
	{
		#if nodefs
		var framework = Framework.OPENFL_WITH_NODE;
		#else
		var framework = Framework.OPENFL;
		#end
		var modRoot = '../../../mods/';
		#if mac
		// account for <APPLICATION>.app/Contents/Resources
		var modRoot = '../../../../../../mods';
		#end
		var results = Polymod.init({
			modRoot: modRoot,
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
