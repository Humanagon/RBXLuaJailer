local wrapper = {}

wrapper.inherits_from = "BodyMover"

wrapper.properties = {
	"D",
	"MaxForce",
	"P",
	"Position",
	"maxForce",
	"position"
}

wrapper.methods = {
	"GetLastForce",
	"lastForce"
}

wrapper.events = {
	"ReachedTarget"
}

return wrapper
