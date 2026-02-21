--Update: Now guards libraries with a userdata proxy to prevent altering of the tables. (Just like real LoadLibrary did!)
local getmetatable = getmetatable
local error = error
local newproxy = newproxy
local library = script:WaitForChild("LoadLibrary")
local children = library:GetChildren()
local libraries = {}
local cache = {}

for i = 1, #children do
	libraries[children[i].Name] = require(children[i])
end

library = nil
table.clear(children)
children = nil

return function(module)
	if not module.constants.AllowLoadLibrary then
		return function()
			error("Sorry, but LoadLibrary is not enabled in this RBXLuaJailer distro. Enable by setting AllowLoadLibrary in RBXLuaJailer.Settings.Constants to true.", 0)
		end
	else
		return function(str)
			local cached = cache[str]
			if cached then
				return cached
			end
			local exists = libraries[str]
			if not exists then
				return nil, "Unknown library " .. str
			end
			local t = exists(module)
			local proxy = newproxy(true)
			local m = getmetatable(proxy)
			m.__index = function(_, key)
				return t[key]
			end
			m.__newindex = function(_, key, value)
				error(key .. " cannot be assigned to", 0)
			end
			m.__metatable = "The metatable is locked"
			m.__tostring = function()
				return str
			end
			cache[str] = proxy
			return proxy
		end
	end
end
