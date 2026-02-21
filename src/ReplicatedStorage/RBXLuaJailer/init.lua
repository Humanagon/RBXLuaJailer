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

local script = script
local require = require
local ipairs = ipairs
local pairs = pairs
local type = type
local shared = shared
local loadstring = loadstring
local setfenv = setfenv
local getfenv = getfenv
local pcall = pcall
local error = error
local typeof = typeof
local setmetatable = setmetatable
local getmetatable = getmetatable
local tostring = tostring
local warn = warn
local newproxy = newproxy

local table_freeze = table.freeze
local table_pack = table.pack
local table_unpack = unpack
local table_clone = table.clone
local table_insert = table.insert
local table_clear = table.clear
local string_split = string.split
local string_sub = string.sub
local debug_info = debug.info
local os_clock = os.clock

local AddTag = game.AddTag
local RemoveTag = game.RemoveTag
local HasTag = game.HasTag
local GetAttribute = game.GetAttribute
local SetAttribute = game.SetAttribute
local IsA = game.IsA
local GetChildren = game.GetChildren
local GetDescendants = game.GetDescendants
local Clone = game.Clone

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
local default_aliasesc = GetChildren(default_module_settings:WaitForChild("Aliases"))
local default_aliases = {}
local default_wrappersc = GetChildren(default_wrappers_folder)
local default_wrappers = {}
local default_env = default_module_settings:WaitForChild("Environment")
local default_plugins = require(default_module_settings:WaitForChild("Plugins"))

table_freeze(default_settings)
table_freeze(default_plugins)

main_module.constants = table_freeze(constants)
main_module.enum = table_freeze(enum)

local instance_identifier = constants.InstanceIdentifier
local function_identifier = constants.FunctionIdentifier
local event_identifier = constants.EventIdentifier
local locked_tag = constants.LockedTag
local hidden_tag = constants.HiddenTag

for i = 1, #default_wrappersc do
	default_wrappers[default_wrappersc[i].Name] = require(default_wrappersc[i])
end

for i = 1, #default_aliasesc do
	default_aliases[default_aliasesc[i].Name] = require(default_aliasesc[i])
end

local default_wrapper_instances = table_clone(default_wrappers)

function main_module.Lock(inst, recursive)
	if typeof(inst) == "Instance" then
		AddTag(inst, locked_tag)
		if recursive then
			for i, desc in ipairs(GetDescendants(inst)) do
				AddTag(desc, locked_tag)
			end
		end
		return true
	end
	return false
end

function main_module.Unlock(inst, recursive)
	if typeof(inst) == "Instance" then
		RemoveTag(inst, locked_tag)
		if recursive then
			for i, desc in ipairs(GetDescendants(inst)) do
				RemoveTag(desc, locked_tag)
			end
		end
		return true
	end
	return false
end

function main_module.Hide(inst, recursive)
	if typeof(inst) == "Instance" then
		AddTag(inst, hidden_tag)
		if recursive then
			for i, desc in ipairs(GetDescendants(inst)) do
				AddTag(desc, hidden_tag)
			end
		end
		return true
	end
	return false
end

function main_module.Unhide(inst, recursive)
	if typeof(inst) == "Instance" then
		RemoveTag(inst, hidden_tag)
		if recursive then
			for i, desc in ipairs(GetDescendants(inst)) do
				RemoveTag(desc, hidden_tag)
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
		AddTag(inst, constants.CoreTag)
		if recursive then
			for i, desc in ipairs(GetDescendants(inst)) do
				AddTag(desc, constants.CoreTag)
			end
		end
		return true
	end
	return false
end

function main_module.UnsetCore(inst, recursive)
	if typeof(inst) == "Instance" then
		RemoveTag(inst, constants.CoreTag)
		if recursive then
			for i, desc in ipairs(GetDescendants(inst)) do
				RemoveTag(desc, constants.CoreTag)
			end
		end
		return true
	end
	return false
end

function main_module.IsLocked(inst)
	if typeof(inst) == "Instance" then
		return HasTag(inst, locked_tag)
	end
	return false
end

