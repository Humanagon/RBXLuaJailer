--The plugins module is used for adding features that aren't implemented by default.

local interpreter = script:FindFirstChild("vLua")
local compiler = nil
if interpreter then
	compiler = interpreter:FindFirstChild("Yueliang")
end

return {
	LuaInterpreter = interpreter, --Set this to the location of your lua interpreter of choice. (Like vLua)
	LuaCompiler = compiler
}
