local wrapper = {}

wrapper.inherits_from = "Instance"

wrapper.properties = {
	"AccountAge",
	"AutoJumpEnabled",
	"CameraMaxZoomDistance",
	"CameraMinZoomDistance",
	"CameraMode",
	"CanLoadCharacterAppearance",
	"Character",
	"CharacterAppearance",
	"CharacterAppearanceId",
	"DataComplexity",
	"DataReady",
	"DevCameraOcclusionMode",
	"DevComputerCameraMode",
	"DevComputerMovementMode",
	"DevEnableMouseLock",
	"DevTouchCameraMode",
	"DevTouchMovementMode",
	"DisplayName",
	"FollowUserId",
	"HasVerifiedBadge",
	"HealthDisplayDistance",
	"LocaleId",
	"MembershipType",
	"NameDisplayDistance",
	"Neutral",
	"ReplicationFocus",
	"RespawnLocation",
	"StepIdOffset",
	"Team",
	"TeamColor",
	"UserId",
	"userId"
}

wrapper.methods = {
	"AddReplicationFocus",
	"ClearCharacterAppearance",
	"DistanceFromCharacter",
	"GetFriendsOnline",
	"GetJoinData",
	"GetMouse",
	"GetNetworkPing",
	"GetRankInGroup",
	"GetRoleInGroup",
	"HasAppearanceLoaded",
	"IsFriendsWith",
	"IsInGroup",
	"IsVerified",
	--"Kick",
	"LoadCharacter",
	"LoadCharacterWithHumanoidDescription",
	"Move",
	"RemoveReplicationFocus",
	"RequestStreamAroundAsync"
}

wrapper.events = {
	"CharacterAdded",
	"CharacterAppearanceLoaded",
	"CharacterRemoving",
	"Chatted",
	"Idled",
	"OnTeleport"
}

return wrapper
