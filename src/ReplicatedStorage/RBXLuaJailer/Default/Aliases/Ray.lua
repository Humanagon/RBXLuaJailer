return function(module)
	return table.freeze({
		new = function(...)
			return module.CallConstructor(Ray.new, ...)
		end
	})
end