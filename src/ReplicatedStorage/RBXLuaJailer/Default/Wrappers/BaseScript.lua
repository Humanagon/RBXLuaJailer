local wrapper = {}

wrapper.inherits_from = "LuaSourceContainer"

wrapper.custom_properties = {
	Source = {
		read = function(t)
			local inst = t.GetWrapperObject(script)
			local wtable = t.GetWrapperTable(script)
			local source = inst:GetAttribute(wtable.module.constants.ScriptSourceAttribute)
			if typeof(source) == "string" then
				return source
			else
				return error("The source of this script cannot be read.", 0)
			end
		end,
		write = function(t, value)
			local inst = t.GetWrapperObject(script)
			local wtable = t.GetWrapperTable(script)
			local source = inst:GetAttribute(wtable.module.constants.ScriptSourceAttribute)
			if typeof(source) == "string" then
				inst:SetAttribute(wtable.module.constants.ScriptSourceAttribute, value)
				return true
			else
				return error("The source of this script cannot be written to.", 0)
			end
		end,
		type = "string"
	}
}


return wrapper