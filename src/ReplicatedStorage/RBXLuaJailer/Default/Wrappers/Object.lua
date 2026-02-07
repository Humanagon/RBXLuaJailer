--This is the root instance of all ROBLOX instances. Anything modified here will be inherited by parts, players, scripts, services, etc.
local wrapper = {}

function CheckClassName(t)
	local wtable = t.GetWrapperTable(script)
	return wtable.values.class_name
end

wrapper.custom_properties = {
	ClassName = {
		read = CheckClassName,
		type = "string"
	},
	className = {
		read = CheckClassName,
		type = "string"
	}
}

wrapper.custom_methods = {
	GetPropertyChangedSignal = function(t, name)
		local ta = t.GetWrapperTable(script)
		if ta.dict[name] and (ta.dict[name].type == ta.module.enum.instance.members.properties or ta.dict[name].type == ta.module.enum.instance.members.read_only_properties) then
			local inst = t.GetWrapperObject(script)
			return ta.module.Wrap(inst:GetPropertyChangedSignal(name))
		end
		error(name .. " is not a valid property name.", 0)
	end
}

wrapper.custom_methods = {
	IsA = function(t, str)
		local wtable = t.GetWrapperTable(script)
		local value_type = wtable.module.typeof(str)
		if value_type ~= "string" then
			warn("argument #1 expects a string, but " .. value_type .. " was passed")
			return true
		end
		if wtable.values.class_name == str then
			return true
		else
			for i = 1, #wtable.values.inherits_from do
				if wtable.values.inherits_from[i] == str then
					return true
				end
			end
		end
		return false
	end
}

wrapper.events = {
	"Changed"
}

return wrapper