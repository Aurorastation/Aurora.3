/datum/map_template/ruin/exoplanet/konyang_house_small
	name = "Abandoned Homestead"
	id = "konyang_house_small"
	description = "An abandoned house, formerly the residence of a small family."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned/house_small.dmm")

/area/konyang/house_small
	name = "Konyang Residence"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	sound_environment = SOUND_ENVIRONMENT_LIVINGROOM
