return {
	ReservedTagPrefix = "RBXLJT_", --General purpose reserved tag prefix. Tags starting with this will not be modifiable by wrapped instances.
	ReservedAttributePrefix = "RBXLJA_", --Same as ReservedTagPrefix but for attributes.
	CustomClassAttribute = "RBXLJA_PseudoClass", --Attribute used to disguise a class as another.
	AttributePropertyPrefix = "RLJPrpty_", --Used to easily notate fake properties stored as attributes.
	TablesAreWrapped = false, --If true, tables will be represented by metatable wrappers. If false, they will be iterated through and cloned with wrapped items.
	WrapperDataType = "table", --Determines what type of data will be used to represent things. Can be "table" or "userdata".
	CustomTypePrefix = "RLJType1033:", --Defines the returned strings of type and typeof respectively. It is stored in the __metatable method. Seperated by colons. For example, a custom Instance might be: "RLJType1033:userdata:Instance"
	WhitelistedTag = nil, --If set to a string, all instances must have the string as a tag in order to be wrapped and used, or otherwise causing an error if they lack it.
	UseLoadStringIfAvailable = false, --Weather or not to use loadstring. It's generally recommended to have this set to false since real loadstring can't have built-in anti Instance security like a module interpreter can.
	RequiredPermissionAttribute = "RBXLJA_RequiredPermisson", --Required permission to index members.
	AutoWrapCustomMembers = true, --Forces all custom class members to be wrapped. If true, method returns will be auto wrapped, as well as custom events and properties.
	ProxyDictionarySharedKey = "RLJProxyDict", --If set to a string, all wrapper proxies (table or userdata) will be added to a dictionary in the shared table which points to the real instance/function/event/datatype.
	SchemaDictionarySharedKey = "RLJSchemaDict", --Same as ProxyDictionarySharedKey, but for GetWrapperTable.
	DisableAPIFunctions = false --Disables GetWrapperObject and GetWrapperTable. Useful for when ProxyDictionarySharedKey is enabled.
}
