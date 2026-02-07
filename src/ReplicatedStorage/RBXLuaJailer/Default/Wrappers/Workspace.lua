local wrapper = {}

wrapper.inherits_from = "WorldRoot"

wrapper.properties = {
	"AirDensity",
	"CurrentCamera",
	"GlobalWind",
	"Gravity",
	"InsertPoint"
}

wrapper.read_only_properties = {
	"Terrain"
}

wrapper.methods = {
	--This still needs to be finished.
}

return wrapper