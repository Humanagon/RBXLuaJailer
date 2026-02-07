return function(module)
	return function(t)
		return ipairs(module.UnwrapIfWrapped(t))
	end
end