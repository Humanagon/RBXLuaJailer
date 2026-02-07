local wrapper = {}

wrapper.inherits_from = "ClickDetector"

wrapper.properties = {
	"ActivatedCursorIcon",
	"ApplyAtCenterOfMass",
	"Axis",
	"DragFrame",
	"DragStyle",
	"Enabled",
	"GamepadModeSwitchKeyCode",
	"KeyboardModeScriptKeyCode",
	"MaxDragAngle",
	"MaxDragTranslation",
	"MaxForce",
	"MaxTorque",
	"MinDragAngle",
	"MinDragTranslation",
	"Orientation",
	"ReferenceInstance",
	"ResponseStyle",
	"Responsiveness",
	"RunLocally",
	"SecondaryAxis",
	"TrackballRadialPullFactor",
	"TrackballRollFactor",
	"VRSwitchKeyCode",
	"WorldAxis",
	"WorldSecondaryAxis"
}

wrapper.methods = {
	"GetReferenceFrame",
	"RestartDrag"
}

wrapper.events = {
	"DragContinue",
	"DragEnd",
	"DragStart"
}

return wrapper
