--[[
	========WRAPPER MODULE EXAMPLE========

	local wrapper = {}

	wrapper.inherits_from = "Model" --The class which all instance members are inherited from.
	wrapper.real_class = "Tool" --Specifies the class that is used to represent the custom one.
	wrapper.disable_child_access = false --If true, children cannot be accessed with a period. (.)

	wrapper.properties = {
		"Enabled",
		"Grip"
	}

	wrapper.read_only_properties = {
		"Name" --Adding an inherited member to a wrapper overrides it.
	}
	
	wrapper.write_only_properties = {
		"ToolTip" --Can only be changed, not read.
	}
	
	wrapper.custom_properties = {
		DescendantCount = {
			read = function(t)
				local inst = t.GetWrapperObject(script)
				return #inst:GetDescendants()
			end,
			write = function(t, value)
				error("Could not set property to value " .. value .. " because it is read-only", 0) --Leaving the write key out entirely will work as a write-only as well.
			end,
			type = "number" --This is used for automatic write type checking.
		}
	}
	
	--Easily the quickest and most satisfying way to do custom properties.
	wrapper.attribute_properties = {
		SecretBrickColor = {
			type = "BrickColor", --Datatype of the property. (Or "any" for all datatypes supported by attributes.)
			strict = true --If true, then only instances that already have this attribute will be accessible.
			default = BrickColor.new("Bright red") --Sets the default property. (If nil, it will show this property)
		}
	}

	--For making custom classes easily:
	wrapper.core_properties = {
		Position = "Handle.Position",
		Orientation = "Handle.Orientation",
		Anchored = "Handle.Anchored"
	}
	
	wrapper.read_only_core_properties = {
		Size = "Handle.Size",
		BrickColor = "Handle.BrickColor"
	}
	
	wrapper.write_only_core_properties = {
		Anchored = "Handle.Locked"

	wrapper.methods = {
		"Activate"
	}
	
	wrapper.custom_methods = {
		Unequip = function(t, ...)
			local inst = t.GetWrapperObject(script)
			local player = game:GetService("Players"):GetPlayerFromCharacter(inst.Parent)
			inst.Parent = player.Backpack
			return true
		end
	}
	
	wrapper.core_methods = {
		PivotTo = "Handle.PivotTo"
	}
	
	wrapper.events = {
		"Activated"
	}
	
	wrapper.removed_members = {
		"TextureId" --Removes instance members from the previous inherited classes.
	}

	wrapper.child_override = function(t, key) --If set to a function, this value replaces the default child access function.
		local inst = t.GetWrapperObject(script)
		local child = inst:FindFirstChild(key)
		if child and child:IsA("Weld") then
			return child
		end
		return nil
	end

	return wrapper
--]]

return true