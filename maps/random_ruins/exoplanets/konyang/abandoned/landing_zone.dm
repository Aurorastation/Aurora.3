//Functional copy of the standard landing zone with a different exterior to fit the abandoned biome
/datum/map_template/ruin/exoplanet/konyang_abandoned_landing_zone
	name = "SCC Expedition Command Center Landing Zone"
	id = "konyang_abandoned_landing_zone"
	description = "An artificial orbitally-dropped prefab of flattened ground established for shuttle landing."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED|TEMPLATE_FLAG_SPAWN_GUARANTEED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned/landing_zone.dmm")

/area/konyang_landing_zone/command_center_abandoned//Need to differentiate from the normal landing zone area, otherwise this messes stuff up
	name = "SCC Expedition Command Center"
	requires_power = TRUE
	area_flags =  AREA_FLAG_INDESTRUCTIBLE_TURFS

/area/konyang_landing_zone/command_center_abandoned/reactor
	name = "SCC Expedition Command Center Reactor"

/area/konyang_landing_zone/command_center_abandoned/garage
	name = "SCC Expedition Command Center Garage"

/area/konyang_landing_zone/command_center_abandoned/living
	name = "SCC Expedition Command Center Living Area"

/area/konyang_landing_zone/command_center_abandoned/greenhouse
	name = "SCC Expedition Command Center Greenhouse"

/area/konyang_landing_zone/command_center_abandoned/landing_pads
	name = "SCC Expedition Command Center Landing Pads"
