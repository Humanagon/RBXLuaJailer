local wrapper = {}

wrapper.inherits_from = "Object"

wrapper.custom_properties = {
	PlaceId = {
		read = function(t)
			local inst = t.GetWrapperObject(script)
			return inst.PlaceId
		end,
		type = "number"
	},
	GameId = {
		read = function(t)
			local inst = t.GetWrapperObject(script)
			return inst.GameId
		end,
		type = "number"
	}
}

function GetGameService(t, str)
	local inst = t.GetWrapperObject(script)
	local wtable = t.GetWrapperTable(script)
	if not wtable.module.constants.UseServiceWhitelist then
		return wtable.module.Wrap(inst:GetService(str))
	else
		for i = 1, #wtable.module.whitelist.services do
			if wtable.module.whitelist.services[i] == str then
				return wtable.module.Wrap(inst:GetService(str))
			end
		end
		error("Sorry, but usage of the \"" .. str .. "\" service is not allowed.", 0)
	end
end

wrapper.custom_methods = {
	GetService = GetGameService
}

wrapper.child_override = GetGameService

return wrapper