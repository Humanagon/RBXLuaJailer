function CheckForWrapper(module, t, arg)
	if not arg then arg = 1 end
	local value_type = module.typeof(t)
	if typeof(t) ~= "table" then
		return error("invalid argument #" .. arg .. " to 'concat' (table expected, got " .. value_type .. ")", 3)
	end
end

return function(module)
	return function(list, i, j)
		CheckForWrapper(module, list)
		return table.unpack(list, i, j)
	end
end