return function(module)
	return table.freeze({
		new = function(...)
			return module.CallConstructor(Region3.new, ...)
		end
	})
end