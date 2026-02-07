return function(module)
	if type(_G[module.constants.PseudoGKey]) ~= "table" then
		_G[module.constants.PseudoGKey] = {}
	end
	if type(_G[module.constants.PseudoGKey][module.context_name]) ~= "table" then
		_G[module.constants.PseudoGKey][module.context_name] = {}
	end
	return _G[module.constants.PseudoGKey][module.context_name]
end