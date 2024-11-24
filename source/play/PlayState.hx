package play;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import music.Conductor;
import music.MusicState;
import music.Song;

class PlayState extends MusicState
{
	public var SONG:Song;
	public var startedSong:Bool = false;

	public var songPos:FlxText;

	override public function create()
	{
		SONG = {
			name: "Test",
			bpm: 150
		}

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		Conductor.songPosition = -5000;
		songPos = new FlxText(0, 0, 0, "Hello", 16);
		add(songPos);

		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		Conductor.songPosition += elapsed * 1000;
		if (Conductor.songPosition > 0 && !startedSong)
		{
			startedSong = true;
			FlxG.sound.playMusic('assets/music/Test.wav', 1.0, false);
		}

		songPos.text = "Song Pos: " + FlxMath.roundDecimal(Conductor.songPosition * 1000, 0);
		
		super.update(elapsed);
	}
}
