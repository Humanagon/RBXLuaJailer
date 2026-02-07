local wrapper = {}

wrapper.inherits_from = "BaseRemoteEvent"

wrapper.methods = {
	"FireAllClients",
	"FireClient",
	"FireServer"
}

wrapper.events = {
	"OnClientEvent",
	"OnServerEvent"
}

return wrapper
