local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.properties = {
	"ChannelCount",
	"EmitterSize",
	"IsLoaded",
	"IsPaused",
	"IsPlaying",
	"LoopRegion",
	"Looped",
	"MaxDistance",
	"MinDistance",
	"Pitch",
	"PlayOnRemove",
	"PlaybackLoudness",
	"PlaybackRegion",
	"PlaybackRegionsEnabled",
	"PlaybackSpeed",
	"Playing",
	"RollOffMaxDistance",
	"RollOffMinDistance",
	"RollOffMode",
	"SoundGroup",
	"SoundId",
	"TimeLength",
	"TimePosition",
	"Volume",
	"isPlaying"
}

wrapper.methods = {
	"Pause",
	"Play",
	"Resume",
	"Stop",
	"pause",
	"play",
	"stop"
}

wrapper.events = {
	"DidLoop",
	"Ended",
	"Loaded",
	"Paused",
	"Played",
	"Resumed",
	"Stopped"
}

return wrapper
