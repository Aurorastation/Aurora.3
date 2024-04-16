/singleton/situation
	/// The situation's name. Displayed in the round end report and some other places.
	var/name = "Generic Situation"
	/// The situation's description. Displayed in the round end report and some other places.
	var/desc = "A generic situation that should not be in the rotation."
	/// What sectors this situation can spawn in. An empty list is all sectors.
	var/list/sector_whitelist = list()
	/// The type of situation this is. NOT a boolean or a bitfield.
	var/mission_type = SITUATION_TYPE_NONCANON
	/// The maps to load. This is a list of /datum/map_template. If left null, there will be an error.
	var/list/maps_to_load
	/// This determines spawning behaviour. Not a bitfield.
	var/spawning_flags = SITUATION_SPAWN_FLAG_ON_NEW_ZLEVEL
	/// Weight given to the situation in pickweight when being picked.
	var/weight = 20
