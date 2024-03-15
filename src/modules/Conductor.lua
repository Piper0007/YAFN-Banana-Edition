local bpm=100;
local crochet=((60/bpm)*1000);
local stepBrochet= crochet/4;
local safeZoneOffset=166
local screenSize = Vector2.new()
return {
	BPM=bpm;
	screenSize = screenSize;
	crochet=crochet;
	stepCrochet=stepBrochet;
	safeZoneOffset=safeZoneOffset;
	bpmChangeMap={};
	timePosition=0;
	CurrentTrackPos=0;
	AdjustedSongPos=0;
	PlaybackSpeed=1;
	SVIndex=0;
	songPosition=0;
	SongPos=0;
	TimePos=0;
	Downscroll = false;
	ChangeBPM=function(self,newBpm)
		self.BPM = newBpm
		self.crochet=((60/self.BPM)*1000);
		self.stepCrochet= self.crochet/4;
	end,
}
