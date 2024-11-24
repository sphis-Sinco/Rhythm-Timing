package play.results;

import flixel.text.FlxText;
import music.MusicState;

class ResultsState extends MusicState
{
	public var rank:String = 'good';

	public var rankText:FlxText;

	override public function new()
	{
		rankText = new FlxText(10, 10, 0, "YOU DID...", 64);

		trace('ResultsState inited!');
		super();
	}

	override public function create()
	{
		add(rankText);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}