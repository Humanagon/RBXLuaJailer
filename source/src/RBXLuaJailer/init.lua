--RBXLuaJailer by Humanagon, 2025.
--[[
	BSD 3-Clause License

	Copyright (c) 2026, Humanagon

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:

	1. Redistributions of source code must retain the above copyright notice, this
	   list of conditions and the following disclaimer.

	2. Redistributions in binary form must reproduce the above copyright notice,
	   this list of conditions and the following disclaimer in the documentation
	   and/or other materials provided with the distribution.

	3. Neither the name of the copyright holder nor the names of its
	   contributors may be used to endorse or promote products derived from
	   this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

	Thank you for using RBXLuaJailer!
	
	This module is designed to make it easy for you to create a safe environment for user submitted code. It it works by replacing every
	instance variable with a metatable, which then acts as a whitelist for properties, methods, and events to prevent usage of dangerous
	or otherwise unwanted services/APIs.
	
	In addition to making scripts safe, it also allows you to customize the roblox class hierarchy. This means you can virtually create your own engine features!
--]]

local main_module = {}
local main = script
local constants = require(main:WaitForChild("Constants"))
local enum = require(main:WaitForChild("Enum"))
local runservice = game:GetService("RunService")
local players = game:GetService("Players")
local default_module_settings = main:WaitForChild("Default")
local default_settings = require(default_module_settings:WaitForChild("Settings"))
local default_whitelists = default_module_settings:WaitForChild("Whitelists")
local default_wrappers_folder = default_module_settings:WaitForChild("Wrappers")
local default_aliasesc = default_module_settings:WaitForChild("Aliases"):GetChildren()
local default_aliases = {}
local default_wrappersc = default_wrappers_folder:GetChildren()
local default_wrappers = {}
local default_env = default_module_settings:WaitForChild("Environment")
local default_plugins = require(default_module_settings:WaitForChild("Plugins"))

table.freeze(default_settings)
table.freeze(default_plugins)

local scripts = {}

main_module.constants = table.freeze(constants)
main_module.enum = table.freeze(enum)
main_module.scripts = table.freeze(scripts)

for i = 1, #default_wrappersc do
	default_wrappers[default_wrappersc[i].Name] = require(default_wrappersc[i])
end

for i = 1, #default_aliasesc do
	default_aliases[default_aliasesc[i].Name] = require(default_aliasesc[i])
end

local default_wrapper_instances = table.clone(default_wrappers)

function main_module.Lock(inst, recursive)
	if typeof(inst) == "Instance" then
		inst:AddTag(constants.LockedTag)
		if recursive then
			for i, desc in ipairs(inst:GetDescendants()) do
				desc:AddTag(constants.LockedTag)
			end
		end
		return true
	end
	return false
end

function main_module.Unlock(inst, recursive)
	if typeof(inst) == "Instance" then
		inst:RemoveTag(constants.LockedTag)
		if recursive then
			for i, desc in ipairs(inst:GetDescendants()) do
				desc:RemoveTag(constants.LockedTag)
			end
		end
		return true
	end
	return false
end

function main_module.Hide(inst, recursive)
	if typeof(inst) == "Instance" then
		inst:AddTag(constants.HiddenTag)
		if recursive then
			for i, desc in ipairs(inst:GetDescendants()) do
				desc:AddTag(constants.HiddenTag)
			end
		end
		return true
	end
	return false
end

function main_module.Unhide(inst, recursive)
	if typeof(inst) == "Instance" then
		inst:RemoveTag(constants.HiddenTag)
		if recursive then
			for i, desc in ipairs(inst:GetDescendants()) do
				desc:RemoveTag(constants.HiddenTag)
			end
		end
		return true
	end
	return false
end

function main_module.Reveal(inst, recursive)
	return main_module.Hide(inst, recursive)
end

function main_module.SetCore(inst, recursive)
	if typeof(inst) == "Instance" then
		inst:AddTag(constants.CoreTag)
		if recursive then
			for i, desc in ipairs(inst:GetDescendants()) do
				desc:AddTag(constants.CoreTag)
			end
		end
		return true
	end
	return false
end

function main_module.UnsetCore(inst, recursive)
	if typeof(inst) == "Instance" then
		inst:RemoveTag(constants.CoreTag)
		if recursive then
			for i, desc in ipairs(inst:GetDescendants()) do
				desc:RemoveTag(constants.CoreTag)
			end
		end
		return true
	end
	return false
end

function main_module.IsLocked(inst)
	if typeof(inst) == "Instance" then
		return inst:HasTag(constants.LockedTag)
	end
	return false
end

function main_module.IsHidden(inst)
	if typeof(inst) == "Instance" then
		return inst:HasTag(constants.HiddenTag)
	end
	return false
end

function main_module.IsCore(inst)
	if typeof(inst) == "Instance" then
		return inst:HasTag(constants.CoreTag)
	end
	return false
end

function main_module.IsCoreScriptDisabled(inst)
	if typeof(inst) == "Instance" then
		return inst:HasTag(constants.CoreScriptDisabledTag)
	end
	return false
end
function main_module.Disappear(handle)
	main_module.Hide(handle, true)
	main_module.SetCore(handle, true)
	return true
end

function main_module.DisappearChildren(handle)
	local handlec = handle:GetChildren()
	for i = 1, #handlec do
		main_module.Disappear(handlec[i])
	end
	return true
end

function main_module.PrepareCoreScripts(wrap, request)
	local scripts = wrap:FindFirstChild("Scripts")
	if not scripts then return nil end
	local ret = {}
	local children = scripts:GetChildren()
	for i = 1, #children do
		ret[children[i].Name] = children[i]:Clone()
		if not ret[children[i].Name]:HasTag(constants.CoreScriptDisabledTag) then
			ret[children[i].Name].Disabled = false
		else
			ret[children[i].Name]:RemoveTag(constants.CoreScriptDisabledTag)
		end
	end
	return ret
end

function MetatableDeletedMessageCallback()
	error("Sorry, Instance has been destroyed.")
end

function main_module.GetModule(name)
	if type(name) == "string" and shared[constants.StaticStorageKey][name] and shared[constants.StaticStorageKey][name].Module then
		return shared[constants.StaticStorageKey][name].Module
	end
end

function AssignToEvent(_, key, value)
	error("Cannot assign to an event", 0)
end

