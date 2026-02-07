local library = script:WaitForChild("LoadLibrary")
local children = library:GetChildren()
local libraries = {}

for i = 1, #children do
	libraries[children[i].Name] = require(children[i])
end

return function(module)
	return function(str)
		if not module.constants.AllowLoadLibrary then
			return error("Sorry, but LoadLibrary is not enabled in this RBXLuaJailer distro. Enable by setting AllowLoadLibrary in RBXLuaJailer.Settings.Constants to true.", 0)
		end
		local exists = libraries[str]
		if not exists then
			return error("Sorry, but \"" .. str .. "\" is not a valid library.", 0)
		end
		return exists(module)
	end
end
