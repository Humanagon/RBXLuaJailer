return function(module)
	return table.freeze({
		new = function(...)
			return module.CallConstructor(Region3int16.new, ...)
		end
	})
end