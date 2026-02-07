return function(module)
	return table.freeze({
		new = function(...)
			return module.CallConstructor(PhysicalProperties.new, ...)
		end
	})
end