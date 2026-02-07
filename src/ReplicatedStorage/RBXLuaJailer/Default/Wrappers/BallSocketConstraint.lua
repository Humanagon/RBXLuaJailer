local wrapper = {}

wrapper.inherits_from = "Constraint"

wrapper.properties = {
	"LimitsEnabled",
	"MaxFrictionTorque",
	"Radius",
	"Restitution",
	"TwistLimitsEnabled",
	"TwistLowerAngle",
	"TwistUpperAngle",
	"UpperAngle"
}

return wrapper
