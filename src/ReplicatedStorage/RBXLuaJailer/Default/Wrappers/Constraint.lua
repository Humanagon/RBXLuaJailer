local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.properties = {
	"Attachment0",
	"Attachment1",
	"Color",
	"Enabled",
	"Visible"
}

wrapper.read_only_properties = {
	"Active"
}

return wrapper