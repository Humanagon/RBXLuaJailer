return function(module)
	return function(value)
		if typeof(value) == "number" then
			return error("Sorry, but modules cannot be loaded by ID because it is insecure. Please load an in-game module instead.", 0)
		elseif typeof(value) == "string" then
			return error("Sorry, but loading modules by string has not been implemented yet.", 0)
		elseif typeof(value) == module.settings.WrapperDataType and getmetatable(value) == module.constants.InstanceIdentifier and value:IsA("ModuleScript") and typeof(value.GetWrapperObject) == "function" then
			local inst = value.GetWrapperObject(script)
			if not inst:HasTag(module.constants.LockedTag) and (not module.settings.WhitelistedTag or inst:HasTag(module.settings.WhitelistedTag)) then
				return require(inst)
			else
				return error("This module cannot be required.", 0)
			end
		else
			--print(typeof(value))
			return error("Attempted to call require with invalid argument(s).", 0)
		end
	end
end