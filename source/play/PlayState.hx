package play;

import flixel.FlxG;
import music.Conductor;
import music.MusicState;
import music.Song;

class PlayState extends MusicState
{
	public var SONG:Song;

	override public function create()
	{
		SONG = {
			name: "Test",
			bpm: 100
		}

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		Conductor.songPosition = -5000;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		Conductor.songPosition += elapsed * 1000;
		
		super.update(elapsed);
	}
}
