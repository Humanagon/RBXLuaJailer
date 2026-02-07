return function(module)
	return table.freeze({
		new = function(...)
			return module.CallConstructor(NumberRange.new, ...)
		end
	})
end