function main_module.IsHidden(inst)
	if typeof(inst) == "Instance" then
		return HasTag(inst, hidden_tag)
	end
	return false
end

function main_module.IsCore(inst)
	if typeof(inst) == "Instance" then
		return HasTag(inst, constants.CoreTag)
	end
	return false
end

function main_module.IsCoreScriptDisabled(inst)
	if typeof(inst) == "Instance" then
		return HasTag(inst, constants.CoreScriptDisabledTag)
	end
	return false
end
function main_module.Disappear(handle)
	main_module.Hide(handle, true)
	main_module.SetCore(handle, true)
	return true
end

function main_module.DisappearChildren(handle)
	local handlec = GetChildren(handle)
	for i = 1, #handlec do
		main_module.Disappear(handlec[i])
	end
	return true
end

function main_module.PrepareCoreScripts(wrap, request)
	local scripts = wrap:FindFirstChild("Scripts")
	if not scripts then return nil end
	local ret = {}
	local children = GetChildren(scripts)
	for i = 1, #children do
		local child = children[i]
		ret[child.Name] = Clone(child)
		if not HasTag(ret[child.Name], constants.CoreScriptDisabledTag) then
			ret[child.Name].Disabled = false
		else
			RemoveTag(ret[child.Name], constants.CoreScriptDisabledTag)
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

local needs_equal_handler = not constants.UseSharedGlobal

