return function(module)
	if type(shared) == "table" then
		if module.constants.CreatePseudoShared then
			if type(shared[module.constants.PseudoSharedKey]) ~= "table" then
				shared[module.constants.PseudoSharedKey] = {}
			end
			if type(shared[module.constants.PseudoSharedKey][module.context_name]) ~= "table" then
				shared[module.constants.PseudoSharedKey][module.context_name] = {}
			end
			return shared[module.constants.PseudoSharedKey][module.context_name]
		end
		return shared
	end
	return {}
end