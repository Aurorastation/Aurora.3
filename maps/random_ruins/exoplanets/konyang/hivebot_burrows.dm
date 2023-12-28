/datum/map_template/ruin/exoplanet/hivebot_burrows
	name = "Hivebot Burrows"
	id = "hivebot_burrows"
	description = "A set of ravaged tunnels where hivebots burrow."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/hivebot_burrows_1.dmm")

/area/hivebot_burrows
	name = "Hivebot Burrows"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/mineral
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
