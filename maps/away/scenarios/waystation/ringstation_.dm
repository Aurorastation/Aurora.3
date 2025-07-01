// --------------------------------------------------- template

/datum/map_template/ruin/away_site/ringstation
	name = "Waystation"
	description = "A waystation in an otherwise uninhabited region of space."
	prefix = "scenarios/ringstation/"
	suffix = "ringstation.dmm"

	id = "ringstation"

	traits = list(
		// Maintenance Level
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Main Level
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = TRUE),
		// Roof Level
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	sectors = list(
		ALL_DANGEROUS_SECTORS,
		ALL_VOID_SECTORS,
		ALL_GENERIC_SECTORS,
		SECTOR_CORP_ZONE,
		SECTOR_VALLEY_HALE,
		SECTOR_BADLANDS,
		SECTOR_COALITION,
		SECTOR_WEEPING_STARS,
		SECTOR_ARUSHA,
		SECTOR_LIBERTYS_CRADLE)
	sectors_blacklist = list(ALL_SPECIFIC_SECTORS) // It's a Waystation for between (well-)habited sectors.
	spawn_weight = 100
	spawn_cost = 0

	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/lift/ringstation)
	unit_test_groups = list(1)

	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/ringstation
	map = "Waystation"
	descriptor = "A waystation in an otherwise uninhabited region of space."

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/ringstation
	name = "K-2458 Waystation"
	desc = "\
		An <b>independent</b>, <i>Einstein Engines Kanzhong-2458 Civilian Waystation</i> with a ring-like design; medium-sized.<br>\
		A long list of up-to-date registration for numerous services is attached to the scan, including: refuelling, short-term stay,\
		permits from any state that claims this sector, and the waystation's registration as an <i>Orion Express package collection point</i>.<br>\
		The waystation appears active and pressurised, with multiple lifesigns present. Multiple docking ports and a hangar are lit up with green hull beacons."
	designer = "Einstein Engines"
	volume = "79 meters diameter, 248 meters circumference, 27 meters vertical height"
	weapons = "None"
	sizeclass = "Medium-sized Spacestation"

	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "waystation"
	color = "#f7e3e3"
	static_vessel = TRUE
	comms_support = TRUE

	initial_generic_waypoints = list(
		// Distant Exterior Points
		"nav_ringstation_shuttle_exterior_north_z1",
		"nav_ringstation_shuttle_exterior_east_z1",
		"nav_ringstation_shuttle_exterior_south_z1",
		"nav_ringstation_shuttle_exterior_west_z1",
		"nav_ringstation_shuttle_exterior_north_z2",
		"nav_ringstation_shuttle_exterior_east_z2",
		"nav_ringstation_shuttle_exterior_south_z2",
		"nav_ringstation_shuttle_exterior_west_z2",
		"nav_ringstation_shuttle_exterior_north_z3",
		"nav_ringstation_shuttle_exterior_east_z3",
		"nav_ringstation_shuttle_exterior_south_z3",
		"nav_ringstation_shuttle_exterior_west_z3",
		// Docks
		"nav_ringstation_shuttle_dock_north_a",
		"nav_ringstation_shuttle_dock_north_b",
		"nav_ringstation_shuttle_dock_south_a",
		"nav_ringstation_shuttle_dock_south_b",
		"nav_ringstation_shuttle_dock_west_a",
		"nav_ringstation_shuttle_dock_west_b",
		"nav_ringstation_shuttle_dock_west_c",
		"nav_ringstation_shuttle_dock_west_d",
		// Hangar
		"nav_ringstation_shuttle_hangar"
	)
