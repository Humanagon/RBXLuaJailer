local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.properties = {
	"BlastPressure",
	"BlastRadius",
	"DestroyJointRadiusPercent",
	"ExplosionType",
	"LocalTransparencyModifier",
	"Position",
	"TimeScale",
	"Visible"
}

wrapper.events = {
	"Hit"
}

return wrapper
