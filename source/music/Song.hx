package music;

typedef Song =
{
	var name:String;
	var bpm:Float;
	var notes:Array<Note>;
}

typedef Note =
{
	var noteId:Int;
	var noteTime:Float;
}