package play.results;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import music.MusicState;
import play.components.Stats;

class ResultsState extends MusicState
{
	public var STATS:Stats = {
		song: "Test",
		totalNotes: 4,
		hits: 4,
		misses: 0
	};

	public var rank:String = 'perfect';

	public var percent:Float = 0.0;
	public var targpercent:Float = 100.0;
	public var reachedTarget:Bool = false;
	public var percentTick:Float = 0.0;
	public var percentTickGoal:Float = 5.0;

	public var rankText:FlxText;
	public var ranksubText:FlxText;
	public var percentText:FlxText;

	override public function new(gameplayStats:Stats)
	{
		trace(gameplayStats);
		STATS = gameplayStats;

		targpercent = (STATS.hits / STATS.totalNotes) * 100;
		rankInit();
        
		rankText = new FlxText(10, 10, 0, "YOU DID...", 64);

		ranksubText = new FlxText(10, rankText.y + rankText.height + 8, 0, "0%", 24);
		ranksubText.visible = false;
		ranksubText.color = FlxColor.GRAY;

		percentText = new FlxText(0, 0, 0, "0%", 32);
		percentText.screenCenter(XY);

		trace('ResultsState inited!');
		super();
	}

	public function rankInit()
	{
		trace(targpercent + '%');

		if (targpercent == 100)
			rank = 'perfect';
		else if (targpercent >= 90)
			rank = 'excellent';
		else if (targpercent >= 80)
			rank = 'great';
		else if (targpercent >= 60)
			rank = 'good';
		else if (targpercent >= 10)
			rank = 'bad';
		else
			rank = 'awful';
	}

	override public function create()
	{
		add(rankText);
		add(ranksubText);
		add(percentText);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (percent < targpercent)
		{
			if (percentTick == percentTickGoal)
			{
				percentTick = 0;

				if (percent == 0)
					percent++;
				else
					percent += (percent / targpercent) * 50;
			}

			if (percent > targpercent)
				percent = targpercent;

			percentText.text = '${FlxMath.roundDecimal(percent, 0)}%';
			percentText.screenCenter(XY);
		}
		else
		{
			if (percentTick == percentTickGoal * 2)
			{
				if (!reachedTarget)
					trace('Rank Target Made!');

				FlxG.camera.flash();

				rankText.text = "YOU DID " + rank.toUpperCase() + "!";
				percentText.visible = false;
				ranksubText.text = percentText.text;
				ranksubText.visible = true;

				reachedTarget = true;
			}
		}

		percentTick += 1;

		super.update(elapsed);
	}
}