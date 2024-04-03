/datum/map_template/ruin/exoplanet/konyang_factory_robotics
	name = "Abandoned Robotics Factory"
	id = "konyang_factory_robotics"
	description = "A decrepit, abandoned manufacturing complex. This one was once devoted to constructing large, vehicular exosuits."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned/factory_robotics.dmm")

/area/konyang/robotics_factory
	name = "Robotics Assembly Plant"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	sound_environment = SOUND_ENVIRONMENT_HANGAR
