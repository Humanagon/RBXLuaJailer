local wrapper = {}

wrapper.inherits_from = "PVInstance"

wrapper.properties = {
	"PrimaryPart",
	"WorldPivot",
	"ModelStreamingMode"
}

wrapper.methods = {
	"AddPersistentPlayer",
	"BreakJoints",
	"GetBoundingBox",
	"GetExtentsSize",
	"GetModelCFrame",
	"GetModelSize",
	"GetPersistentPlayers",
	"GetPrimaryPartCFrame",
	"GetScale",
	"MakeJoints",
	"MoveTo",
	"RemovePersistentPlayer",
	"ResetOrientationToIdentity",
	"SetPrimaryPartCFrame",
	"ScaleTo",
	"TranslateBy",
	"breakJoints",
	"makeJoints",
	"move",
	"moveTo"
}

return wrapper