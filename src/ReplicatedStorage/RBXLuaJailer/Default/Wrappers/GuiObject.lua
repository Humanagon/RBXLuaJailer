local wrapper = {}

wrapper.inherits_from = "GuiBase2d"

wrapper.properties = {
	"Active",
	"AnchorPoint",
	"AutomaticSize",
	"BackgroundColor",
	"BackgroundColor3",
	"BackgroundTransparency",
	"BorderColor",
	"BorderColor3",
	"BorderMode",
	"BorderSizePixel",
	"ClipsDescendants",
	"Draggable",
	"GuiState",
	"Interactable",
	"LayoutOrder",
	"NextSelectionDown",
	"NextSelectionLeft",
	"NextSelectionRight",
	"NextSelectionUp",
	"Position",
	"Rotation",
	"Selectable",
	"SelectionImageObject",
	"SelectionOrder",
	"Size",
	"SizeConstraint",
	"Transparency",
	"Visible",
	"ZIndex"
}

wrapper.methods = {
	"TweenPosition",
	"TweenSize",
	"TweenSizeAndPosition"
}

wrapper.events = {
	"DragBegin",
	"DragStopped",
	"InputBegan",
	"InputChanged",
	"InputEnded",
	"MouseEnter",
	"MouseLeave",
	"MouseMoved",
	"MouseWheelBackward",
	"MouseWheelForward",
	"SelectionGained",
	"SelectionLost",
	"TouchLongPress",
	"TouchPan",
	"TouchPinch",
	"TouchRotate",
	"TouchSwipe",
	"TouchTap"
}

return wrapper
