local wrapper = {}

wrapper.inherits_from = "Motor"

wrapper.properties = {
	"Transform"
}

wrapper.read_only_properties = {
	"ChildName",
	"ParentName"
}

return wrapper
