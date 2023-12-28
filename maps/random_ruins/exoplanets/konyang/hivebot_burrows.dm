/datum/map_template/ruin/exoplanet/hivebot_burrows
	name = "Hivebot Burrows"
	id = "hivebot_burrows"
	description = "A set of ravaged tunnels where hivebots burrow."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED|TEMPLATE_FLAG_SPAWN_GUARANTEED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/hivebot_burrows_1.dmm")

/area/hivebot_burrows_1
	name = "Hivebot Burrows"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang/cave
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_FOREBODING

// custom temporary
/turf/simulated/floor/exoplanet/dirt_konyang/cave/Initialize()
	. = ..()
	set_light(0, 1, null)
	footprint_color = dirt_color
	update_icon(1)

/turf/simulated/floor/exoplanet/basalt/cave/Initialize()
	. = ..()
	set_light(0, 1, null)
	footprint_color = dirt_color
	update_icon(1)

/turf/simulated/floor/exoplanet/barren/cave/Initialize()
	. = ..()
	set_light(0, 1, null)
	footprint_color = dirt_color
	update_icon(1)
