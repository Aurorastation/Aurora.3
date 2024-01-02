/datum/map_template/ruin/exoplanet/konyang_swamp_4
	name = "Lakeside Grill"
	id = "konyang_swamp_4"
	description = "A large lake with a dock and a nearby camp."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED|TEMPLATE_FLAG_SPAWN_GUARANTEED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/swamp_4.dmm")

/area/konyang_swamp_4
	name = "Swamp Grill"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/mineral
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
