/datum/map_template/ruin/exoplanet/gibson_resupply
	name = "New Gibson Supply Outpost"
	id = "gibson_resupply"
	description = "An outpost with some supplies at the surface of New Gibson."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_TAU_CETI)

	prefix = "new_gibson/"
	suffix = "gibson_resupply.dmm"

	unit_test_groups = list(2)

/area/gibson_resupply
	name = "New Gibson Supply Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/snow
