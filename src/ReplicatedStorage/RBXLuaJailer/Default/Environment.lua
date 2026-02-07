--[[
	This module sets what globals can and cannot be accessed by the user.
	If you wish to able able to access a global, like for example, the game variable, then add it to the return table.

	"alias" = Set variable global to a value returned by a module with the cooresponding name from the Aliases folder.
	"default" = Load the variable from the module defaults.
	"raw" = Keep the variable the same.
	"wrap" = Wrap variable global with a metatable if it is an instance, event, function, or table.
	"secure_alias" = Use the alias, but set the function's env to the script's one to prevent accessing unsafe globals.
	"use_alias:Name" = Replace "Name" with the alias of your choosing.
	"use_default:Name" = Replace "Name" with the default alias of your choosing.
--]]

return {
	table = "alias",
	pcall = "raw",
	print = "raw",
	game = "wrap",
	Game = "wrap",
	Instance = "alias",
	workspace = "wrap",
	Workspace = "wrap",
	shared = "alias",
	typeof = "alias",
	type = "alias",
	unpack = "alias",
	BrickColor = "alias",
	Color3 = "raw",
	Vector2 = "raw",
	Vector3 = "raw",
	UDim = "raw",
	UDim2 = "raw",
	wait = "raw",
	pairs = "alias",
	ipairs = "alias",
	Enum = "raw",
	math = "raw",
	CFrame = "alias",
	LoadLibrary = "alias",
	error = "raw",
	elapsedTime = "raw",
	ElapsedTime = "raw",
	warn = "raw",
	time = "raw",
	Ray = "alias",
	string = "alias",
	require = "alias",
	ColorSequence = "alias",
	NumberSequence = "alias",
	spawn = "wrap",
	Spawn = "wrap",
	tick = "raw",
	NumberRange = "alias",
	Font = "alias",
	Rect = "alias",
	tostring = "raw",
	tonumber = "wrap",
	Region3 = "alias",
	Region3int16 = "alias",
	Faces = "raw",
	ColorSequenceKeypoint = "alias",
	PhysicalProperties = "alias",
	Vector3int16 = "raw",
	Vector2int16 = "raw",
	getmetatable = "alias",
	setmetatable = "alias",
	_G = "alias",
	printidentity = "alias",
	rawset = "alias",
	rawget = "alias",
	rawlen = "alias",
	rawequal = "alias"
}