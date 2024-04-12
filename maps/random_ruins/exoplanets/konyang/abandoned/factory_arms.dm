/datum/map_template/ruin/exoplanet/konyang_factory_arms
	name = "Abandoned Arms Production Plant"
	id = "konyang_factory_arms"
	description = "A decrepit, abandoned manufacturing complex. This one is a forgotten private arms production plant."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned/factory_arms.dmm")

/area/konyang/arms_factory
	name = "Arms Production Plant"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	sound_environment = SOUND_ENVIRONMENT_HANGAR
