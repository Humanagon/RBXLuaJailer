local wrapper = {}

wrapper.inherits_from = "PVInstance"

wrapper.properties = {
	"CFrame",
	"CameraSubject",
	"CameraType",
	"CoordinateFrame",
	"DiagonalFieldOfView",
	"FieldOfView",
	"FieldOfViewMode",
	"Focus",
	"HeadLocked",
	"HeadScale",
	"MaxAxisFieldOfView",
	"NearPlaneZ",
	"VRTiltAndRollEnabled",
	"ViewportSize",
	"focus"
}

wrapper.methods = {
	"GetLargestCutoffDistance",
	"GetPanSpeed",
	"GetPartsObscuringTarget",
	"GetRenderCFrame",
	"GetRoll",
	"GetTiltSpeed",
	"Interpolate",
	"PanUnits",
	"ScreenPointToRay",
	"SetCameraPanMode",
	"SetRoll",
	"TiltUnits",
	"ViewportPointToRay",
	"WorldToScreenPoint",
	"WorldToViewportPoint",
	"ZoomToExtents"
}

wrapper.events = {
	"InterpolationFinished"
}

return wrapper
