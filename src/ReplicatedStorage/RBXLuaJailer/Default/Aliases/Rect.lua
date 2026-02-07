return function(module)
	return table.freeze({
		new = function(...)
			return module.CallConstructor(Rect.new, ...)
		end
	})
end