return function(module)
	return table.freeze({
		new = function(...)
			return module.CallConstructor(ColorSequenceKeypoint.new, ...)
		end
	})
end