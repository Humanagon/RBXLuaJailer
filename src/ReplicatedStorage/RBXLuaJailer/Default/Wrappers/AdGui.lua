local wrapper = {}

wrapper.inherits_from = "SurfaceGuiBase"

wrapper.properties = {
	"AdShape",
	"EnableVideoAds",
	"FallbackImage",
	"Status"
}

wrapper.callbacks = {
	"OnAdEvent"
}

return wrapper
