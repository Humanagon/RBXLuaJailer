local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.methods = {
	"BindToRenderStep",
	"IsClient",
	--"IsRunMode",
	--"IsRunning",
	"IsServer",
	--"IsStudio"
}

wrapper.events = {
	"Heartbeat",
	--"PostSimulation",
	--"PreAnimation",
	--"PreRender",
	--"PreSimulation",
	"RenderStepped",
	"Stepped"
}

return wrapper
