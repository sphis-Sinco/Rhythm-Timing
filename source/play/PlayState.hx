package play;

import flixel.FlxG;
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

		songPos = new FlxText(0, 0, 0, "Hello", 16);
		super();
	}

	override public function create()
	{
		add(songPos);

		
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
		
		super.update(elapsed);
	}

	public function endSong()
	{
		trace('we done');
		endedSong = true;
		FlxG.switchState(new ResultsState(SONG_STATS));
	}

	override public function beatHit()
	{
		if (startedSong)
		{
			SONG_STATS.beatsTotal++;

			if (FlxG.random.bool(25))
				SONG_STATS.beatsMissed++;
			else
				SONG_STATS.beatsHit++;
		}

		super.beatHit();
	}
}
