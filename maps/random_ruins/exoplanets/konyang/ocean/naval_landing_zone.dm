//Functional copy of the standard landing zone with a different exterior to fit the ocean biome
/datum/map_template/ruin/exoplanet/konyang_naval_landing_zone
	name = "Oceanic Command Center Landing Zone"
	id = "konyang_ocean_landing_zone"
	description = "An artificial orbitally-dropped prefab of floating steel established for shuttle landing."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED|TEMPLATE_FLAG_SPAWN_GUARANTEED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/ocean/naval_landing_zone.dmm")
