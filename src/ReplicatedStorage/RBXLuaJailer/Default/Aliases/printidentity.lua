return function(module)
	return function()
		print("Current identity is " .. module.context_level)
	end
end