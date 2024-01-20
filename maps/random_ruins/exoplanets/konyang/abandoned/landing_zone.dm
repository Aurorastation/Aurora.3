//Functional copy of the standard landing zone with a different exterior to fit the abandoned biome
/datum/map_template/ruin/exoplanet/konyang_abandoned_landing_zone
	name = "SCC Expedition Command Center Landing Zone"
	id = "konyang_abandoned_landing_zone"
	description = "An artificial orbitally-dropped prefab of flattened ground established for shuttle landing."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED|TEMPLATE_FLAG_SPAWN_GUARANTEED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned/landing_zone.dmm")
