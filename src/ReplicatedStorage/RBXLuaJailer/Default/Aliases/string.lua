return function(module)
	return table.freeze({
		byte = function(...)
			return module.CallConstructor(string.byte, ...)
		end,
		char = function(...)
			return module.CallConstructor(string.char, ...)
		end,
		find = function(...)
			return module.CallConstructor(string.find, ...)
		end,
		format = function(...)
			return module.CallConstructor(string.format, ...)
		end,
		gmatch = function(...)
			return module.CallConstructor(string.gmatch, ...)
		end,
		gsub = function(...)
			return module.CallConstructor(string.gsub, ...)
		end,
		len = function(...)
			return module.CallConstructor(string.len, ...)
		end,
		lower = function(...)
			return module.CallConstructor(string.lower, ...)
		end,
		match = function(...)
			return module.CallConstructor(string.match, ...)
		end,
		pack = function(...)
			return module.CallConstructor(string.pack, ...)
		end,
		packsize = function(...)
			return module.CallConstructor(string.packsize, ...)
		end,
		rep = function(...)
			return module.CallConstructor(string.rep, ...)
		end,
		reverse = function(...)
			return module.CallConstructor(string.reverse, ...)
		end,
		split = function(...)
			return module.CallConstructor(string.split, ...)
		end,
		sub = function(...)
			return module.CallConstructor(string.sub, ...)
		end,
		unpack = function(...)
			return module.CallConstructor(string.unpack, ...)
		end,
		upper = function(...)
			return module.CallConstructor(string.upper, ...)
		end
	})
end