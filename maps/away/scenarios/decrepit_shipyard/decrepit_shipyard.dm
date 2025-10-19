/datum/map_template/ruin/away_site/decrepit_shipyard
	name = "Decrepit Shipyard"
	description = "Decrepit Shipyard."
	id = "decrepit_shipyard"

	prefix = "scenarios/decrepit_shipyard/"
	suffix = "decrepit_shipyard.dmm"

	traits = list(
		// Deck 1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Deck 2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	spawn_cost = 1
	spawn_weight = 0
	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	unit_test_groups = list(1)

/singleton/submap_archetype/decrepit_shipyard
	map = "Decrepit Shipyard"
	descriptor = "Decrepit Shipyard."

/obj/effect/overmap/visitable/sector/decrepit_shipyard
	name = "Deep-space Shipyard Outpost #117-B"
	desc = "\
		Industrial shipyard outpost, owned by a group of independent businesses. Scanners detect it to be pressurized. \
		Records indicate it to be a shipyard, able to build small vessels but mostly providing repair/maintenance services for the spacefarers who can afford the fee. \
		"
	static_vessel = TRUE
	generic_object = FALSE
	comms_support = TRUE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "waystation"
	color = "#afa181"
	designer = "Unknown"
	volume = "yuh" // change this after the map is complete
	weapons = "Not apparent"
	sizeclass = "Industrial Outpost"

	initial_generic_waypoints = list(
		// docks
	)

