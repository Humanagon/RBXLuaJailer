local wrapper = {}

wrapper.inherits_from = "Object"

wrapper.properties = {
	"Archivable",
	"Name",
	"Parent",
	"RobloxLocked"
}

wrapper.methods = {
	"GetFullName"
}

local function CloneInstance(t)
	local inst = t.GetWrapperObject(script)
	local wtable = t.GetWrapperTable(script)
	for i, desc in ipairs(inst:GetDescendants()) do
		if desc.Parent ~= nil and desc:HasTag(wtable.module.constants.LockedTag) then
			error("Something is preventing Instance \"" .. inst.Name .. "\" from being cloned", 0)
		end
	end
	local clone = inst:Clone()
	return wtable.module.Wrap(clone)
end

wrapper.custom_methods = {
	Destroy = function(t)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local descs = inst:GetDescendants()
		for i = 1, #descs do
			if descs[i]:HasTag(wtable.module.constants.LockedTag) then
				error("Something is preventing Instance \"" .. inst.Name .. "\" from being destroyed", 0)
			end
		end
		return inst:Destroy()
	end,
	WaitForChild = function(t, name, timeout)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		return wtable.module.Wrap(wtable.module.WaitForChildAndIgnoreLockedTag(inst, name, timeout))
	end,
	FindFirstChild = function(t, name, recursive)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		if recursive then
			return wtable.module.Wrap(wtable.module.GetDescendantAndIgnoreLockedTag(inst, name))
		else
			return wtable.module.Wrap(wtable.module.FindFirstChildAndIgnoreLockedTag(inst, name))
		end
	end,
	FindFirstChildOfClass = function(t, name)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		return wtable.module.Wrap(wtable.module.FindFirstChildOfClassAndIgnoreLockedTag(inst, name))
	end,
	Clone = CloneInstance,
	clone = CloneInstance,
	ClearAllChildren = function(t)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		for i, child in pairs(inst:GetChildren()) do
			if not child:HasTag(wtable.module.constants.LockedTag) and not child:HasTag(wtable.module.constants.HiddenTag) then
				child:Destroy()
			end
		end
		return true
	end,
	GetChildren = function(t)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local descendants = inst:GetChildren()
		local count = #descendants
		local index = 1
		for i = 1, count do
			if descendants[index]:HasTag(wtable.module.constants.LockedTag) or descendants[index]:HasTag(wtable.module.constants.HiddenTag) then
				table.remove(descendants, index)
				index = index - 1
			end
			index = index + 1
		end
		return wtable.module.Wrap(descendants)
	end,
	GetDescendants = function(t)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local descendants = inst:GetDescendants()
		local count = #descendants
		local index = 1
		for i = 1, count do
			if descendants[index]:HasTag(wtable.module.constants.LockedTag) or descendants[index]:HasTag(wtable.module.constants.HiddenTag) then
				table.remove(descendants, index)
				index = index - 1
			else
				local parent = descendants[index].Parent
				while parent do
					if parent:HasTag(wtable.module.constants.LockedTag) or descendants[index]:HasTag(wtable.module.constants.HiddenTag) then
						table.remove(descendants, index)
						index = index - 1
						break
					end
					parent = parent.Parent
				end
			end
			index = index + 1
		end
		return wtable.module.Wrap(descendants)
	end,
	FindFirstAncestor = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		return wtable.module.Wrap(inst:FindFirstAncestor(str))
	end,
	FindFirstAncestorOfClass = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		return wtable.module.Wrap(inst:FindFirstAncestorOfClass(str))
	end,
	FindFirstAncestorWhichIsA = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		return wtable.module.Wrap(inst:FindFirstAncestorWhichIsA(str))
	end,
	FindFirstDescendant = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		return wtable.module.Wrap(wtable.module.FindFirstDescendantAndIgnoreLockedTag(inst, str))
	end,
	AddTag = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local err = CheckForReservedTag(wtable, str)
		if err then error(err, 0) end
		return inst:AddTag(str)
	end,
	HasTag = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local err = CheckForReservedTag(wtable, str)
		if err then return false end
		return inst:HasTag(str)
	end,
	GetTags = function(t)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local index = 1
		local tags = inst:GetTags()
		local count = #tags
		for i = 1, count do
			if CheckForReservedTag(wtable, tags[index]) then
				table.remove(tags, index)
				index = index - 1
			end
			index = index + 1
		end
		return tags
	end,
	RemoveTag = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local err = CheckForReservedTag(wtable, str)
		if err then error(err, 0) end
		return inst:RemoveTag(str)
	end,
	SetAttribute = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local err = CheckForReservedAttribute(wtable, str)
		if err then error(err, 0) end
		return inst:SetAttribute(str)
	end,
	GetAttribute = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local err = CheckForReservedAttribute(wtable, str)
		if err then error(err, 0) end
		return inst:GetAttribute(str)
	end,
	GetAttributes = function(t)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local attributes = inst:GetAttributes()
		for key, value in pairs(attributes) do
			if CheckForReservedAttribute(wtable, key) then
				attributes[key] = nil
			end
		end
		return attributes
	end,
	GetAttributeChangedSignal = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local err = CheckForReservedAttribute(wtable, str)
		if err then error(err, 0) end
		return wtable.module.Wrap(inst:GetAttributeChangedSignal(str))
	end,
	GetPropertyChangedSignal = function(t, str)
		local inst = t.GetWrapperObject(script)
		local wtable = t.GetWrapperTable(script)
		local wt = t.GetWrapperTable(script)
		if wt.dict[str] and wt.dict[str].type == wtable.module.enum.instance.members.attribute_properties then
			return wtable.module.Wrap(inst:GetAttributeChangedSignal(wtable.module.constants.AttributePropertyPrefix .. str))
		elseif wt.dict[str] and (wt.dict[str].type == wtable.module.enum.instance.members.properties or wt.dict[str].type == wtable.module.enum.instance.members.read_only_properties) then
			return wtable.module.Wrap(inst:GetPropertyChangedSignal(str))
		else
			error(str .. " is not a valid property name.", 0)
		end
	end
}

