return function(module)
	if module.settings.WrapperDataType == "userdata" then
		return function(val, val2)
			if module.CheckIfWrapped(val) then
				val = val.GetWrapperObject(script)
			end
			if module.CheckIfWrapped(val2) then
				val2 = val2.GetWrapperObject(script)
			end
			local value_type = module.typeof(val)
			local value_type_2 = module.typeof(val2)
			if value_type == "table" and (value_type_2 == "table" or value_type_2 == "nil") then
				return setmetatable(val, val2)
			elseif value_type ~= "table" then
				error("invalid argument #1 to 'setmetatable' (table expected, got " .. value_type .. ")")
			else
				error("invalid argument #2 to 'setmetatable' (nil or table expected, got " .. value_type_2 .. ")")
			end
		end
	else
		return nil --It won't be secure if the wrappers are tables since the user could simply use the identifier string for instances, so return nil.
	end
end