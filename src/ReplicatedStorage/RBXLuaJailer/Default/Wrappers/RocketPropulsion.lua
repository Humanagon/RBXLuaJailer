local wrapper = {}

wrapper.inherits_from = "BodyMover"

wrapper.properties = {
	"CartoonFactor",
	"MaxSpeed",
	"MaxThrust",
	"MaxTorque",
	"Target",
	"TargetOffset",
	"TargetRadius",
	"ThrustD",
	"ThrustP",
	"TurnD",
	"TurnP"
}

wrapper.methods = {
	"Abort",
	"Fire",
	"fire"
}

wrapper.events = {
	"ReachedTarget"
}

return wrapper
