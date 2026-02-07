return function(module)
	return function(t)
		return pairs(module.UnwrapIfWrapped(t))
	end
end