package play;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import haxe.Json;
import music.Conductor;
import music.MusicState;
import music.Song;
import openfl.Assets;
import play.components.NoteSpr;
import play.components.Stats;
import play.results.ResultsState;

class PlayState extends MusicState
{
	public static var SONG_JSON:Song;
	public var SONG_STATS:Stats;

	public var startedSong:Bool = false;
	public var endedSong:Bool = false;

	public var songPos:FlxText;

	public var noteGrp:FlxTypedGroup<NoteSpr> = new FlxTypedGroup<NoteSpr>();

	public static var strumlineY:Float = 50;

	public var sickLine:FlxSprite = new FlxSprite().makeGraphic(640, 20);
	public var goodLine:FlxSprite = new FlxSprite().makeGraphic(640, 20);

	override public function new(song:String = 'Test')
	{
		// set song json
		try
		{
			SONG_JSON = Json.parse(Assets.getText('assets/data/songs/$song.json'));
		}
		catch (e)
		{
			SONG_JSON = Json.parse(Assets.getText('assets/data/songs/Test.json'));
		}

		// set the base song stat info
		SONG_STATS = {
			song: SONG_JSON.name,
			totalNotes: SONG_JSON.notes.length,
			hits: 0,
			misses: 0
		}

		// base stuff to get conductor workin
		Conductor.mapBPMChanges(SONG_JSON);
		Conductor.changeBPM(SONG_JSON.bpm);

		// play the song
		FlxG.sound.playMusic('assets/music/Test.wav', 1.0, false);
		FlxG.sound.music.onComplete = endSong;
		FlxG.sound.pause();

		// set song position
		Conductor.songPosition = 0;

		// init songPos Text
		songPos = new FlxText(0, 0, 0, "Hello", 16);

		// init lines
		var exNote:NoteSpr = new NoteSpr(1, 0);
		sickLine.y = strumlineY - exNote.height * 0.5;
		goodLine.y = strumlineY - exNote.height * 1;

		sickLine.screenCenter(X);
		goodLine.screenCenter(X);

		super();
	}

	override public function create()
	{

		// add anything that should be added that was initalized in new()
		add(songPos);
		add(sickLine);
		add(goodLine);

		// note adding
		for (note in SONG_JSON.notes)
		{
			var newNote:NoteSpr = new NoteSpr(note.noteId, note.noteTime);
			newNote.missCallback = noteMiss;
			noteGrp.add(newNote);
		}
		add(noteGrp);
		
		super.create();
	}

	public function noteMiss()
	{
		SONG_STATS.misses++;
	}

	override public function update(elapsed:Float)
	{
		// only move the songPosition if the song hasn't ended
		if (!endedSong)
			Conductor.songPosition += elapsed * 1000;

		// if the songPosition is more than or equal than 0 and we have not started the song
		if (Conductor.songPosition >= 0 && !startedSong)
		{
			// start the song and music
			startedSong = true;
			FlxG.sound.music.resume();
		}

		// Song Position Info
		var musicLen:Float = FlxG.sound.music.length / 1000; // divide by 1000 cause its in miliseconds
		var timeLeft:Float = FlxMath.roundDecimal(musicLen - Conductor.songPosition / 1000, 0);

		// this is for the countdown (when I add it)
		if (timeLeft > musicLen)
			timeLeft = musicLen; // countdown time doesnt add to the length

		// song position text
		var songText:String = '' + timeLeft;
		songPos.text = "Song Pos: " + songText;

		super.update(elapsed);
	}

	public function endSong()
	{
		// end the song and go to the results state with the song stats info
		endedSong = true;
		FlxG.switchState(new ResultsState(SONG_STATS));
	}
}
