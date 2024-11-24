package play.components;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import music.Conductor;

class NoteSpr extends FlxSprite
{
	public var mytime:Float = 0;

	public var hit:Bool = true;

	override public function new(id:Int, time:Float)
	{
		super(x, y);
		mytime = time;

		frames = FlxAtlasFrames.fromSparrow('assets/images/Note_Assets.png', 'assets/images/Note_Assets.xml');
		animation.addByPrefix('dummy', 'dummyNote');
		animation.play('dummy');
		screenCenter();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// thank you ninjamuffin99
		y = (PlayState.strumlineY - (Conductor.songPosition - mytime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG_JSON.speed, 2)));
		
		// miss system
		if (y < PlayState.strumlineY)
			hit = false; // miss

		// outta bounds "system"
		if (y <= -5000)
		{
			trace('outa bounds!');
			destroy();
		}
	}
}