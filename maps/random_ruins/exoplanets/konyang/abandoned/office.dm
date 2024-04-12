/datum/map_template/ruin/exoplanet/konyang_office
	name = "Abandoned Office"
	id = "factory_robotics"
	description = "An aged bureaucratic center for paperwork and business."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned/office.dmm")

/area/konyang/office
	name = "Konyang Office"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	sound_environment = SOUND_ENVIRONMENT_ROOM
