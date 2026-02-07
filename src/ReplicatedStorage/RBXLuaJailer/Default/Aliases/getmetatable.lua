return function(module)
	if module.settings.WrapperDataType == "userdata" then
		return function(val)
			local metatable = getmetatable(val)
			if typeof(val) == "userdata" and type(metatable) == "string" and (metatable == module.constants.InstanceIdentifier or metatable == module.constants.EventIdentifier or metatable == module.constants.FunctionIdentifier or string.sub(metatable, 1, #module.settings.CustomTypePrefix) == module.settings.CustomTypePrefix) then
				return "The metatable is locked"
			else
				return metatable
			end
		end
	else
		return nil --It won't be secure if the wrappers are tables since the user could simply use the identifier string for instances, so return nil.
	end
end