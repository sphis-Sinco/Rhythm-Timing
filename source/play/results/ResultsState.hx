package play.results;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import music.MusicState;

class ResultsState extends MusicState
{
	public var rank:String = 'perfect';

	public var percent:Float = 0.0;
	public var targpercent:Float = 100.0;
	public var reachedTarget:Bool = false;
	public var percentTick:Float = 0.0;
	public var percentTickGoal:Float = 5.0;

	public var rankText:FlxText;
	public var percentText:FlxText;

	override public function new()
	{
		rankText = new FlxText(10, 10, 0, "YOU DID...", 64);

		percentText = new FlxText(0, 0, 0, "0%", 32);
		percentText.screenCenter(XY);

		trace('ResultsState inited!');
		super();
	}

	override public function create()
	{
		add(rankText);
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

				reachedTarget = true;
			}
		}

		percentTick += 1;

		super.update(elapsed);
	}
}