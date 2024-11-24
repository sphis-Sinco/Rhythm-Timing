package play;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import music.Conductor;
import music.MusicState;
import music.Song;
import play.components.Stats;
import play.results.ResultsState;

class PlayState extends MusicState
{
	public var SONG_JSON:Song;
	public var SONG_STATS:Stats;

	public var startedSong:Bool = false;
	public var endedSong:Bool = false;

	public var songPos:FlxText;

	public var letGo:Bool = true;

	public var key:FlxSprite;

	override public function new()
	{
		SONG_JSON = {
			name: "Test",
			bpm: 150
		}

		SONG_STATS = {
			song: SONG_JSON.name,
			beatsTotal: 0,
			beatsHit: 0,
			beatsMissed: 0
		}

		Conductor.mapBPMChanges(SONG_JSON);
		Conductor.changeBPM(SONG_JSON.bpm);

		FlxG.sound.playMusic('assets/music/Test.wav', 1.0, false);
		FlxG.sound.music.onComplete = endSong;
		FlxG.sound.pause();

		Conductor.songPosition = 0;

		var spritesheet = FlxAtlasFrames.fromSparrow('assets/images/key.png', 'assets/images/key.xml');
		key = new FlxSprite();
		key.frames = spritesheet;
		key.animation.addByPrefix('idle', 'key idle');
		key.animation.addByPrefix('prep', 'key press prep');
		key.animation.addByPrefix('hit', 'key press perfect');
		key.animation.addByPrefix('miss', 'key press fail');
		key.animation.play('idle');
		key.screenCenter();
		
		songPos = new FlxText(0, 0, 0, "Hello", 16);
		super();
	}

	override public function create()
	{
		add(songPos);
		add(key);
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (!endedSong)
			Conductor.songPosition += elapsed * 1000;

		if (Conductor.songPosition > 0 && !startedSong)
		{
			startedSong = true;
			FlxG.sound.music.resume();
		}

		var musicLen:Float = FlxG.sound.music.length / 1000;
		var timeLeft:Float = FlxMath.roundDecimal(musicLen - Conductor.songPosition / 1000, 0);

		if (timeLeft > musicLen)
			timeLeft = musicLen; // countdown time doesnt add to the length

		var songText:String = '' + timeLeft;

		songPos.text = "Song Pos: " + songText;

		if (!FlxG.keys.pressed.SPACE && !letGo)
			letGo = true;
		
		super.update(elapsed);
	}

	public function endSong()
	{
		trace('we done');
		endedSong = true;
		FlxG.switchState(new ResultsState(SONG_STATS));
	}

	override public function stepHit()
	{
		if (curStep % 3 == 0)
			trace('PRESS SPACE NOW\ncurBeat: $curBeat');

		super.stepHit();
	}
	
	override public function beatHit()
	{
		if (startedSong)
		{
			SONG_STATS.beatsTotal++;

			if (FlxG.keys.pressed.SPACE && letGo)
			{
				letGo = false;
				trace('hit');
				SONG_STATS.beatsHit++;
			}
			else
			{
				trace('misseds');
				SONG_STATS.beatsMissed++;
			}
		}

		super.beatHit();
	}
}
