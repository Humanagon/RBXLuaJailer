local wrapper = {}

wrapper.inherits_from = "HandlesBase"

wrapper.properties = {
	"Axes"
}

wrapper.events = {
	"MouseButton1Down",
	"MouseButton1Up",
	"MouseDrag",
	"MouseEnter",
	"MouseLeave"
}

return wrapper
