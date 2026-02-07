local wrapper = {}

wrapper.inherits_from = "GuiObject"

wrapper.properties = {
	"ClearTextOnFocus",
	"ContentText",
	"CursorPosition",
	"Font",
	"FontFace",
	"FontSize",
	"LineHeight",
	"MaxVisibleGraphemes",
	"MultiLine",
	--"OpenTypeFeatures",
	--"OpenTypeFeaturesError",
	"PlaceholderColor3",
	"PlaceholderText",
	"RichText",
	"SelectionStart",
	"ShowNativeInput",
	"Text",
	"TextBounds",
	"TextColor",
	"TextColor3",
	"TextDirection",
	"TextEditable",
	"TextFits",
	"TextScaled",
	"TextSize",
	"TextStrokeColor3",
	"TextStrokeTransparency",
	"TextTransparency",
	"TextTruncate",
	"TextWrap",
	"TextWrapped",
	"TextXAlignment",
	"TextYAlignment",
}

wrapper.methods = {
	"CaptureFocus",
	"IsFocused",
	"ReleaseFocus"
}

wrapper.events = {
	"FocusLost",
	"Focused",
	"ReturnPressedFromOnScreenKeyboard"
}

return wrapper
