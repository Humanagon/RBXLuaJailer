local wrapper = {}

wrapper.inherits_from = "GuiObject"

wrapper.properties = {
	"ResampleMode",
	"ScaleType",
	"TileSize",
	"VideoColor3",
	"VideoRectOffset",
	"VideoRectSize",
	"VideoTransparency"
}

wrapper.methods = {
	"GetConnectedWires",
	"GetInputPins",
	"GetOutputPins"
}

wrapper.events = {
	"WiringChanged"
}

return wrapper
