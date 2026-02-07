return {
	instance = {
		members = {
			properties = 1,
			read_only_properties = 2,
			write_only_properties = 3,
			custom_properties = 4,
			attribute_properties = 5,
			methods = 6,
			custom_methods = 7,
			events = 8,
			callbacks = 9,
			removed_members = 10,
			core_properties = 11,
			read_only_core_properties = 12,
			write_only_core_properties = 13,
			core_methods = 14,
			core_events = 15,
			custom_events = 16
		}
	},
	attribute = {
		types = {
			string = 1,
			boolean = 2,
			number = 3,
			UDim = 4,
			UDim2 = 5,
			BrickColor = 6,
			Color3 = 7,
			Vector2 = 8,
			Vector3 = 9,
			CFrame = 10,
			NumberSequence = 11,
			ColorSequence = 12,
			NumberRange = 13,
			Rect = 14,
			Font = 15,
			["nil"] = 16 --Only allowed when property type of "any" is used.
		}
	}
}