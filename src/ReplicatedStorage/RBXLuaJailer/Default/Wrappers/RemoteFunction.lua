local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.methods = {
	"InvokeClient",
	"InvokeServer"
}

wrapper.callbacks = {
	"OnClientInvoke",
	"OnServerInvoke"
}

return wrapper
