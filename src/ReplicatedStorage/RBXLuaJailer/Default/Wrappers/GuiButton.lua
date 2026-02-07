local wrapper = {}

wrapper.inherits_from = "GuiObject"

wrapper.properties = {
	"AutoButtonColor",
	--"HoverHapticEffect",
	"Modal",
	--"PressHapticEffect",
	"Selected",
	"Style"
}

wrapper.events = {
	"Activated",
	"MouseButton1Click",
	"MouseButton1Down",
	"MouseButton1Up",
	"MouseButton2Click",
	"MouseButton2Down",
	"MouseButton2Up"
}

return wrapper
