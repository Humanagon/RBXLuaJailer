local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.properties = {
	"BackAccessory",
	"BodyTypeScale",
	"ClimbAnimation",
	"DepthScale",
	"Face",
	"FaceAccessory",
	"FallAnimation",
	"FrontAccessory",
	"GraphicTShirt",
	"HairAccessory",
	"HatAccessory",
	"Head",
	"HeadColor",
	"HeadScale",
	"IdleAnimation",
	"LeftArm",
	"LeftArmColor",
	"LeftLeg",
	"LeftLegColor",
	"MoodAnimation",
	"NeckAccessory",
	"Pants",
	"ProportionScale",
	"RightArm",
	"RightArmColor",
	"RightLeg",
	"RightLegColor",
	"RunAnimation",
	"Shirt",
	"ShouldersAccessory",
	"SwimAnimation",
	"Torso",
	"TorsoColor",
	"WaistAccessory",
	"WalkAnimation",
	"WidthScale"
}

wrapper.methods = {
	"AddEmote",
	"GetAccessories",
	"GetEmotes",
	"GetEquippedEmotes",
	"RemoveEmote",
	"SetAccessories",
	"SetEmotes",
	"SetEquippedEmotes"
}

wrapper.events = {
	"EmotesChanged",
	"EquippedEmotesChanged"
}

return wrapper