function main_module.CreateModule(config, name, level, permissions)
	if type(name) ~= "string" then
		name = "default"
	end
	if type(level) ~= "number" then
		level = 0
	end
	if type(permissions) ~= "table" then
		permissions = table_freeze({})
	else
		local success = pcall(function()
			table_freeze(permissions)
		end)
		if not success then
			permissions = table_freeze({})
		end
	end

	local user_id = tonumber(string_split(name, ":")[2])
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
	local wrappersc = GetChildren(wrappers_folder)
	local wrappers = {}
	local plugins = module_settings:FindFirstChild("Plugins") or default_plugins
	local env = require(module_settings:FindFirstChild("Environment") or default_env)
	local local_default_aliases = {}
	local msettings = module_settings:FindFirstChild("Settings")
	local data_type_wrappers = {}
	local dth = module_settings:FindFirstChild("DataTypes")
	if dth then
		for i, v in ipairs(GetChildren(dth)) do
			if IsA(v, "ModuleScript") then
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

	table_freeze(module.permissions)

	if msettings then
		msettings = require(msettings)
		for k, v in pairs(default_settings) do
			if type(msettings[k]) == "nil" then
				msettings[k] = default_settings[k]
			end
		end
		if msettings ~= default_settings then
			pcall(function()
				table_freeze(msettings)
			end)
		end
	else
		msettings = default_settings
	end

	if msettings.WrapperDataType ~= "table" and msettings.WrapperDataType ~= "userdata" then
		error("Invalid settings: WrapperDataType can only be either \"table\" or \"userdata\"", 0)
	end

	module.settings = msettings
	
	local proxy_dict = nil
	if type(msettings.ProxyDictionarySharedKey) == "string" then
		if type(shared[msettings.ProxyDictionarySharedKey]) ~= "table" then
			proxy_dict = setmetatable({}, {__mode = "kv"})
			shared[msettings.ProxyDictionarySharedKey] = proxy_dict
		else
			proxy_dict = shared[msettings.ProxyDictionarySharedKey]
		end
	else
		proxy_dict = {}
	end
	local schema_dict = nil
	if type(msettings.SchemaDictionarySharedKey) == "string" then
		if type(shared[msettings.SchemaDictionarySharedKey]) ~= "table" then
			schema_dict = setmetatable({}, {__mode = "kv"})
			shared[msettings.SchemaDictionarySharedKey] = schema_dict
		else
			schema_dict = shared[msettings.SchemaDictionarySharedKey]
		end
	else
		schema_dict = {}
	end
	local api_enabled = not msettings.DisableAPIFunctions

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
		aliasesc = GetChildren(module_settings.Aliases)
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

	local wrapper_instances = table_clone(wrappers)

	table_freeze(wrapper_instances)

	module.constants = constants
	module.enum = enum
	module.plugins = plugins

	module.whitelist = {
		services = require(whitelists:FindFirstChild("AllowedServices") or default_whitelists:WaitForChild("AllowedServices")),
		instances = require(whitelists:FindFirstChild("AllowedInstances") or default_whitelists:WaitForChild("AllowedInstances"))
	}

	local interpreter = nil
	local compiler = nil

	if module.plugins then
		if typeof(module.plugins.LuaInterpreter) == "Instance" and IsA(module.plugins.LuaInterpreter, "ModuleScript") then
			interpreter = require(module.plugins.LuaInterpreter)
		end
		if typeof(module.plugins.LuaCompiler) == "Instance" and IsA(module.plugins.LuaCompiler, "ModuleScript") then
			compiler = require(module.plugins.LuaCompiler)
		end
	end
	
	local Wrap = nil
	local Unwrap = nil

	local function CreateWrapperMethodTunnel(method, t, ...)
		local inst = proxy_dict[t] or t.GetWrapperObject(script)
		local args = table_pack(inst, ...)
		for i = 2, #args do
			args[i] = module.Unwrap(args[i], true)
		end
		args = table_pack(inst[method](table_unpack(args)))
		for i = 1, #args do
			args[i] = Wrap(args[i])
		end
		return table_unpack(args)
	end

	local GetProperty = nil
	if plugins.Handler and plugins.Handler.GetProperty then
		local GP = plugins.Handler.GetProperty
		GetProperty = function(inst, key)
			return GP(inst, key, player)
		end
	else
		GetProperty = function(inst, key)
			return inst[key]
		end
	end

	local GetMethod = nil
	if plugins.Handler and plugins.Handler.GetMethod then
		local GM = plugins.Handler.GetMethod
		GetMethod = function(this, inst, key, wrapper)
			return GM(this, inst, key, player)
		end
	else
		GetMethod = function(this, inst, key, wrapper)
			return wrapper.dict[key].reference
		end
	end

	local function IndexWrapper(this, wrapper, inst, key)
		--Wrapper API functions
		if api_enabled then
			if key == "GetWrapperObject" then
				--Always use this to get the real instance of a wrapper.
				--The reason you must pass in an instance to this function is to ensure that no wrapped script can access it.
				--This security works 100% of the time since wrapped scripts will never have access to a real instance. (Unless the user accidentally returns one in a custom method, property, etc. PLEASE AVOID DOING THIS!)
				return function(verification)
					if typeof(verification) == "Instance" and IsA(verification, "LuaSourceContainer") then
						return inst
					end
				end
			elseif key == "GetWrapperTable" then
				--Used to get the table of defined properties, methods, and events.
				--The module can also be accessed by using this, which can be used to check context levels, use plugins, etc.
				return function(verification)
					if typeof(verification) == "Instance" and IsA(verification, "LuaSourceContainer") then
						return wrapper
					end
				end
			end
		end

		--Instance handling
		local required = GetAttribute(inst, msettings.RequiredPermissionAttribute)
		if type(required) == "string" and not module.permissions[required] then
			error("Error: Permission " .. required .. " is required to index this Instance", 0)
		elseif wrapper.dict[key] then
			if wrapper.dict[key].type == enum.instance.members.properties or wrapper.dict[key].type == enum.instance.members.read_only_properties or wrapper.dict[key].type == enum.instance.members.events then
				return Wrap(GetProperty(inst, key))
			elseif wrapper.dict[key].type == enum.instance.members.write_only_properties then
				error("Unable to read property " .. key .. ". Property is write only", 0)
			elseif wrapper.dict[key].type == enum.instance.members.methods then
				return GetMethod(this, inst, key, wrapper)
			elseif wrapper.dict[key].type == enum.instance.members.custom_methods then
				return wrapper.dict[key].reference
			elseif wrapper.dict[key].type == enum.instance.members.custom_properties then
				if wrapper.dict[key].reference.read then
					if msettings.AutoWrapCustomMembers then
						return Wrap(wrapper.dict[key].reference.read(this))
					else
						return wrapper.dict[key].reference.read(this)
					end
				elseif wrapper.dict[key].reference.write then
					error("Unable to read property " .. key .. ". Property is write only", 0)
				else
					error("Unable to read property " .. key, 0)
				end
			elseif wrapper.dict[key].type == enum.instance.members.attribute_properties then
				local property = GetAttribute(inst, msettings.AttributePropertyPrefix .. key)
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
				local arr = string_split(wrapper.dict[key].reference, ".")
				local tinst = inst
				for i = 1, #arr - 1 do
					local chs = GetChildren(tinst)
					local found = nil
					for j = 1, #chs do
						if HasTag(chs[j], constants.CoreTag) and arr[i] == chs[j].Name then
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
					return Wrap(tinst[arr[#arr]])
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
					if msettings.AutoWrapCustomMembers then
						storage.Events[inst][key] = Wrap(wrapper.dict[key].reference(this))
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
			if ret then return Wrap(ret) end
		end

		error(key .. " is not a valid member of " .. wrapper.values.class_name .. " \"" .. inst.Name .. "\"", 0)
	end

	local SetProperty = nil

	if plugins.Handler and plugins.Handler.SetProperty then
		local SP = plugins.Handler.SetProperty
		SetProperty = function(inst, key, value)
			SP(inst, key, value, player)
		end
	else
		SetProperty = function(inst, key, value)
			inst[key] = value
		end
	end

	local SetCallback = nil
	if plugins.Handler and plugins.Handler.SetCallback then
		local SC = plugins.Handler.SetCallback
		SetCallback = function(inst, key, value)
			SC(inst, key, value, player)
		end
	else
		SetCallback = function(inst, key, value)
			inst[key] = value
		end
	end

	local function NewIndexWrapper(this, wrapper, inst, key, value)
		if wrapper.dict[key] then
			local value_type = module.typeof(value)
			local required = GetAttribute(inst, msettings.RequiredPermissionAttribute)
			if type(required) == "string" and not module.permissions[required] then
				error("Error: Permission " .. required .. " is required to index this Instance", 0)
			elseif wrapper.dict[key].type == enum.instance.members.properties or wrapper.dict[key].type == enum.instance.members.write_only_properties then
				local v = type(GetProperty(inst, key)) .. ":" .. typeof(GetProperty(inst, key))
				if data_type_wrappers[v] and data_type_wrappers[v].verify then
					data_type_wrappers[v].verify(GetProperty(inst, key), Unwrap(value))
				end
				SetProperty(inst, key, Unwrap(value))
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
						local args = table_pack(...)
						value(table_unpack(Wrap(args)))
					end)
					return
				else
					error("Unable to assign callback " .. key .. ". Function expected, got " .. value_type, 0)
				end
			elseif wrapper.dict[key].type == enum.instance.members.attribute_properties then
				if typeof(GetAttribute(inst, msettings.AttributePropertyPrefix .. key)) == "nil" and wrapper.dict[key].reference.strict then
					error("The " .. key .. " property of " .. wrapper.values.class_name .. " \"" .. inst.Name .. "\" is locked", 0)
				elseif value_type == wrapper.dict[key].reference.type or (wrapper.dict[key].reference.type == "any" and enum.attribute.types[value_type]) then
					SetAttribute(inst, msettings.AttributePropertyPrefix .. key, value)
				else
					error("Unable to assign property " .. key .. ". " .. wrapper.dict[key].reference.type .. " expected, got " .. value_type, 0)
				end
			elseif wrapper.dict[key].type == enum.instance.members.core_properties or wrapper.dict[key].type == enum.instance.members.write_only_properties then
				--Deprecated feature.
				local arr = string_split(wrapper.dict[key].reference, ".")
				local tinst = inst
				for i = 1, #arr - 1 do
					local chs = GetChildren(tinst)
					local found = nil
					for j = 1, #chs do
						if HasTag(chs[j], constants.CoreTag) and arr[i] == chs[j].Name then
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
				if typeof(value) == msettings.WrapperDataType and getmetatable(value) == instance_identifier then
					tinst[arr[#arr]] = Unwrap(value)
				else
					tinst[arr[#arr]] = value
				end
			end
			return true
		else
			error(key .. " is not a valid member of " .. (msettings.CustomClassAttribute and GetAttribute(inst, msettings.CustomClassAttribute) or inst.ClassName) .. " \"" .. inst.Name .. "\"", 0)
		end
	end

	function module.Execute(str, passed_env, is_compiled)
		--This will only work if LoadStringEnabled is true in the ServerScriptService, but is faster than using a lua compiler.
		local loadstringenabled = false
		if msettings.UseLoadStringIfAvailable then
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
		if msettings.UseLoadStringIfAvailable then
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
		local env = custom_env or table_clone(env)
		for key, value in pairs(env) do
			env[key] = Wrap(env[key])
		end
		return env
	end

	function module.MakeSecureEnv(sc) --The sc argument is for passing the current script so it can be wrapped. For those who wish to simulate script sources themselves.
		local this_env = getfenv(debug_info(1, "f"))
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
				ret[key] = Wrap(this_env[key])
			elseif string_sub(value, 1, 10):lower() == "use_alias:" then
				ret[key] = aliases[string_sub(value, 11, (#value - 10) + 11)]
			elseif string_sub(value, 1, 12):lower() == "use_default:" then
				ret[key] = local_default_aliases[string_sub(value, 13, (#value - 12) + 13)]
			elseif value:lower() == "secure_function" then
				ret[key] = aliases[key]
				table_insert(keys_to_secure, key)
			else
				error("Unknown env enum type \"" .. tostring(value) .. "\"", 0)
			end
		end
		if sc then ret.script = Wrap(sc) end
		--ret = table_clone(ret)
		for i = 1, #keys_to_secure do
			local callback = ret[keys_to_secure[i]]
			ret[keys_to_secure[i]] = function(...)
				return callback(ret, ...)
			end 
		end
		return ret
	end

	local function CreateWrapperFunctionTunnel(callback, ...)
		local args = table_pack(...)
		for i = 1, #args do
			args[i] = Unwrap(args[i])
		end
		args = table_pack(callback(table_unpack(args)))
		for i = 1, #args do
			args[i] = Wrap(args[i])
		end
		return table_unpack(args)
	end
	
	module.CreateWrapperFunctionTunnel = CreateWrapperFunctionTunnel

	local function CreateReverseWrapperFunctionTunnel(callback, ...)
		local args = table_pack(...)
		for i = 1, #args do
			args[i] = Wrap(args[i])
		end
		args = table_pack(callback(table_unpack(args)))
		for i = 1, #args do
			args[i] = Unwrap(args[i])
		end
		return table_unpack(args)
	end
	
	module.CreateReverseWrapperFunctionTunnel = CreateReverseWrapperFunctionTunnel

	local function HandleWrapperEvent(callback)
		return function(...)
			local args = table_pack(...)
			for i = 1, #args do
				args[i] = Wrap(args[i])
			end
			args = table_pack(callback(table_unpack(args)))
			for i = 1, #args do
				args[i] = Unwrap(args[i])
			end
			return table_unpack(args)
		end
	end

	local function IndexEvent(inst, key)
		if api_enabled and key == "GetWrapperObject" then
			--Use this to get the real event of a wrapper.
			return function(verification)
				if typeof(verification) == "Instance" and IsA(verification, "LuaSourceContainer") then
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

	local CheckIfWrapped = nil

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
		local cn = GetAttribute(inst, msettings.CustomClassAttribute)
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
									local args = table_pack(...)
									if #args == 0 or not CheckIfWrapped(args[1]) or module.typeof(args[1]) ~= "Instance" then
										error(invalid_method_self, 0)
									end
									local lcn = args[1].ClassName
									if not storage.Schemas[lcn] or (lcn ~= class_name and not table.find(storage.Schemas[lcn].values.inherits_from, class_name)) then
										error(invalid_method_self, 0)
									end
									if msettings.AutoWrapCustomMembers then
										return Wrap(temp_wrapper[properties_string][key](...))
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
									local args = table_pack(...)
									if #args == 0 or not CheckIfWrapped(args[1]) or module.typeof(args[1]) ~= "Instance" then
										error(invalid_method_self, 0)
									end
									local lcn = args[1].ClassName
									if not storage.Schemas[lcn] or (lcn ~= class_name and not table.find(storage.Schemas[lcn].values.inherits_from, class_name)) then
										error(invalid_method_self, 0)
									end
									return CreateWrapperFunctionTunnel(method, ...)
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
					table_insert(wrapper.values.inherits_from, temp_name)
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
			table_clear(storage.Events[inst])
			storage.Events[inst] = nil
		end
	end

	Wrap = function(inst, table_cache)
		local value_type = typeof(inst)
		if proxy_dict and proxy_dict[inst] and value_type == msettings.WrapperDataType then
			return inst
		end
		local metatable = getmetatable(inst)
		local cust = type(inst) .. ":" .. value_type
		if cust and data_type_wrappers and data_type_wrappers[cust] and data_type_wrappers[cust].wrap then
			local t = data_type_wrappers[cust].wrap(inst)
			if proxy_dict then
				proxy_dict[t] = inst
			end
			return t
		elseif value_type == "Instance" then
			if HasTag(inst, locked_tag) or HasTag(inst, hidden_tag) or (type(msettings.WhitelistedTag) == "string" and not HasTag(inst, msettings.WhitelistedTag)) then
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
			if msettings.WrapperDataType == "table" then
				t = {}
				m = {}
				setmetatable(t, m)
				if needs_equal_handler then
					m.__eq = TableEqualHandler
				end
			elseif msettings.WrapperDataType == "userdata" then
				t = newproxy(true)
				m = getmetatable(t)
				if needs_equal_handler then
					m.__eq = UserDataEqualHandler
				end
			end
			m.__index = function(this, key)
				--Store the rest in an outside function to save memory.
				--Remember, a wrapper will be constructed every time a new instance is accessed.
				return IndexWrapper(this, wrapper, inst, key)
			end
			m.__newindex = function(this, key, value)
				NewIndexWrapper(this, wrapper, inst, key, value)
			end
			--[[
			m.__gc = function()
				CleanupInstanceStorage(inst)
				table_clear(m)
				if connection and connection.Connected then
					connection:disconnect()
					connection = nil
				end
			end
			--]]
			m.__metatable = instance_identifier
			m.__tostring = function(table)
				if inst then
					return inst.Name
				else
					return "(Deleted)"
				end
			end
			storage.Instances[inst] = t
			if proxy_dict then
				proxy_dict[t] = inst
			end
			if schema_dict then
				schema_dict[t] = wrapper
			end
			return t
		elseif value_type == "RBXScriptSignal" then
			local t = nil
			local m = nil
			if storage.EventWrappers[inst] then
				return storage.EventWrappers[inst]
			end
			if msettings.WrapperDataType == "table" then
				t = {}
				m = {}
				setmetatable(t, m)
				if needs_equal_handler then
					m.__eq = TableEqualHandler
				end
			elseif msettings.WrapperDataType == "userdata" then
				t = newproxy(true)
				m = getmetatable(t)
				if needs_equal_handler then
					m.__eq = UserDataEqualHandler
				end
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
			m.__metatable = event_identifier
			storage.EventWrappers[inst] = t
			if proxy_dict then
				proxy_dict[t] = inst
			end
			return t
		elseif value_type == "function" then
			if storage.Functions[inst] then
				return storage.Functions[inst]
			else
				local t = nil
				local m = nil
				if msettings.WrapperDataType == "table" then
					t = {}
					m = {}
					setmetatable(t, m)
					if needs_equal_handler then
						m.__eq = TableEqualHandler
					end
				elseif msettings.WrapperDataType == "userdata" then
					t = newproxy(true)
					m = getmetatable(t)
					if needs_equal_handler then
						m.__eq = UserDataEqualHandler
					end
				end
				m.__call = function(_, ...)
					return CreateWrapperFunctionTunnel(inst, ...)
				end
				if api_enabled then
					m.__index = function(this, key)
						if key == "GetWrapperObject" and not msettings.DisableAPIFunctions then
							--Use this to get the real function of a wrapper.
							return function(verification)
								if typeof(verification) == "Instance" and IsA(verification, "LuaSourceContainer") then
									return inst
								end
							end
						else
							FunctionIndexCallback(this, key)
						end
					end
				else
					m.__index = FunctionIndexCallback
				end
				m.__newindex = FunctionIndexCallback
				m.__tostring = function()
					return tostring(inst)
				end
				m.__gc = function()
					storage.Functions[inst] = nil
				end
				m.__metatable = function_identifier
				storage.Functions[inst] = t
				if proxy_dict then
					proxy_dict[t] = inst
				end
				return t
			end
		elseif value_type == "table" and (msettings.WrapperDataType ~= "table" or (metatable ~= instance_identifier and metatable ~= event_identifier and metatable ~= function_identifier or string_sub(metatable, 1, #msettings.CustomTypePrefix) == msettings.CustomTypePrefix)) then
			if type(table_cache) == "table" and table_cache[inst] then
				--print("circular table detected >:(")
				return table_cache[inst]
			end
			local t = table_clone(inst)
			local beginning = false
			if type(table_cache) ~= "table" then
				table_cache = {}
				beginning = true
			end
			table_cache[inst] = t
			for key, value in pairs(t) do
				t[key] = Wrap(value, table_cache)
			end
			if beginning then
				table_clear(table_cache)
				table_cache = nil
			end
			return t
		else
			return inst
		end
	end
	
	module.Wrap = Wrap

	local ReverseWrap = nil
	local GetCustomType = nil

	Unwrap = function(t, reverse_wrap_functions, table_cache)
		local value_type = typeof(t)
		local metatable = getmetatable(t)
		if value_type == msettings.WrapperDataType and (metatable == instance_identifier or metatable == event_identifier or metatable == function_identifier or string_sub(metatable, 1, #msettings.CustomTypePrefix) == msettings.CustomTypePrefix) and t.GetWrapperObject then
			return proxy_dict and proxy_dict[t] or api_enabled and proxy_dict[t] or t.GetWrapperObject(script)
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
			local t2 = table_clone(t)
			local beginning = false
			if type(table_cache) ~= "table" then
				table_cache = {}
				beginning = true
			end
			table_cache[t] = t2
			for key, value in pairs(t2) do
				t2[key] = Unwrap(value, reverse_wrap_functions, table_cache)
			end
			if beginning then
				table_clear(table_cache)
				table_cache = nil
			end
			return t2
		elseif value_type == "function" and reverse_wrap_functions then
			return ReverseWrap(t)
		elseif value_type == msettings.WrapperDataType and GetCustomType(t) then
			return proxy_dict and proxy_dict[t] or api_enabled and proxy_dict[t] or t.GetWrapperObject(script)
		else
			return t
		end
	end
	
	module.Unwrap = Unwrap

	ReverseWrap = function(inst)
		--Reverse wrap is to be used when a function is passed to an instance method as a callback. We don't want the game to be sending real instances to a callback...
		if typeof(inst) == "function" then
			if storage.ReverseFunctions[inst] then
				return storage.ReverseFunctions[inst]
			else
				storage.ReverseFunctions[inst] = function(...)
					return CreateReverseWrapperFunctionTunnel(inst, ...)
				end
				return storage.ReverseFunctions[inst]
			end
		else
			return inst
		end
	end
	
	module.ReverseWrap = ReverseWrap

	function module.WrapEvent(event)
		--Deprecated function. Here only for backwards compatibility.
		return Wrap(event)
	end
	
	local UnwrapIfWrapped = function(t)
		if typeof(t) == msettings.WrapperDataType then
			local metatable = getmetatable(t)
			if CheckIfWrapped(t) then
				return proxy_dict[t] or t.GetWrapperObject(script)
			else
				return t
			end
		else
			return t
		end
	end
	
	module.UnwrapIfWrapped = UnwrapIfWrapped

	CheckIfWrapped = function(t)
		if typeof(t) == msettings.WrapperDataType then
			local metatable = getmetatable(t)
			if (metatable == instance_identifier or metatable == event_identifier or metatable == function_identifier or string_sub(metatable, 1, #msettings.CustomTypePrefix) == msettings.CustomTypePrefix) then
				return true
			end
		end
		return false
	end
	
	module.CheckIfWrapped = CheckIfWrapped

	GetCustomType = function(t)
		if typeof(t) == msettings.WrapperDataType then
			local metatable = getmetatable(t)
			if string_sub(metatable, 1, #msettings.CustomTypePrefix) == msettings.CustomTypePrefix then
				local parts = string_split(metatable, ":")
				if parts[2] and parts[3] then
					return parts[2] .. ":" .. parts[3]
				end
			end
		end
	end
	
	module.GetCustomType = GetCustomType

	function module.CallConstructor(callback, ...)
		local args = table_pack(...)
		for i = 1, #args do
			args[i] = UnwrapIfWrapped(args[i])
		end
		return callback(table_unpack(args))
	end

	function module.typeof(obj)
		local value_type = typeof(obj)
		if value_type == msettings.WrapperDataType then
			local metatable = getmetatable(obj)
			if type(metatable) == "string" then
				if metatable == instance_identifier then
					value_type = "Instance"
				elseif metatable == event_identifier then
					value_type = "RBXScriptSignal"
				elseif metatable == function_identifier then
					value_type = "function"
				elseif string_sub(metatable, 1, #msettings.CustomTypePrefix) == msettings.CustomTypePrefix then
					value_type = string_split(metatable, ":")[3]
				end
			end
		end
		return value_type
	end

	function module.type(obj)
		local value_type = type(obj)
		if value_type == msettings.WrapperDataType then
			local metatable = getmetatable(obj)
			if type(metatable) == "string" then
				if metatable == instance_identifier or metatable == event_identifier then
					value_type = "userdata"
				elseif metatable == function_identifier then
					value_type = "function"
				elseif string_sub(metatable, 1, #msettings.CustomTypePrefix) == msettings.CustomTypePrefix then
					value_type = string_split(metatable, ":")[2]
				end
			end
		end
		return value_type
	end

	function module.FindFirstChildAndIgnoreLockedTag(inst, key)
		local found = inst:FindFirstChild(key)
		if not found then
			return nil
		elseif HasTag(found, locked_tag) or HasTag(found, hidden_tag) then
			local children = GetChildren(inst)
			for i = 1, #children do
				local child = children[i]
				if child and child.Name == key and not HasTag(child, locked_tag) and not HasTag(child, hidden_tag) then
					return child
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
		elseif HasTag(found, locked_tag) or HasTag(found, hidden_tag) then
			local children = GetChildren(inst)
			for i = 1, #children do
				local child = children[i]
				if child and child.ClassName == key and not HasTag(child, locked_tag) and not HasTag(child, hidden_tag) then
					return child
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
		elseif HasTag(found, locked_tag) or HasTag(found, hidden_tag) then
			local children = GetDescendants(inst)
			for i = 1, #children do
				local child = children[i]
				if child and child.Name == key and not HasTag(child, locked_tag) and not HasTag(child, hidden_tag) then
					return child
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
		local old_time = os_clock()
		local found = module.FindFirstChildAndIgnoreLockedTag(inst, key)
		while not found and (not timeout or (os_clock() - old_time > timeout)) do
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
		elseif HasTag(found, locked_tag) then
			local children = GetDescendants(inst)
			for i = 1, #children do
				local child = children[i]
				if child and child.Name == key and not HasTag(child, locked_tag) and not HasTag(child, hidden_tag) then
					return child
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

	return table_freeze(module)
end

function FunctionIndexCallback(_, key)
	error("attempt to index function with '" .. key .. "'", 0)
end

function EqualHandler(a, b, dt)
	local metatable_a = getmetatable(a)
	if typeof(a) == dt and (metatable_a == instance_identifier or metatable_a == event_identifier or metatable_a == function_identifier) then
		a = a.GetWrapperObject(script)
	end
	local metatable_b = getmetatable(b)
	if typeof(b) == dt and (metatable_b == instance_identifier or metatable_b == event_identifier or metatable_b == function_identifier) then
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
