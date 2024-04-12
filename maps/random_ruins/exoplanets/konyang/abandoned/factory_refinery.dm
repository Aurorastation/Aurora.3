/datum/map_template/ruin/exoplanet/konyang_factory_refinery
	name = "Abandoned Refinery"
	id = "konyang_factory_refinery"
	description = "A decrepit, abandoned manufacturing complex. This one was once a churning mechanism to refine subterranean minerals."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/abandoned/factory_refinery.dmm")

/area/konyang/refinery
	name = "Planetary Material Refinery"
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang
	sound_environment = SOUND_ENVIRONMENT_HANGAR
