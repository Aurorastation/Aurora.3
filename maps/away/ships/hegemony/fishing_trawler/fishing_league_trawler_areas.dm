/area/ship/fishing_trawler
	name = "Fishing League Trawler"
	requires_power = TRUE
	icon_state = "yellow"
	ambience = AMBIENCE_GENERIC

//Fore

/area/ship/fishing_trawler/bridge
	name = "Fishing Trawler - Bridge"
	icon_state = "bridge"

/area/ship/fishing_trawler/EVA_port
	name = "Fishing Trawler - EVA Port"
	icon_state = "eva"

/area/ship/fishing_trawler/EVA_starboard
	name = "Fishing Trawler - EVA Starboard"
	icon_state = "eva"

/area/ship/fishing_trawler/Captain
	name = "Fishing Trawler - Captain's Quarters"
	icon_state = "captain"


//Central

/area/ship/fishing_trawler/crew_quarters
	name = "Fishing Trawler - Crew Quarters"
	icon_state = "crew_quarters"

/area/ship/fishing_trawler/kitchen
	name = "Fishing Trawler - Kitchen"
	icon_state = "kitchen"

/area/ship/fishing_trawler/galley
	name = "Fishing Trawler - Galley"
	icon_state = "crew_area"

/area/ship/fishing_trawler/medical
	name = "Fishing Trawler - Galley"
	icon_state = "medbay"


//Aft

/area/ship/fishing_trawler/freezer
	name = "Fishing Trawler - Fish Freezer"
	icon_state = "storage"

//Engineering

/area/ship/fishing_trawler/engineering
	name = "Fishing Trawler - Engineering"
	icon_state = "engineering"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED
	ambience = AMBIENCE_ENGINEERING

/area/ship/fishing_trawler/engineering/port
	name = "Fishing Trawler - Port Thrusters"

/area/ship/fishing_trawler/engineering/Starboard
	name = "Fishing Trawler - Starboard Thrusters"

/area/ship/fishing_trawler/engineering
	name = "Fishing Trawler - Reactor"

//Coridors

/area/ship/fishing_trawler/corridor
	name = "Fishing Trawler - Corridor"
	icon_state = "hallC"
	sound_environment = SOUND_ENVIRONMENT_STONE_CORRIDOR

/area/ship/fishing_trawler/corridor/central
	name = "Fishing Trawler - Central Corridor"

/area/ship/fishing_trawler/corridor/port
	name = "Fishing Trawler - Port Corridor"

/area/ship/fishing_trawler/corridor/starboard
	name = "Fishing Trawler - Starboard Corridor"

//Exterior

/area/ship/fishing/trawler/fishing_catwalk
	name = "Fishing Catwalk"
	icon_state = "exterior"
	base_turf = /turf/space
	requires_power = FALSE
	dynamic_lighting = TRUE
	has_gravity = FALSE
	no_light_control = TRUE
	allow_nightmode = FALSE
	ambience = AMBIENCE_SPACE

//Shuttle
/area/shuttle/fishing_trawler
	name = "Fishing Trawler Shuttle"
	icon_state = "shuttle"
	requires_power = TRUE
