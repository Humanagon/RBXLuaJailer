local wrapper = {}

wrapper.inherits_from = "GuiBase"

wrapper.properties = {
	"AbsolutePosition",
	"AbsoluteRotation",
	"AbsoluteSize",
	--"AutoLocalize",
	--"Localize",
	--"RootLocalizationTable",
	"SelectionBehaviorDown",
	"SelectionBehaviorLeft",
	"SelectionBehaviorRight",
	"SelectionBehaviorUp",
	"SelectionGroup"
}

wrapper.events = {
	"SelectionChanged"
}

return wrapper
