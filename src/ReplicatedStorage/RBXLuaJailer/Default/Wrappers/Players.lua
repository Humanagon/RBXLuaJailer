local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.properties = {
	"BubbleChat",
	"CharacterAutoLoads",
	"ClassicChat",
	"LocalPlayer",
	"MaxPlayers",
	"NumPlayers",
	"PreferredPlayers",
	"RespawnTime",
	"localPlayer",
	"numPlayers"
}

wrapper.methods = {
	"CreateHumanoidModelFromDescription",
	"CreateHumanoidModelFromUserId",
	"GetCharacterAppearanceAsync",
	"GetCharacterAppearanceInfoAsync",
	"GetFriendsAsync",
	"GetHumanoidDescriptionFromOutfitId",
	"GetHumanoidDescriptionFromUserId",
	"GetNameFromUserIdAsync",
	"GetPlayerByUserId",
	"GetPlayerFromCharacter",
	"GetPlayers",
	"GetUserIdFromNameAsync",
	"GetUserThumbnailAsync",
	"getPlayers",
	"playerFromCharacter",
	"players"
}

wrapper.events = {
	"PlayerAdded",
	"PlayerMembershipChanged",
	"PlayerRemoving",
	"UserSubscriptionStatusChanged"
}

return wrapper
