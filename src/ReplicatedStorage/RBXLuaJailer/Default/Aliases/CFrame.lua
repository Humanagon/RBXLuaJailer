return function(module)
	return table.freeze({
		Angles = function(...)
			return module.CallConstructor(CFrame.Angles, ...)
		end,
		fromAxisAngle = function(...)
			return module.CallConstructor(CFrame.fromAxisAngle, ...)
		end,
		fromEulerAngles = function(...)
			return module.CallConstructor(CFrame.fromEulerAngles, ...)
		end,
		fromEulerAnglesXYZ = function(...)
			return module.CallConstructor(CFrame.fromEulerAnglesXYZ, ...)
		end,
		fromEulerAnglesYXZ = function(...)
			return module.CallConstructor(CFrame.fromEulerAnglesYXZ, ...)
		end,
		fromMatrix = function(...)
			return module.CallConstructor(CFrame.fromMatrix, ...)
		end,
		fromOrientation = function(...)
			return module.CallConstructor(CFrame.fromOrientation, ...)
		end,
		fromRotationBetweenVectors = function(...)
			return module.CallConstructor(CFrame.fromRotationBetweenVectors, ...)
		end,
		identity = CFrame.identity,
		lookAlong = function(...)
			return module.CallConstructor(CFrame.lookAlong, ...)
		end,
		lookAt = function(...)
			return module.CallConstructor(CFrame.lookAt, ...)
		end,
		new = function(...)
			return module.CallConstructor(CFrame.new, ...)
		end,
	})
end