wrapper.events = {
	"AncestryChanged",
	"AttributeChanged",
	"ChildAdded",
	"ChildRemoved",
	"DescendantAdded",
	"DescendantRemoving",
	"Destroying",
	"StyledPropertiesChanged",
	"childAdded"
}

function CheckForReservedTag(wtable, str)
	for i = 1, #wtable.module.constants.reserved.tags do
		if wtable.module.constants.reserved.tags[i] == str then
			return "Sorry, but \"" .. str .. "\" is a reserved tag."
		end
	end
	for i = 1, #wtable.module.constants.reserved.tag_prefixes do
		if wtable.module.constants.reserved.tag_prefixes[i] == string.sub(str, 1, #wtable.module.constants.reserved.tag_prefixes[i]) then
			return "Sorry, but tags are not allowed to begin with \"" .. wtable.module.constants.reserved.tag_prefixes[i] .. "\""
		end
	end
	return nil
end

function CheckForReservedAttribute(wtable, str)
	for i = 1, #wtable.module.constants.reserved.attributes do
		if wtable.module.constants.reserved.attributes[i] == str then
			return "Sorry, but \"" .. str .. "\" is a reserved attribute."
		end
	end
	for i = 1, #wtable.module.constants.reserved.attribute_prefixes do
		if wtable.module.constants.reserved.attribute_prefixes[i] == string.sub(str, 1, #wtable.module.constants.reserved.attribute_prefixes[i]) then
			return "Sorry, but attributes are not allowed to begin with \"" .. wtable.module.constants.reserved.attribute_prefixes[i] .. "\""
		end
	end
	return nil
end

return wrapper