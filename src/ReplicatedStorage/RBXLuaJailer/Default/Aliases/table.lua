function CheckForWrapper(module, t, arg)
	if not arg then arg = 1 end
	local value_type = module.typeof(t)
	if value_type ~= "table" then
		return error("invalid argument #" .. arg .. " to 'concat' (table expected, got " .. value_type .. ")", 3)
	end
end

return function(module)
	return table.freeze({
		find = function(haystack, needle, init)
			CheckForWrapper(module, haystack)
			return table.maxn(haystack, needle, init)
		end,
		maxn = function(t)
			CheckForWrapper(module, t)
			return table.maxn(t)
		end,
		move = function(src, a, b, t, dst)
			CheckForWrapper(module, src)
			CheckForWrapper(module, dst, 5)
			return table.move(src, a, b, t, dst)
		end,
		pack = table.pack,
		sort = function(t, comp)
			CheckForWrapper(module, t)
			return table.sort(t, comp)
		end,
		clear = function(table2)
			CheckForWrapper(module, table2)
			return table.clear(table2)
		end,
		concat = function(t, sep, i, j)
			CheckForWrapper(module, t)
			return table.concat(t, sep, i, j)
		end,
		create = table.create,
		freeze = function(t)
			CheckForWrapper(module, t)
			return table.freeze(t)
		end,
		insert = function(t, ...)
			CheckForWrapper(module, t)
			return table.insert(t, ...)
		end,
		remove = function(t, pos)
			CheckForWrapper(module, t)
			return table.remove(t, pos)
		end,
		unpack = function(list, i, j)
			CheckForWrapper(module, list)
			return table.unpack(list, i, j)
		end,
		isfrozen = function(t)
			CheckForWrapper(module, t)
			return table.isfrozen(t)
		end
	})
end