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

		this.y -= 2000;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.y > FlxG.height)
		{
			active = false;
			visible = false;
			this.destroy();
		}
		else
		{
			visible = true;
			active = true;
		}

		// thank you ninjamuffin99
		this.y = (Conductor.songPosition - mytime) * (0.45 * FlxMath.roundDecimal(1, 2));
	}
}