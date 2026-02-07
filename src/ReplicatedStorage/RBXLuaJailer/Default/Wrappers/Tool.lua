local wrapper = {}

wrapper.inherits_from = "BackpackItem"

wrapper.properties = {
	"Enabled",
	"Grip",
	"ManualActivationOnly",
	"RequiresHandle",
	"ToolTip"
}

wrapper.events = {
	"Equipped",
	"Unequipped",
	"Activated"
}

wrapper.methods = {
	"Activate"
}

return wrapper