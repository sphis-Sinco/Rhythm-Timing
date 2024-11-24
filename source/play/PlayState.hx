package play;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import music.Conductor;
import music.MusicState;
import music.Song;

class PlayState extends MusicState
{
	public var SONG_JSON:Song;

	public var startedSong:Bool = false;
	public var endedSong:Bool = false;

	public var songPos:FlxText;

	override public function create()
	{
		SONG_JSON = {
			name: "Test",
			bpm: 150
		}

		Conductor.mapBPMChanges(SONG_JSON);
		Conductor.changeBPM(SONG_JSON.bpm);

		FlxG.sound.playMusic('assets/music/Test.wav', 1.0, false);
		FlxG.sound.music.onComplete = endSong;
		FlxG.sound.pause();

		Conductor.songPosition = -5000;

		songPos = new FlxText(0, 0, 0, "Hello", 16);
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

		var songText:String = '' + (FlxG.sound.music.length - (FlxMath.roundDecimal((Conductor.songPosition / 1000), 0)));
		songPos.text = "Song Pos: " + songText;
		
		super.update(elapsed);
	}

	public function endSong()
	{
		trace('we done');
		endedSong = true;
	}
}
