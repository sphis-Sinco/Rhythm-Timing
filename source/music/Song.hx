package music;

typedef Song =
{
	var name:String;
	var bpm:Float;
	var speed:Float;
	var notes:Array<Note>;
}

typedef Note =
{
	var noteId:Int;
	var noteTime:Float;
}