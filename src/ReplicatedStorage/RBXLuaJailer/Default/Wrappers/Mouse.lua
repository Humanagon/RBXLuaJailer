local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.properties = {
	"Hit",
	"Icon",
	"Origin",
	"Target",
	"TargetFilter",
	"TargetSurface",
	"UnitRay",
	"ViewSizeX",
	"ViewSizeY",
	"X",
	"Y",
	"hit",
	"target"
}

wrapper.events = {
	"Button1Down",
	"Button1Up",
	"Button2Down",
	"Button2Up",
	"Idle",
	"KeyDown",
	"KeyUp",
	"WheelBackward",
	"WheelForward",
	"keyDown"
}

return wrapper
