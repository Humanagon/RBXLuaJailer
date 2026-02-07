local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.properties = {
	"Ambient",
	"Brightness",
	"ClockTime",
	"ColorShift_Bottom",
	"ColorShift_Top",
	"EnvironmentDiffuseScale",
	"EnvironmentSpecularScale",
	"ExposureCompensation",
	"FogColor",
	"FogEnd",
	"FogStart",
	"GeographicLatitude",
	"GlobalShadows",
	"OutdoorAmbient",
	"Outlines",
	"PrioritizeLightingQuality",
	"ShadowColor",
	"ShadowSoftness",
	"TimeOfDay"
}

wrapper.methods = {
	"GetMinutesAfterMidnight",
	"GetMoonDirection",
	"GetMoonPhase",
	"GetSunDirection",
	"SetMinutesAfterMidnight",
	"getMinutesAfterMidnight",
	"setMinutesAfterMidnight"
}

wrapper.events = {
	"LightingChanged"
}

return wrapper
