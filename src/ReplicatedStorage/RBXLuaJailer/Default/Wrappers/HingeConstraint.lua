local wrapper = {}

wrapper.inherits_from = "Constraint"

wrapper.properties = {
	"ActuatorType",
	"AngularResponsiveness",
	"AngularSpeed",
	"AngularVelocity",
	"CurrentAngle",
	"LimitsEnabled",
	"LowerAngle",
	"MotorMaxAcceleration",
	"MotorMaxTorque",
	"Radius",
	"Restitution",
	"ServoMaxTorque",
	"TargetAngle",
	"UpperAngle"
}

return wrapper
