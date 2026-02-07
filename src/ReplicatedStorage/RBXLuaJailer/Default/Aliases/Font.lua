return function(module)
	return table.freeze({
		fromEnum = function(...)
			return module.CallConstructor(Font.fromEnum, ...)
		end,
		fromId = function(...)
			return module.CallConstructor(Font.fromId, ...)
		end,
		fromName = function(...)
			return module.CallConstructor(Font.fromName, ...)
		end,
		new = function(...)
			return module.CallConstructor(Font.new, ...)
		end
	})
end