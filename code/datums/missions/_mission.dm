/singleton/mission
	/// The mission's name. Displayed in the round end report and some other places.
	var/name = "Generic Mission"
	/// The mission's description. Displayed in the round end report and some other places.
	var/desc = "A generic mission that should not be in the rotation."
	/// What sectors this mission can spawn in. An empty list is all sectors.
	var/list/sector_whitelist = list()
	/// The type of mission this is. Either MISSION_TYPE_NONCANON or MISSION_TYPE_CANON. NOT a boolean or a bitfield.
	var/mission_type = MISSION_TYPE_NONCANON
	/// The maps to load. This is a list of /datum/map_template. If left null, there will be an error.
	var/list/datum/map_template/maps_to_load
	/// This determines spawning behaviour. Not a bitfield. See MISSION_SPAWN_FLAG_ON_PLANET or MISSION_SPAWN_FLAG_ON_NEW_ZLEVEL.
	var/spawning_flags
