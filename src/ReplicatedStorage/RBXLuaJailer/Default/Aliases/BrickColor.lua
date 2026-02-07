return function(module)
	return table.freeze({
		new = function(val)
			return BrickColor.new(module.UnwrapIfWrapped(val))
		end,
		palette = function(val)
			return BrickColor.palette(module.UnwrapIfWrapped(val))
		end,
		random = function()
			return BrickColor.random()
		end,
		Random = function()
			return BrickColor.Random()
		end,
		Yellow = function()
			return BrickColor.Yellow()
		end,
		White = function()
			return BrickColor.White()
		end,
		Red = function()
			return BrickColor.Red()
		end,
		New = function()
			return BrickColor.New()
		end,
		Green = function()
			return BrickColor.Green()
		end,
		Gray = function()
			return BrickColor.Gray()
		end,
		DaryGray = function()
			return BrickColor.DarkGray()
		end,
		Blue = function()
			return BrickColor.Blue()
		end,
		Black = function()
			return BrickColor.Black()
		end
	})
end