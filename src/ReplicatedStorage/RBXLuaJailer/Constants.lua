--WARNING: This module is almost entirely deprecated. Please use the Settings module in the config folder of choice instead.

local constants = {
	--Settings:
	CreatePseudoShared = true, --If true, a fake shared table at shared[constants.PseudoSharedKey] will be created. This is useful for hiding the real shared table, but it also means that secured scripts won't be able to communicate with normal ones.
	AllowScriptSource = false, --Simulates the ability to change script sources. In order for this to work, you must ensure that there is nothing in the ReplicatedFirst called "RBXLuaJailerPointer", because this is what tells the fake scripts where the module is. It is recommended to create it yourself. Requires either loadstring or a lua interpreter lika vLua.
	AllowLoadLibrary = true, --If true, LoadLibrary will be emulated.
	UseSharedGlobal = true, --If true, the shared global will be used to store wrapper data so that all scripts can access the same wrapper for each instance.

	--Constants:
	PseudoSharedKey = "JAILED_SHARED_1033983", --Table key for the jailed shared table.
	PseudoGKey = "JAILED__G_1033983", --Table key for the jailed _G table.
	StaticStorageKey = "JAILED_STORAGE_1033983", --Table key for storing module data.
	RootClass = nil, --RootClass is the class that all unrecognized classes will default to. PLEASE KEEP THIS AS NIL. Allowing all Instances to be wrapped weather or not they're defined is dangerous and also may not be what the user wants.
	InstanceIdentifier = "SEMWrappedInstance1033983", --String used to verify that the instance wrapper is genuine and not a fraudulent table designed to exploit the API.
	EventIdentifier = "SEMWrappedEvent1033983", --Same as InstanceIdentifer, but for events.
	FunctionIdentifier = "SEMWrappedFunction1033983",
	AttributePropertyPrefix = "RLJPrpty_", --Prefix used to identify which attributes belong to custom properties.
	CoreAttributePrefix = "RLJProtctd_", --Used by the module to store important properties that should not be altered.
	CoreTagPrefix = "RBXLJP_", --Used by the module to identify core instances.

	--Whitelists:
	UseServiceWhitelist = true, --If true, only whitelisted services will be able to be found via the game DataModel.
	UseInstanceWhitelist = true, --If true, only instances of whitelisted classes will be able to be created via Instance.new().

	--Depricated:
	UseWrapperWhitelist = false --Was used to select which wrappers are allowed to be used. No longer has functionality.
}

--Defaults:
constants.default_attribute_values = {
	string = "",
	boolean = false,
	number = 0,
	UDim = UDim.new(0, 0),
	UDim2 = UDim2.new(0, 0, 0, 0),
	BrickColor = BrickColor.new("Really black"),
	Color3 = Color3.new(0, 0, 0),
	Vector2 = Vector2.new(0, 0),
	Vector3 = Vector3.new(0, 0, 0),
	CFrame = CFrame.new(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
	NumberSequence = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0, 0)}),
	ColorSequence = ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
	NumberRange = NumberRange.new(0, 0),
	Rect = Rect.new(Vector2.new(0, 0), Vector2.new(0, 0)),
	Font = Font.new("Source Sans Pro")
}

--Self references:
constants.LockedTag = constants.CoreTagPrefix .. "Locked" --Tag for locking instances. If an instance is locked, then RBXLuaJailer will simply return nil when it is wrapped.
constants.HiddenTag = constants.CoreTagPrefix .. "Hidden" --Similar to constants.LockedTag, except it can be destroyed if its parent is destroyed.
constants.CoreTag = constants.CoreTagPrefix .. "Core" --Marker to identify the internals of custom instance classes.
constants.CustomClass = constants.CoreAttributePrefix .. "CustomClass" --Used to store the name of a custom class.
constants.CoreScriptDisabledTag = constants.CoreTagPrefix .. "CoreScriptDisabled" --Used to specify if a script belonging to a custom class is disabled by default.
constants.ScriptPrivilegeLevelAttribute = constants.CoreAttributePrefix .. "ScriptPrivilegeLevel"
constants.ScriptSourceAttribute = constants.CoreAttributePrefix .. "Source" --The name of the attribute which stores script sources.

--Reserved table:
constants.reserved = {
	tags = {
		constants.LockedTag
	},
	tag_prefixes = {
		constants.CoreTagPrefix
	},
	attributes = {
		constants.ScriptSourceAttribute
	},
	attribute_prefixes = {
		constants.AttributePropertyPrefix,
		constants.CoreAttributePrefix
	}
}

return constants