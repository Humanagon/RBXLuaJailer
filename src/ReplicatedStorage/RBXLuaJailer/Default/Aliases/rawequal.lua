return function(module)
	if module.settings.WrapperDataType == "userdata" then
		return rawequal
	else
		return nil --It won't be secure if the wrappers are tables since the user could simply use the identifier string for instances, so return nil.
	end
end