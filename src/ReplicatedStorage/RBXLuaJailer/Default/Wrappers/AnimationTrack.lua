local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.properties = {
	"Animation",
	"IsPlaying",
	"Length",
	"Looped",
	"Priority",
	"Speed",
	"TimePosition",
	"WeightCurrent",
	"WeightTarget"
}

wrapper.methods = {
	"AdjustSpeed",
	"AdjustWeight",
	"GetMarkerReachedSignal",
	"GetTargetInstance",
	"GetTargetNames",
	"GetTimeOfKeyframe",
	"Play",
	"SetTargetInstance",
	"Stop"
}

wrapper.events = {
	"DidLoop",
	"Ended",
	"KeyframeReached",
	"Stopped"
}

return wrapper
