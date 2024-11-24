package play.components;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import music.Conductor;

class NoteSpr extends FlxSprite
{
	public var mytime:Float = 0;

	override public function new(id:Int, time:Float)
	{
		super(x, y);
		mytime = time;

		frames = FlxAtlasFrames.fromSparrow('assets/images/Note_Assets.png', 'assets/images/Note_Assets.xml');
		animation.addByPrefix('dummy', 'dummyNote');
		animation.play('dummy');
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.y > FlxG.height)
		{
			active = false;
			visible = false;
		}
		else
		{
			visible = true;
			active = true;
		}

		var songSped = 1; // dummy variable
		
		// thank you ninjamuffin99
		this.y = (50 - (Conductor.songPosition - mytime) * (0.45 * FlxMath.roundDecimal(songSped, 2)));
	}
}