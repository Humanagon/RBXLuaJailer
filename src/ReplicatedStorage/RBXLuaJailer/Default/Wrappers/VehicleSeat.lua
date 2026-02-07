local wrapper = {}

wrapper.inherits_from = "BasePart"

wrapper.properties = {
	"AreHingesDetected",
	"Disabled",
	"HeadsUpDisplay",
	"MaxSpeed",
	"Occupant",
	"Steer",
	"SteerFloat",
	"Throttle",
	"ThrottleFloat",
	"Torque",
	"TurnSpeed"
}

wrapper.methods = {
	"Sit"
}

return wrapper
