function new(module, str)
	local skeleton = module.LoadWrapperSkeleton(str)
	local class = nil
	if not skeleton then
		error("Unable to create an Instance of type \"" .. str .. "\"")
	elseif skeleton.real_class then
		class = str
		str = skeleton.real_class
	end
	local function CreateObjectLocal(ret)
		local wrappers = nil
		if not skeleton.is_default then
			wrappers = module.GetWrapperInstances()
		else
			wrappers = module.GetDefaultWrapperInstances()
		end
		if typeof(wrappers[class]) == "Instance" then
			local constructor = wrappers[class]:FindFirstChild("Constructor")
			if constructor then
				local con = require(constructor)
				if typeof(con) == "function" then
					local root = ret
					if con(module, root) then
						root:SetAttribute(module.constants.CustomClass, class)
						module.DisappearChildren(root)
						return module.Wrap(root)
					else
						root:Destroy()
					end
				end
			end
		end
		warn("Failed to create instance.")
	end
	if module.constants.AllowScriptSource and (str == "Script" or str == "LocalScript" or str == "ModuleScript") then
		local ret = module.scripts[str]:Clone()
		if str == "Script" or str == "LocalScript" then
			ret.Disabled = false
		end
		ret:SetAttribute(module.constants.ScriptSourceAttribute, "")
		if class then
			return CreateObjectLocal(ret)
		else
			return module.Wrap(ret)
		end
	else
		if class then
			return CreateObjectLocal(Instance.new(str))
		else
			return module.Wrap(Instance.new(str))
		end
	end
end

return function(module)
	return table.freeze({
		new = function(str)
			if module.constants.UseInstanceWhitelist then
				for i = 1, #module.whitelist.instances do
					if str == module.whitelist.instances[i] then
						return module.Wrap(new(module, str))
					end
				end
				error("Sorry, but instance of class \"" .. str .. "\" is not allowed for security reasons.")
			else
				return module.Wrap(new(module, str))
			end
		end,
		fromExisting = function(inst)
			if typeof(inst) ~= "Instance" and (typeof(inst) ~= "table" or getmetatable(inst) ~= module.constants.InstanceIdentifier) then
				error("Argument must be an instance.")
			end
			if module.constants.UseInstanceWhitelist then
				for i = 1, #module.whitelist.instances do
					if inst.ClassName == module.whitelist.instances[i] then
						if typeof(inst) ~= "Instance" then
							return inst.GetInstanceFromExistingWrapper(nil, Instance.fromExisting)
						else
							return module.Wrap(Instance.fromExisting(nil, inst))
						end
					end
				end
				error("Sorry, but instance of class \"" .. inst.ClassName .. "\" is not allowed for security reasons.")
			else
				if typeof(inst) ~= "Instance" then
					return inst.GetInstanceFromExistingWrapper(nil, Instance.fromExisting)
				else
					return module.Wrap(Instance.fromExisting(nil, inst))
				end
			end
		end
	})
end