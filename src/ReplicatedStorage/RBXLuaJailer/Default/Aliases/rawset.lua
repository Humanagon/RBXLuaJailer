return function(module)
	if module.settings.WrapperDataType == "userdata" then
		return function(t, ...)
			if t == shared then
				error("Cannot use rawset on shared for security reasons.", 0)
			end
			return rawset(t, ...)
		end
	else
		return nil --It won't be secure if the wrappers are tables since the user could simply use the identifier string for instances, so return nil.
	end
end