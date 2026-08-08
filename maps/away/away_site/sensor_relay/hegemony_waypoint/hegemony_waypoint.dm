/datum/map_template/ruin/away_site/hegemony_waypoint
	name = "Navigation Buoy Gamma"
	description = "This is a simple navigation buoy of nondescript qualities. Sensors indicate \
		pressurised compartments and complex life support systems."
	prefix = "away_site/sensor_relay/hegemony_waypoint/"
	suffix = "hegemony_waypoint.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	id = "hegemony_waypoint"

	unit_test_groups = list(1)

/singleton/submap_archetype/hegemony_waypoint
	map = "Hegemony Waypoint"
	descriptor = "A hegemony waypoint."

/obj/effect/overmap/visitable/ship/stationary/hegemony_waypoint
	name = "Navigation Buoy Gamma"
	class = "OES"
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "waypoint"
	color = COLOR_PURPLE_GRAY
	desc = "This is a simple navigation buoy of nondescript qualities. Sensors indicate \
		pressurised compartments and complex life support systems."
	initial_generic_waypoints = list(
		"hegemony_waypoint_dock_n",
		"hegemony_waypoint_dock_e",
		"hegemony_waypoint_dock_w",
		"hegemony_waypoint_dock_s",
		"hegemony_waypoint_n_space",
		"hegemony_waypoint_e_space",
		"hegemony_waypoint_w_space",
		"hegemony_waypoint_s_space"
	)

// Areas
/area/hegemony_waypoint
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP
	requires_power = TRUE
	ambience = AMBIENCE_GENERIC
	base_turf = /turf/space
	icon_state = "green"

/area/hegemony_waypoint/monitoring
	name = "Navigation Buoy Gamma - Monitoring Station"

/area/hegemony_waypoint/hallway
	name = "Navigation Buoy Gamma - Central Hallway"

/area/hegemony_waypoint/kitchen
	name = "Navigation Buoy Gamma - Kitchen"

/area/hegemony_waypoint/custodial
	name = "Navigation Buoy Gamma - Laundry Chamber"

/area/hegemony_waypoint/washroom
	name = "Navigation Buoy Gamma - Washroom"

/area/hegemony_waypoint/hydroponics
	name = "Navigation Buoy Gamma - Hydroponics"

/area/hegemony_waypoint/eva
	name = "Navigation Buoy Gamma - Equipment Chamber"

/area/hegemony_waypoint/engineering
	name = "Navigation Buoy Gamma - Power Management Chamber"

/area/hegemony_waypoint/atmos
	name = "Navigation Buoy Gamma - Atmospherics Management Chamber"

/area/hegemony_waypoint/shrine
	name = "Navigation Buoy Gamma - Ritual Space"

/area/hegemony_waypoint/bunks
	name = "Navigation Buoy Gamma - Technicians Quarters"

/area/hegemony_waypoint/exterior
	name = "Navigation Buoy Gamma - Exterior"
	has_gravity = FALSE
	needs_starlight = TRUE
	requires_power = FALSE
	icon_state = "exterior"

/area/hegemony_waypoint/exterior/actor
	name = "Unknown"
	requires_power = FALSE

/area/hegemony_waypoint/shuttle
	name = "Outer Eyes Shuttle"
	requires_power = TRUE
