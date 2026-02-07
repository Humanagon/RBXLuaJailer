return function(module)
	return table.freeze({
		new = function(...)
			return module.CallConstructor(ColorSequence.new, ...)
		end
	})
end