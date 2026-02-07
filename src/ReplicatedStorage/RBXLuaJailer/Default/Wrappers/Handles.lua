local wrapper = {}

wrapper.inherits_from = "HandlesBase"

wrapper.properties = {
	"Faces",
	"Style"
}

wrapper.events = {
	"MouseButton1Down",
	"MouseButton1Up",
	"MouseDrag",
	"MouseEnter",
	"MouseLeave"
}

return wrapper
