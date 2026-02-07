return function(module)
	return table.freeze({
		new = function(...)
			return module.CallConstructor(NumberSequence.new, ...)
		end
	})
end