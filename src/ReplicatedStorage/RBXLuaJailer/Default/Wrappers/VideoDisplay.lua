local wrapper = {}

wrapper.inherits_from = "GuiObject"

wrapper.properties = {
	"IsLoaded",
	"Looped",
	"Playing",
	"Resolution",
	"TimeLength",
	"TimePosition",
	"Video",
	"Volume"
}

wrapper.methods = {
	"Pause",
	"Play"
}

wrapper.events = {
	"DidLoop",
	"Ended",
	"Loaded",
	"Paused",
	"Played"
}

return wrapper
