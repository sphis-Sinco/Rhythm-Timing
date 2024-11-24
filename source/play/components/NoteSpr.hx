package play.components;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxSignal;
import music.Conductor;
import shaders.HSVShader;

class NoteSpr extends FlxSprite
{
	public var mytime:Float = 0;

	public var hit:Bool = true;

	public var missCallback:Void->Void = null;

	var hsvShader:HSVShader;

	override public function new(id:Int, time:Float)
	{
		super(x, y);
		mytime = time;

		frames = FlxAtlasFrames.fromSparrow('assets/images/Note_Assets.png', 'assets/images/Note_Assets.xml');
		animation.addByPrefix('dummy', 'dummyNote');
		animation.play('dummy');
		screenCenter();
		this.hsvShader = new HSVShader();
		this.shader = hsvShader;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// thank you ninjamuffin99
		y = (PlayState.strumlineY - (Conductor.songPosition - mytime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG_JSON.speed, 2)));
		
		// miss system
		if (y < PlayState.strumlineY && hit)
		{
			hit = false; // miss
			missCallback();
			desaturate();
		}

		// outta bounds "system"
		if (y <= -5000)
		{
			trace('outa bounds!');
			destroy();
		}
	}
	public function desaturate():Void
	{
		this.hsvShader.saturation = 0.2;
	}

	public function setHue(hue:Float):Void
	{
		this.hsvShader.hue = hue;
	}

	public override function revive():Void
	{
		super.revive();
		this.visible = true;
		this.alpha = 1.0;
		this.active = false;

		this.hsvShader.hue = 1.0;
		this.hsvShader.saturation = 1.0;
		this.hsvShader.value = 1.0;
	}
}