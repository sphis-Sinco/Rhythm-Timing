package play.components;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
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
		this.y += elapsed * 1000;

		if (Conductor.songPosition >= mytime)
			this.destroy();

		super.update(elapsed);
	}
}