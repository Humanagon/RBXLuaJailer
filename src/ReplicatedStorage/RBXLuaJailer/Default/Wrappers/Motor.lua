local wrapper = {}

wrapper.inherits_from = "JointInstance"

wrapper.properties = {
	"CurrentAngle",
	"DesiredAngle",
	"MaxVelocity"
}

wrapper.methods = {
	"SetDesiredAngle"
}

return wrapper