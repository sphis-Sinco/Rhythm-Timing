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
	public var myNoteHit:Bool = false;

	public var missCallback:Void->Void = null;

	var hsvShader:HSVShader;

	override public function new(id:Int, time:Float)
	{
		super(x, y);
		mytime = time;
		ID = id;

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

		switch (ID)
		{
			case 1:
				myNoteHit = FlxG.keys.justReleased.SPACE;

			default:
				myNoteHit = false;
		}

		// thank you ninjamuffin99
		y = (PlayState.strumlineY - (Conductor.songPosition - mytime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG_JSON.speed, 2)));
		
		// miss system
		if (y < PlayState.strumlineY && hit)
		{
			missFunc();
		}
		else
		{
			if (y >= PlayState.strumlineY && y <= FlxG.height - height)
			{
				if (myNoteHit)
				{
					if (y >= PlayState.strumlineY - height * 1.5)
					{
						missFunc();
					}
					else if (y >= PlayState.strumlineY - height * 1)
					{
						// good popup
						trace('good');
					}
					else if (y >= PlayState.strumlineY - height * 0.5)
					{
						// sick popup
						trace('sick');
					}
					destroy();
				}
			}
		}

		// outta bounds "system"
		if (y <= -5000)
		{
			destroy();
		}
		setHue(0);
		// hue stuff for popup
		if (y >= PlayState.strumlineY - height * 0.5)
			setHue(15);
		else if (y >= PlayState.strumlineY - height * 1)
			setHue(30);
	}
	public function missFunc()
	{
		hit = false; // miss register
		missCallback();
		desaturate();
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