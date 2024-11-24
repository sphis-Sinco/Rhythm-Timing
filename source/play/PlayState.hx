package play;

import music.Conductor;
import music.MusicState;

class PlayState extends MusicState
{
	override public function create()
	{
		Conductor.changeBPM(100);
		
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
