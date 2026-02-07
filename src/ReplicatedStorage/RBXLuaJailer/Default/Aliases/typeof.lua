--For replacing the typeof function in scripts to fool them into thinking the wrappers are real instances.

return function(module)
	return function(value)
		return module.typeof(value)
	end
end