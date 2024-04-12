/datum/map_template/ruin/exoplanet/konyang_garage
	name = "Abandoned Garage"
	id = "konyang_garage"
	description = "A caved-in, barely workable abandoned garage for old machinery."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned/garage.dmm")

/area/konyang/garage
	name = "Konyang Garage"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	sound_environment = SOUND_ENVIRONMENT_HANGAR