function main_module.CreateModule(config, name, level, permissions)
	if type(name) ~= "string" then
		name = "default"
	end
	if type(level) ~= "number" then
		level = 0
	end
	if type(permissions) ~= "table" then
		permissions = table.freeze({})
	else
		local success = pcall(function()
			table.freeze(permissions)
		end)
		if not success then
			permissions = table.freeze({})
		end
	end

	local user_id = tonumber(string.split(name, ":")[2])
	if user_id and math.floor(user_id) ~= user_id then
		user_id = nil
	end
	local player = nil
	if user_id then
		player = players:GetPlayerByUserId(user_id)
	end

	if constants.UseSharedGlobal and shared[constants.StaticStorageKey] and shared[constants.StaticStorageKey][name] and shared[constants.StaticStorageKey][name].Module then
		return shared[constants.StaticStorageKey][name].Module
	end

	--print("new module")

	local module = {}
	local module_settings = config or default_module_settings
	local wrappers_folder = module_settings:FindFirstChild("Wrappers") or default_wrappers_folder
	local whitelists = module_settings:FindFirstChild("Whitelists") or default_whitelists
	local aliasesc = default_aliasesc
	local aliases = {}
	local wrappersc = wrappers_folder:GetChildren()
	local wrappers = {}
	local plugins = module_settings:FindFirstChild("Plugins") or default_plugins
	local env = require(module_settings:FindFirstChild("Environment") or default_env)
	local local_default_aliases = {}
	local module_settings_settings = module_settings:FindFirstChild("Settings")
	local data_type_wrappers = {}
	local dth = module_settings:FindFirstChild("DataTypes")
	if dth then
		for i, v in ipairs(dth:GetChildren()) do
			if v:IsA("ModuleScript") then
				data_type_wrappers[v.Name] = require(v)
			end
		end
	end

	module.context_name = name
	module.context_level = level
	module.permissions = {}
	module.player = player

	for i, v in ipairs(permissions) do
		module.permissions[v] = true
	end

	table.freeze(module.permissions)

	if module_settings_settings then
		module_settings_settings = require(module_settings_settings)
		for k, v in pairs(default_settings) do
			if type(module_settings_settings[k]) == "nil" then
				module_settings_settings[k] = default_settings[k]
			end
		end
		if module_settings_settings ~= default_settings then
			pcall(function()
				table.freeze(module_settings_settings)
			end)
		end
	else
		module_settings_settings = default_settings
	end

	if module_settings_settings.WrapperDataType ~= "table" and module_settings_settings.WrapperDataType ~= "userdata" then
		error("Invalid settings: WrapperDataType can only be either \"table\" or \"userdata\"", 0)
	end

	module.settings = module_settings_settings

	--The metatables with the "kv" mode mean that both the keys nor the values will prevent the garabage collector from cleaning up when necessary.
	local storage = {
		Module = module,
		Schemas = {},
		Instances = setmetatable({}, {__mode = "kv"}),
		Events = {},
		Functions = setmetatable({}, {__mode = "kv"}),
		ReverseFunctions = setmetatable({}, {__mode = "kv"}),
		EventWrappers = setmetatable({}, {__mode = "kv"})
	}

	if constants.UseSharedGlobal then
		if type(shared[constants.StaticStorageKey]) ~= "table" then
			shared[constants.StaticStorageKey] = {}
		end
		shared[constants.StaticStorageKey][name] = storage
	end

	module.storage = {}

	if module_settings:FindFirstChild("Aliases") then
		aliasesc = module_settings.Aliases:GetChildren()
	else
		aliases = local_default_aliases
	end

	module.Lock = main_module.Lock
	module.Unlock = main_module.Unlock
	module.Hide = main_module.Hide
	module.Unhide = main_module.Unhide
	module.Reveal = main_module.Reveal
	module.SetCore = main_module.SetCore
	module.UnsetCore = main_module.UnsetCore
	module.IsLocked = main_module.IsLocked
	module.IsHidden = main_module.IsHidden
	module.IsCore = main_module.IsCore
	module.IsCoreScriptDisabled = main_module.IsCoreScriptDisabled
	module.Disappear = main_module.Disappear
	module.DisappearChildren = main_module.DisappearChildren
	module.PrepareCoreScripts = main_module.PrepareCoreScripts

	if typeof(plugins) == "Instance" then
		plugins = require(plugins)
		for k, v in pairs(default_plugins) do
			if type(plugins[k]) == "nil" then
				plugins[k] = v
			end
		end
	end

	for i = 1, #wrappersc do
		wrappers[wrappersc[i].Name] = require(wrappersc[i])
		if wrappers[wrappersc[i].Name] == "default" then
			wrappers[wrappersc[i].Name] = default_wrappers[wrappersc[i].Name]
		end
	end

	local wrapper_instances = table.clone(wrappers)

	table.freeze(wrapper_instances)

	module.constants = constants
	module.enum = enum
	module.plugins = plugins
	module.scripts = scripts

	module.whitelist = {
		services = require(whitelists:FindFirstChild("AllowedServices") or default_whitelists:WaitForChild("AllowedServices")),
		instances = require(whitelists:FindFirstChild("AllowedInstances") or default_whitelists:WaitForChild("AllowedInstances"))
	}

	local interpreter = nil
	local compiler = nil

	if module.plugins then
		if typeof(module.plugins.LuaInterpreter) == "Instance" and module.plugins.LuaInterpreter:IsA("ModuleScript") then
			interpreter = require(module.plugins.LuaInterpreter)
		end
		if typeof(module.plugins.LuaCompiler) == "Instance" and module.plugins.LuaCompiler:IsA("ModuleScript") then
			compiler = require(module.plugins.LuaCompiler)
		end
	end

	local function CreateWrapperMethodTunnel(method, t, ...)
		local inst = t.GetWrapperObject(script)
		local args = table.pack(inst, ...)
		for i = 2, #args do
			args[i] = module.Unwrap(args[i], true)
		end
		args = table.pack(inst[method](table.unpack(args)))
		for i = 1, #args do
			args[i] = module.Wrap(args[i])
		end
		return table.unpack(args)
	end

	local GetProperty = nil
	if plugins.Handler and plugins.Handler.GetProperty then
		GetProperty = function(inst, key)
			return plugins.Handler.GetProperty(inst, key, player)
		end
	else
		GetProperty = function(inst, key)
			return inst[key]
		end
	end

	local GetMethod = nil
	if plugins.Handler and plugins.Handler.GetMethod then
		GetMethod = function(this, inst, key, wrapper)
			return plugins.Handler.GetMethod(this, inst, key, player)
		end
	else
		GetMethod = function(this, inst, key, wrapper)
			return wrapper.dict[key].reference
		end
	end

	local function IndexWrapper(this, wrapper, inst, key)
		--Wrapper API functions
		if key == "GetWrapperObject" then
			--Always use this to get the real instance of a wrapper.
			--The reason you must pass in an instance to this function is to ensure that no wrapped script can access it.
			--This security works 100% of the time since wrapped scripts will never have access to a real instance. (Unless the user accidentally returns one in a custom method, property, etc. PLEASE AVOID DOING THIS!)
			return function(verification)
				if typeof(verification) == "Instance" and verification:IsA("LuaSourceContainer") then
					return inst
				end
			end
		elseif key == "GetWrapperTable" then
			--Used to get the table of defined properties, methods, and events.
			--The module can also be accessed by using this, which can be used to check context levels, use plugins, etc.
			return function(verification)
				if typeof(verification) == "Instance" and verification:IsA("LuaSourceContainer") then
					return wrapper
				end
			end
		end

		--Instance handling
		local required = inst:GetAttribute(module.settings.RequiredPermissionAttribute)
		if type(required) == "string" and not module.permissions[required] then
			error("Error: Permission " .. required .. " is required to index this Instance", 0)
		elseif wrapper.dict[key] then
			if wrapper.dict[key].type == enum.instance.members.properties or wrapper.dict[key].type == enum.instance.members.read_only_properties or wrapper.dict[key].type == enum.instance.members.events then
				return module.Wrap(GetProperty(inst, key))
			elseif wrapper.dict[key].type == enum.instance.members.write_only_properties then
				error("Unable to read property " .. key .. ". Property is write only", 0)
			elseif wrapper.dict[key].type == enum.instance.members.methods then
				return GetMethod(this, inst, key, wrapper)
			elseif wrapper.dict[key].type == enum.instance.members.custom_methods then
				return wrapper.dict[key].reference
			elseif wrapper.dict[key].type == enum.instance.members.custom_properties then
				if wrapper.dict[key].reference.read then
					if module.settings.AutoWrapCustomMembers then
						return module.Wrap(wrapper.dict[key].reference.read(this))
					else
						return wrapper.dict[key].reference.read(this)
					end
				elseif wrapper.dict[key].reference.write then
					error("Unable to read property " .. key .. ". Property is write only", 0)
				else
					error("Unable to read property " .. key, 0)
				end
			elseif wrapper.dict[key].type == enum.instance.members.attribute_properties then
				local property = inst:GetAttribute(module.settings.AttributePropertyPrefix .. key)
				if typeof(property) == "nil" then
					if wrapper.dict[key].reference.strict then
						error("The " .. key .. " property of " .. wrapper.values.class_name .. " \"" .. inst.Name .. "\" is locked", 0)
					elseif wrapper.dict[key].reference.default then
						property = wrapper.dict[key].reference.default
					elseif constants.default_attribute_values[wrapper.dict[key].reference.type] then
						property = constants.default_attribute_values[wrapper.dict[key].reference.type]
					end
				end
				return property
			elseif wrapper.dict[key].type == enum.instance.members.core_properties or wrapper.dict[key].type == enum.instance.members.read_only_core_properties or wrapper.dict[key].type == enum.instance.members.core_events then
				--Deprecated.
				local arr = string.split(wrapper.dict[key].reference, ".")
				local tinst = inst
				for i = 1, #arr - 1 do
					local chs = tinst:GetChildren()
					local found = nil
					for j = 1, #chs do
						if chs[j]:HasTag(constants.CoreTag) and arr[i] == chs[j].Name then
							found = chs[j]
							break
						end
					end
					if found then
						tinst = tinst[arr[i]]
					else
						error("Internal error. Unable to locate " .. wrapper.dict[key].reference, 0)
					end
				end
				if typeof(tinst[arr[#arr]]) == "Instance" or typeof(tinst[arr[#arr]]) == "RBXScriptSignal" then
					return module.Wrap(tinst[arr[#arr]])
				else
					return tinst[arr[#arr]]
				end
			elseif wrapper.dict[key].type == enum.instance.members.custom_events then
				if type(storage.Events[inst]) == "table" and storage.Events[inst][key] then
					return storage.Events[inst][key]
				else
					if type(storage.Events[inst]) ~= "table" then
						storage.Events[inst] = setmetatable({}, {__mode = "kv"})
					end
					if module.settings.AutoWrapCustomMembers then
						storage.Events[inst][key] = module.Wrap(wrapper.dict[key].reference(this))
					else
						storage.Events[inst][key] = wrapper.dict[key].reference(this)
					end
					return storage.Events[inst][key]
				end
			end
		elseif not wrapper.values.disable_child_access then
			local ret = nil
			if wrapper.values.child_override then
				ret = wrapper.values.child_override(this, key)
			else
				ret = module.FindFirstChildAndIgnoreLockedTag(inst, key)
			end
			if ret then return module.Wrap(ret) end
		end

		error(key .. " is not a valid member of " .. wrapper.values.class_name .. " \"" .. inst.Name .. "\"", 0)
	end

	local SetProperty = nil

	if plugins.Handler and plugins.Handler.SetProperty then
		SetProperty = function(inst, key, value)
			plugins.Handler.SetProperty(inst, key, value, player)
		end
	else
		SetProperty = function(inst, key, value)
			inst[key] = value
		end
	end

	local SetCallback = nil
	if plugins.Handler and plugins.Handler.SetCallback then
		SetCallback = function(inst, key, value)
			plugins.Handler.SetCallback(inst, key, value, player)
		end
	else
		SetCallback = function(inst, key, value)
			inst[key] = value
		end
	end

	local function NewIndexWrapper(this, wrapper, inst, key, value)
		if wrapper.dict[key] then
			local value_type = module.typeof(value)
			local required = inst:GetAttribute(module.settings.RequiredPermissionAttribute)
			if type(required) == "string" and not module.permissions[required] then
				error("Error: Permission " .. required .. " is required to index this Instance", 0)
			elseif wrapper.dict[key].type == enum.instance.members.properties or wrapper.dict[key].type == enum.instance.members.write_only_properties then
				local v = type(GetProperty(inst, key)) .. ":" .. typeof(GetProperty(inst, key))
				if data_type_wrappers[v] and data_type_wrappers[v].verify then
					data_type_wrappers[v].verify(GetProperty(inst, key), module.Unwrap(value))
				end
				if typeof(value) == module.settings.WrapperDataType and getmetatable(value) == constants.InstanceIdentifier then
					SetProperty(inst, key, value.GetWrapperObject(script))
				elseif typeof(value) == module.settings.WrapperDataType and module.GetCustomType(value) then
					SetProperty(inst, key, value.GetWrapperObject(script))
				else
					SetProperty(inst, key, value)
				end
			elseif wrapper.dict[key].type == enum.instance.members.custom_properties then
				if wrapper.dict[key].reference.write and typeof(wrapper.dict[key].reference.write) == "function" then
					if wrapper.dict[key].reference.type and wrapper.dict[key].reference.type ~= "any" and value_type ~= wrapper.dict[key].reference.type and not (wrapper.dict[key].reference.type == "Instance" and value_type == "nil") then
						error("Unable to assign property " .. key .. ". " .. wrapper.dict[key].reference.type .. " expected, got " .. value_type, 0)
					end
					return wrapper.dict[key].reference.write(this, value)
				elseif wrapper.dict[key].reference.read and typeof(wrapper.dict[key].reference.read) == "function" then
					error("Unable to assign property " .. key .. ". Property is read only", 0)
				else
					error("Unable to assign property " .. key, 0)
				end
			elseif wrapper.dict[key].type == enum.instance.members.callbacks then
				if typeof(value) == "function" then
					SetCallback(inst, key, function(...)
						local args = table.pack(...)
						value(table.unpack(module.Wrap(args)))
					end)
					return
				else
					error("Unable to assign callback " .. key .. ". Function expected, got " .. value_type, 0)
				end
			elseif wrapper.dict[key].type == enum.instance.members.attribute_properties then
				if typeof(inst:GetAttribute(module.settings.AttributePropertyPrefix .. key)) == "nil" and wrapper.dict[key].reference.strict then
					error("The " .. key .. " property of " .. wrapper.values.class_name .. " \"" .. inst.Name .. "\" is locked", 0)
				elseif value_type == wrapper.dict[key].reference.type or (wrapper.dict[key].reference.type == "any" and enum.attribute.types[value_type]) then
					inst:SetAttribute(module.settings.AttributePropertyPrefix .. key, value)
				else
					error("Unable to assign property " .. key .. ". " .. wrapper.dict[key].reference.type .. " expected, got " .. value_type, 0)
				end
			elseif wrapper.dict[key].type == enum.instance.members.core_properties or wrapper.dict[key].type == enum.instance.members.write_only_properties then
				--Deprecated feature.
				local arr = string.split(wrapper.dict[key].reference, ".")
				local tinst = inst
				for i = 1, #arr - 1 do
					local chs = tinst:GetChildren()
					local found = nil
					for j = 1, #chs do
						if chs[j]:HasTag(constants.CoreTag) and arr[i] == chs[j].Name then
							found = chs[j]
							break
						end
					end
					if found then
						tinst = tinst[arr[i]]
					else
						error("Internal error. Unable to locate " .. wrapper.dict[key].reference, 0)
					end
				end
				if typeof(value) == module.settings.WrapperDataType and getmetatable(value) == constants.InstanceIdentifier then
					tinst[arr[#arr]] = value.GetWrapperObject(script)
				else
					tinst[arr[#arr]] = value
				end
			end
			return true
		else
			error(key .. " is not a valid member of " .. (module.settings.CustomClassAttribute and inst:GetAttribute(module.settings.CustomClassAttribute) or inst.ClassName) .. " \"" .. inst.Name .. "\"", 0)
		end
	end

	function module.Execute(str, passed_env, is_compiled)
		--This will only work if LoadStringEnabled is true in the ServerScriptService, but is faster than using a lua compiler.
		local loadstringenabled = false
		if module.settings.UseLoadStringIfAvailable then
			loadstringenabled = pcall(function()
				loadstring("local a = 1")()
			end)
		end
		if loadstringenabled and not is_compiled then
			local executable = loadstring(str)
			if executable then
				local this_env = passed_env or module.MakeSecureEnv()
				executable = setfenv(executable, this_env)
				if executable then
					return executable()
				else
					error("Failed to set the env. Aborting.", 0)
				end
			else
				error("Loadstring syntax error.", 0)
			end
		elseif interpreter then
			local this_env = passed_env or module.MakeSecureEnv()
			local executable = interpreter(str, this_env, is_compiled)
			if executable then
				return executable()
			else
				error("Failed to compile. Aborting", 0)
			end
		else
			error("loadstring is disabled and no Lua interpreter module was provided. Aborting.", 0)
		end
	end

	function module.CreateExecutable(str, passed_env, is_compiled)
		--This will only work if LoadStringEnabled is true in the ServerScriptService, but is faster than using a lua compiler.
		local loadstringenabled = false
		if module.settings.UseLoadStringIfAvailable then
			loadstringenabled = pcall(function()
				loadstring("local a = 1")()
			end)
		end
		if loadstringenabled and not is_compiled then
			local executable = loadstring(str)
			if executable then
				local this_env = passed_env or module.MakeSecureEnv()
				executable = setfenv(executable, this_env)
				if executable then
					return executable
				else
					error("Failed to set the env. Aborting.", 0)
				end
			else
				error("Loadstring syntax error.", 0)
			end
		elseif interpreter then
			local this_env = passed_env or module.MakeSecureEnv()
			local executable = interpreter(str, this_env, is_compiled)
			if executable then
				return executable
			else
				error("Failed to compile. Aborting", 0)
			end
		else
			error("loadstring is disabled and no Lua interpreter module was provided. Aborting.", 0)
		end
	end

	function module.Compile(source, name)
		if compiler then
			return compiler(source, name)
		else
			return nil
		end
	end

	function module.WrapEnv(custom_env)
		local env = custom_env or table.clone(env)
		for key, value in pairs(env) do
			env[key] = module.Wrap(env[key])
		end
		return env
	end

	function module.MakeSecureEnv(sc) --The sc argument is for passing the current script so it can be wrapped. For those who wish to simulate script sources themselves.
		local this_env = getfenv(0)
		local ret = {}
		local keys_to_secure = {}
		for key, value in pairs(env) do
			if value:lower() == "raw" then
				ret[key] = this_env[key]
			elseif value:lower() == "alias" then
				ret[key] = aliases[key]
			elseif value:lower() == "default" then
				ret[key] = local_default_aliases[key] --Finish this later
			elseif value:lower() == "wrap" then
				ret[key] = module.Wrap(this_env[key])
			elseif string.sub(value, 1, 10):lower() == "use_alias:" then
				ret[key] = aliases[string.sub(value, 11, (#value - 10) + 11)]
			elseif string.sub(value, 1, 12):lower() == "use_default:" then
				ret[key] = local_default_aliases[string.sub(value, 13, (#value - 12) + 13)]
			elseif value:lower() == "secure_function" then
				ret[key] = aliases[key]
				table.insert(keys_to_secure, key)
			else
				error("Unknown env enum type \"" .. tostring(value) .. "\"", 0)
			end
		end
		if sc then ret.script = module.Wrap(sc) end
		--ret = table.clone(ret)
		for i = 1, #keys_to_secure do
			local callback = ret[keys_to_secure[i]]
			ret[keys_to_secure[i]] = function(...)
				return callback(ret, ...)
			end 
		end
		return ret
	end

	function module.CreateWrapperFunctionTunnel(callback, ...)
		local args = table.pack(...)
		for i = 1, #args do
			args[i] = module.Unwrap(args[i])
		end
		args = table.pack(callback(table.unpack(args)))
		for i = 1, #args do
			args[i] = module.Wrap(args[i])
		end
		return table.unpack(args)
	end

	function module.CreateReverseWrapperFunctionTunnel(callback, ...)
		local args = table.pack(...)
		for i = 1, #args do
			args[i] = module.Wrap(args[i])
		end
		args = table.pack(callback(table.unpack(args)))
		for i = 1, #args do
			args[i] = module.Unwrap(args[i])
		end
		return table.unpack(args)
	end

	local function HandleWrapperEvent(callback)
		return function(...)
			local args = table.pack(...)
			for i = 1, #args do
				args[i] = module.Wrap(args[i])
			end
			args = table.pack(callback(table.unpack(args)))
			for i = 1, #args do
				args[i] = module.Unwrap(args[i])
			end
			return table.unpack(args)
		end
	end

	local function IndexEvent(inst, key)
		if key == "GetWrapperObject" then
			--Use this to get the real event of a wrapper.
			return function(verification)
				if typeof(verification) == "Instance" and verification:IsA("LuaSourceContainer") then
					return inst
				end
			end
		elseif key == "connect" or key == "Connect" then
			return function(this, func)
				if typeof(func) ~= "function" then
					error("Attempt to connect failed: Passed value is not a function", 0)
				end
				return inst:Connect(HandleWrapperEvent(func))
			end
		elseif key == "ConnectParallel" then
			return function(this, func)
				if typeof(func) ~= "function" then
					error("Attempt to connect failed: Passed value is not a function", 0)
				end
				return inst:ConnectParallel(HandleWrapperEvent(func))
			end
		elseif key == "wait" or key == "Wait" then
			return function(this, timeout)
				return inst:Wait(timeout)
			end
		elseif key == "Once" then
			return function(this, func)
				if typeof(func) ~= "function" then
					error("Attempt to connect failed: Passed value is not a function", 0)
				end
				return inst:Once(HandleWrapperEvent(func))
			end
		else
			error(key .. " is not a valid member of RBXScriptSignal", 0)
		end
	end

	local function CreateInstanceWrapper(inst)
		if constants.RootClass and typeof(wrappers[constants.RootClass]) == "Instance" then
			wrappers[constants.RootClass] = require(wrappers[constants.RootClass])
			if wrappers[constants.RootClass] == "default" and default_wrappers[constants.RootClass] then
				wrappers[constants.RootClass] = default_wrappers[constants.RootClass]
				if typeof(wrappers[constants.RootClass]) == "Instance" then
					wrappers[constants.RootClass] = require(wrappers[constants.RootClass])
				end
			elseif wrappers[constants.RootClass] == "default" then
				warn("Attempted to load a non-existant default wrapper. (" .. constants.RootClass .. ")")
			end
		end
		local wrapper = constants.RootClass and wrappers[constants.RootClass]
		local cn = inst:GetAttribute(module.settings.CustomClassAttribute)
		if typeof(cn) ~= "string" then
			cn = inst.ClassName
		end

		local class_name = constants.RootClass

		if wrappers[cn] then
			if typeof(wrappers[cn]) == "Instance" then
				wrappers[cn] = require(wrappers[cn])
				if wrappers[cn] == "default" and default_wrappers[cn] then
					wrappers[cn] = default_wrappers[cn]
					if typeof(wrappers[cn]) == "Instance" then
						wrappers[cn] = require(wrappers[cn])
					end
				elseif wrappers[cn] == "default" then
					warn("Attempted to load a non-existant default wrapper. (" .. cn .. ")")
				end
			end
			wrapper = wrappers[cn]
			class_name = cn
		end

		local temp_wrapper = wrapper
		wrapper = nil

		if storage.Schemas[class_name] then
			wrapper = storage.Schemas[class_name]
			class_name = nil
		else
			if not temp_wrapper then error("Fatal error: Failed to wrap instance.", 0) end
			wrapper = {
				dict = {},
				values = {
					inherits_from = {},
					child_override = temp_wrapper.child_override,
					disable_child_access = temp_wrapper.disable_child_access,
					class_name = class_name
				},
				module = module
			}
			local function InheritPropertiesFromWrapper(properties_string)
				if temp_wrapper[properties_string] then
					for i = 1, #temp_wrapper[properties_string] do
						if not wrapper.dict[temp_wrapper[properties_string][i]] then
							wrapper.dict[temp_wrapper[properties_string][i]] = {
								type = enum.instance.members[properties_string]
							}
						end
					end
				end
			end
			local function InheritCallbacksFromWrapper(properties_string)
				if temp_wrapper[properties_string] then
					for key, value in pairs(temp_wrapper[properties_string]) do
						if not wrapper.dict[key] then
							wrapper.dict[key] = {
								type = enum.instance.members[properties_string],
								reference = temp_wrapper[properties_string][key]
							}
						end
					end
				end
			end
			local function InheritCMethodsFromWrapper(properties_string)
				if temp_wrapper[properties_string] then
					for key, value in pairs(temp_wrapper[properties_string]) do
						if not wrapper.dict[key] then
							local temp_wrapper = temp_wrapper
							local class_name = class_name
							local invalid_method_self = "Expected ':' not '.' calling member function " .. key
							wrapper.dict[key] = {
								type = enum.instance.members[properties_string],
								reference = function(...)
									local args = table.pack(...)
									if #args == 0 or not module.CheckIfWrapped(args[1]) or module.typeof(args[1]) ~= "Instance" then
										error(invalid_method_self, 0)
									end
									local lcn = args[1].ClassName
									if not storage.Schemas[lcn] or (lcn ~= class_name and not table.find(storage.Schemas[lcn].values.inherits_from, class_name)) then
										error(invalid_method_self, 0)
									end
									if module.settings.AutoWrapCustomMembers then
										return module.Wrap(temp_wrapper[properties_string][key](...))
									else
										return temp_wrapper[properties_string][key](...)
									end
								end
							}
						end
					end
				end
			end
			local function InheritMethodsFromWrapper(properties_string)
				if temp_wrapper[properties_string] then
					for key, value in ipairs(temp_wrapper[properties_string]) do
						if not wrapper.dict[value] then
							local temp_wrapper = temp_wrapper
							local class_name = class_name
							local invalid_method_self = "Expected ':' not '.' calling member function " .. key
							local method = inst[value]
							wrapper.dict[value] = {
								type = enum.instance.members[properties_string],
								reference = function(...)
									local args = table.pack(...)
									if #args == 0 or not module.CheckIfWrapped(args[1]) or module.typeof(args[1]) ~= "Instance" then
										error(invalid_method_self, 0)
									end
									local lcn = args[1].ClassName
									if not storage.Schemas[lcn] or (lcn ~= class_name and not table.find(storage.Schemas[lcn].values.inherits_from, class_name)) then
										error(invalid_method_self, 0)
									end
									return module.CreateWrapperFunctionTunnel(method, ...)
								end
							}
						end
					end
				end
			end
			local temp_name = temp_wrapper.class_name
			while true do

				if not wrapper.values.child_override then
					wrapper.values.child_override = temp_wrapper.child_override
				end

				--BEHOLD...
				--====THE GIANT RECTANGLE OF CODE====--

				InheritPropertiesFromWrapper("properties")
				InheritPropertiesFromWrapper("read_only_properties")
				InheritPropertiesFromWrapper("write_only_properties")
				InheritPropertiesFromWrapper("events")
				InheritMethodsFromWrapper("methods")
				InheritPropertiesFromWrapper("removed_members")
				InheritCMethodsFromWrapper("custom_methods")
				InheritCallbacksFromWrapper("custom_properties")
				InheritCallbacksFromWrapper("attribute_properties")
				InheritCallbacksFromWrapper("core_properties")
				InheritCallbacksFromWrapper("read_only_core_properties")
				InheritCallbacksFromWrapper("write_only_core_properties")
				InheritCallbacksFromWrapper("core_methods")
				InheritCallbacksFromWrapper("core_events")
				InheritCallbacksFromWrapper("custom_events")

				if type(temp_wrapper.inherits_from) == "string" and wrappers[temp_wrapper.inherits_from] then
					if typeof(wrappers[temp_wrapper.inherits_from]) == "Instance" then
						wrappers[temp_wrapper.inherits_from] = require(wrappers[temp_wrapper.inherits_from])
						if wrappers[temp_wrapper.inherits_from] == "default" and default_wrappers[temp_wrapper.inherits_from] then
							wrappers[temp_wrapper.inherits_from] = default_wrappers[temp_wrapper.inherits_from]
							if typeof(wrappers[temp_wrapper.inherits_from]) == "Instance" then
								wrappers[temp_wrapper.inherits_from] = require(wrappers[temp_wrapper.inherits_from])
							end
						elseif wrappers[temp_wrapper.inherits_from] == "default" then
							warn("Attempted to load a non-existant default wrapper. (" .. temp_wrapper.inherits_from .. ")")
						end
					end
					temp_name = temp_wrapper.inherits_from
					temp_wrapper = wrappers[temp_wrapper.inherits_from]
					class_name = temp_name
					table.insert(wrapper.values.inherits_from, temp_name)
				elseif type(temp_wrapper.inherits_from) == "string" then
					warn("Attempted to inherit from a non-existant wrapper. (" .. temp_wrapper.inherits_from .. ")")
				else
					break
				end
			end
			for key, value in pairs(wrapper.dict) do
				if value.type == enum.instance.members.removed_members then
					value.type = nil
					wrapper.dict[key] = nil
				end
			end
			--print(wrapper)
			temp_wrapper = nil
			storage.Schemas[wrapper.values.class_name] = wrapper
		end

		return wrapper
	end

	local function CleanupInstanceStorage(inst)
		storage.Instances[inst] = nil
		if type(storage.Events[inst]) == "table" then
			table.clear(storage.Events[inst])
			storage.Events[inst] = nil
		end
	end

	function module.Wrap(inst, table_cache)
		local value_type = typeof(inst)
		local metatable = getmetatable(inst)
		local cust = type(inst) .. ":" .. value_type
		if cust and data_type_wrappers and data_type_wrappers[cust] and data_type_wrappers[cust].wrap then
			return data_type_wrappers[cust].wrap(inst)
		elseif value_type == "Instance" then
			if inst:HasTag(constants.LockedTag) or inst:HasTag(constants.HiddenTag) or (type(module.settings.WhitelistedTag) == "string" and not inst:HasTag(module.settings.WhitelistedTag)) then
				--error("Fatal error: " .. inst.Name .. " is restricted.", 0)
				--Return nil because sometimes the Player is nil in Studio.
				return nil
			end
			if storage.Instances[inst] then
				return storage.Instances[inst]
			end
			local connection
			connection = inst.Destroying:connect(function()
				connection = nil
				CleanupInstanceStorage(inst)
			end)
			--print("new wrapper")
			local wrapper = CreateInstanceWrapper(inst)
			local t = nil
			local m = nil
			if module.settings.WrapperDataType == "table" then
				t = {}
				m = {}
				setmetatable(t, m)
				m.__eq = TableEqualHandler
			elseif module.settings.WrapperDataType == "userdata" then
				t = newproxy(true)
				m = getmetatable(t)
				m.__eq = UserDataEqualHandler
			end
			m.__index = function(this, key)
				--Store the rest in an outside function to save memory.
				--Remember, a wrapper will be constructed every time a new instance is accessed.
				return IndexWrapper(this, wrapper, inst, key)
			end
			m.__newindex = function(this, key, value)
				NewIndexWrapper(this, wrapper, inst, key, value)
			end
			m.__gc = function()
				CleanupInstanceStorage(inst)
				table.clear(m)
				if connection and connection.Connected then
					connection:disconnect()
					connection = nil
				end
			end
			m.__metatable = constants.InstanceIdentifier
			m.__tostring = function(table)
				if inst then
					return inst.Name
				else
					return "(Deleted)"
				end
			end
			storage.Instances[inst] = t
			return t
		elseif value_type == "RBXScriptSignal" then
			local t = nil
			local m = nil
			if storage.EventWrappers[inst] then
				return storage.EventWrappers[inst]
			end
			if module.settings.WrapperDataType == "table" then
				t = {}
				m = {}
				setmetatable(t, m)
				m.__eq = TableEqualHandler
			elseif module.settings.WrapperDataType == "userdata" then
				t = newproxy(true)
				m = getmetatable(t)
				m.__eq = UserDataEqualHandler
			end
			m.__index = function(_, key)
				return IndexEvent(inst, key)
			end
			m.__newindex = AssignToEvent
			m.__tostring = function()
				return "Signal [REDACTED]"
			end
			m.__gc = function()
				storage.EventWrappers[inst] = nil
			end
			m.__metatable = constants.EventIdentifier
			storage.EventWrappers[inst] = t
			return t
		elseif value_type == "function" then
			if storage.Functions[inst] then
				return storage.Functions[inst]
			else
				local t = nil
				local m = nil
				if module.settings.WrapperDataType == "table" then
					t = {}
					m = {}
					setmetatable(t, m)
					m.__eq = TableEqualHandler
				elseif module.settings.WrapperDataType == "userdata" then
					t = newproxy(true)
					m = getmetatable(t)
					m.__eq = UserDataEqualHandler
				end
				m.__call = function(_, ...)
					return module.CreateWrapperFunctionTunnel(inst, ...)
				end
				m.__index = function(this, key)
					if key == "GetWrapperObject" then
						--Use this to get the real function of a wrapper.
						return function(verification)
							if typeof(verification) == "Instance" and verification:IsA("LuaSourceContainer") then
								return inst
							end
						end
					else
						FunctionIndexCallback(this, key)
					end
				end
				m.__newindex = FunctionIndexCallback
				m.__tostring = function()
					return tostring(inst)
				end
				m.__gc = function()
					storage.Functions[inst] = nil
				end
				m.__metatable = constants.FunctionIdentifier
				storage.Functions[inst] = t
				return storage.Functions[inst]
			end
		elseif value_type == "table" and (module.settings.WrapperDataType ~= "table" or (metatable ~= constants.InstanceIdentifier and metatable ~= constants.EventIdentifier and metatable ~= constants.FunctionIdentifier or string.sub(metatable, 1, #module.settings.CustomTypePrefix) == module.settings.CustomTypePrefix)) then
			if type(table_cache) == "table" and table_cache[inst] then
				--print("circular table detected >:(")
				return table_cache[inst]
			end
			local t = table.clone(inst)
			local beginning = false
			if type(table_cache) ~= "table" then
				table_cache = {}
				beginning = true
			end
			table_cache[inst] = t
			for key, value in pairs(t) do
				t[key] = module.Wrap(value, table_cache)
			end
			if beginning then
				table.clear(table_cache)
				table_cache = nil
			end
			return t
		else
			return inst
		end
	end

	function module.Unwrap(t, reverse_wrap_functions, table_cache)
		local value_type = typeof(t)
		local metatable = getmetatable(t)
		if value_type == module.settings.WrapperDataType and (metatable == constants.InstanceIdentifier or metatable == constants.EventIdentifier or metatable == constants.FunctionIdentifier or string.sub(metatable, 1, #module.settings.CustomTypePrefix) == module.settings.CustomTypePrefix) and t.GetWrapperObject then
			return t.GetWrapperObject(script)
		elseif value_type == "table" then
			if type(getmetatable(t)) ~= "nil" then
				--Security against malicious user-created metatables.
				warn("RBXLuaJailer: Attempted to unwrap a table with a metatable. This is not allowed for security reasons.")
				return nil
			end
			if type(table_cache) == "table" and table_cache[t] then
				--print("circular table detected >:(")
				return table_cache[t]
			end
			local t2 = table.clone(t)
			local beginning = false
			if type(table_cache) ~= "table" then
				table_cache = {}
				beginning = true
			end
			table_cache[t] = t2
			for key, value in pairs(t2) do
				t2[key] = module.Unwrap(value, reverse_wrap_functions, table_cache)
			end
			if beginning then
				table.clear(table_cache)
				table_cache = nil
			end
			return t2
		elseif value_type == "function" and reverse_wrap_functions then
			return module.ReverseWrap(t)
		elseif value_type == module.settings.WrapperDataType and module.GetCustomType(t) then
			return t.GetWrapperObject(script)
		else
			return t
		end
	end

	function module.ReverseWrap(inst)
		--Reverse wrap is to be used when a function is passed to an instance method as a callback. We don't want the game to be sending real instances to a callback...
		if typeof(inst) == "function" then
			if storage.ReverseFunctions[inst] then
				return storage.ReverseFunctions[inst]
			else
				storage.ReverseFunctions[inst] = function(...)
					return module.CreateReverseWrapperFunctionTunnel(inst, ...)
				end
				return storage.ReverseFunctions[inst]
			end
		else
			return inst
		end
	end

	function module.WrapEvent(event)
		--Deprecated function. Here only for backwards compatibility.
		return module.Wrap(event)
	end

	function module.UnwrapIfWrapped(t)
		if typeof(t) == module.settings.WrapperDataType then
			local metatable = getmetatable(t)
			if module.CheckIfWrapped(t) then
				return t.GetWrapperObject(script)
			else
				return t
			end
		else
			return t
		end
	end

	function module.CheckIfWrapped(t)
		if typeof(t) == module.settings.WrapperDataType then
			local metatable = getmetatable(t)
			if (metatable == constants.InstanceIdentifier or metatable == constants.EventIdentifier or metatable == constants.FunctionIdentifier or string.sub(metatable, 1, #module.settings.CustomTypePrefix) == module.settings.CustomTypePrefix) and t.GetWrapperObject then
				return true
			end
		end
		return false
	end

	function module.GetCustomType(t)
		if typeof(t) == module.settings.WrapperDataType then
			local metatable = getmetatable(t)
			if string.sub(metatable, 1, #module.settings.CustomTypePrefix) == module.settings.CustomTypePrefix then
				local parts = string.split(metatable, ":")
				if parts[2] and parts[3] then
					return parts[2] .. ":" .. parts[3]
				end
			end
		end
	end

	function module.CallConstructor(callback, ...)
		local args = table.pack(...)
		for i = 1, #args do
			args[i] = module.UnwrapIfWrapped(args[i])
		end
		return callback(table.unpack(args))
	end

	function module.typeof(obj)
		local value_type = typeof(obj)
		if value_type == module.settings.WrapperDataType then
			local metatable = getmetatable(obj)
			if type(metatable) == "string" then
				if metatable == module.constants.InstanceIdentifier then
					value_type = "Instance"
				elseif metatable == module.constants.EventIdentifier then
					value_type = "RBXScriptSignal"
				elseif metatable == module.constants.FunctionIdentifier then
					value_type = "function"
				elseif string.sub(metatable, 1, #module.settings.CustomTypePrefix) == module.settings.CustomTypePrefix then
					value_type = string.split(metatable, ":")[3]
				end
			end
		end
		return value_type
	end

	function module.type(obj)
		local value_type = type(obj)
		if value_type == module.settings.WrapperDataType then
			local metatable = getmetatable(obj)
			if type(metatable) == "string" then
				if metatable == module.constants.InstanceIdentifier or metatable == module.constants.EventIdentifier then
					value_type = "userdata"
				elseif metatable == module.constants.FunctionIdentifier then
					value_type = "function"
				elseif string.sub(metatable, 1, #module.settings.CustomTypePrefix) == module.settings.CustomTypePrefix then
					value_type = string.split(metatable, ":")[2]
				end
			end
		end
		return value_type
	end

	function module.FindFirstChildAndIgnoreLockedTag(inst, key)
		local found = inst:FindFirstChild(key)
		if not found then
			return nil
		elseif found:HasTag(constants.LockedTag) or found:HasTag(constants.HiddenTag) then
			local children = inst:GetChildren()
			for i = 1, #children do
				if children[i] and children[i].Name == key and not children[i]:HasTag(constants.LockedTag) and not children[i]:HasTag(constants.HiddenTag) then
					return children[i]
				end
			end
		else
			return found
		end
	end

	function module.FindFirstChildOfClassAndIgnoreLockedTag(inst, key)
		local found = inst:FindFirstChildOfClass(key)
		if not found then
			return nil
		elseif found:HasTag(constants.LockedTag) or found:HasTag(constants.HiddenTag) then
			local children = inst:GetChildren()
			for i = 1, #children do
				if children[i] and children[i].ClassName == key and not children[i]:HasTag(constants.LockedTag) and not children[i]:HasTag(constants.HiddenTag) then
					return children[i]
				end
			end
		else
			return found
		end
	end

	function module.GetDescendantAndIgnoreLockedTag(inst, key)
		local found = inst:FindFirstDescendant(key)
		if not found then
			return nil
		elseif found:HasTag(constants.LockedTag) or found:HasTag(constants.HiddenTag) then
			local children = inst:GetDescendants()
			for i = 1, #children do
				if children[i] and children[i].Name == key and not children[i]:HasTag(constants.LockedTag) and not children[i]:HasTag(constants.HiddenTag) then
					return children[i]
				end
			end
		else
			return found
		end
	end

	function module.WaitForChildAndIgnoreLockedTag(inst, key, timeout)
		if not timeout then
			timeout = 0
		end
		local old_time = os.clock()
		local found = module.FindFirstChildAndIgnoreLockedTag(inst, key)
		while not found and (not timeout or (os.clock() - old_time > timeout)) do
			runservice.Heartbeat:Wait()
			found = module.FindFirstChildAndIgnoreLockedTag(inst, key)
		end
		--print("fu2", found)
		return found
	end

	function module.FindFirstDescendantAndIgnoreLockedTag(inst, key)
		local found = inst:FindFirstDescendant(key)
		if not found then
			return nil
		elseif found:HasTag(constants.LockedTag) then
			local children = inst:GetDescendants()
			for i = 1, #children do
				if children[i] and children[i].Name == key and not children[i]:HasTag(constants.LockedTag) and not children[i]:HasTag(constants.HiddenTag) then
					return children[i]
				end
			end
		else
			return found
		end
	end

	function module.LoadWrapperSkeleton(wrap)
		if typeof(wrap) == "string" and wrappers[wrap] then
			if typeof(wrappers[wrap]) == "Instance" and wrappers[wrap].ClassName == "ModuleScript" then
				wrappers[wrap] = require(wrappers[wrap])
				if typeof(wrappers[wrap]) == "table" then
					wrappers[wrap].is_default = false
				elseif wrappers[wrap] == "default" and default_wrappers[wrap] then
					wrappers[wrap] = default_wrappers[wrap]
					if typeof(wrappers[wrap]) == "Instance" then
						wrappers[wrap] = require(wrappers[wrap])
					end
					wrappers[wrap].is_default = true
				elseif wrappers[wrap] == "default" then
					warn("Attempted to load a non-existant default wrapper. (" .. wrap .. ")")
				end
			end
			return wrappers[wrap]
		end
		return nil
	end

	function module.GetWrapperInstances()
		return wrapper_instances
	end

	function module.GetDefaultWrapperInstances()
		return default_wrapper_instances
	end

	for i = 1, #aliasesc do
		aliases[aliasesc[i].Name] = require(aliasesc[i])(module)
	end

	for key, value in pairs(default_aliases) do
		local_default_aliases[key] = value(module)
	end

	--Was using this to test the garbage collection.
	--[[
	task.spawn(function()
		while task.wait(10) do
			print(storage)
		end
	end)
	--]]

	return table.freeze(module)
end

function FunctionIndexCallback(_, key)
	error("attempt to index function with '" .. key .. "'", 0)
end

function EqualHandler(a, b, dt)
	local metatable_a = getmetatable(a)
	if typeof(a) == dt and (metatable_a == constants.InstanceIdentifier or metatable_a == constants.EventIdentifier or metatable_a == constants.FunctionIdentifier) then
		a = a.GetWrapperObject(script)
	end
	local metatable_b = getmetatable(b)
	if typeof(b) == dt and (metatable_b == constants.InstanceIdentifier or metatable_b == constants.EventIdentifier or metatable_b == constants.FunctionIdentifier) then
		b = b.GetWrapperObject(script)
	end
	if typeof(a) ~= typeof(b) then
		return nil
	end
	if rawequal(a, b) then if dt == "table" then return TableEqualHandler else return UserDataEqualHandler end else return nil end
end

function TableEqualHandler(a, b)
	return EqualHandler(a, b, "table")
end

function UserDataEqualHandler(a, b)
	return EqualHandler(a, b, "userdata")
end

return main_module
