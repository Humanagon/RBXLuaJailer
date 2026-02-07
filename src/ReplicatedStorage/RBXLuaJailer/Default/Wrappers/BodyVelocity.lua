local wrapper = {}

wrapper.inherits_from = "BodyMover"

wrapper.properties = {
	"MaxForce",
	"P",
	"maxForce",
	"velocity"
}

wrapper.methods = {
	"GetLastForce",
	"lastForce"
}

return wrapper
