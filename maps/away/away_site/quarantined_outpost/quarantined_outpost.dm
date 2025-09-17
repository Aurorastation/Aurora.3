
// map_template and archetype

/datum/map_template/ruin/away_site/quarantined_outpost
	name = "quarantined outpost"
	description = "quarantined outpost."

	prefix = "away_site/quarantined_outpost/"
	suffix = "quarantined_outpost.dmm"

	sectors = list(ALL_CRESCENT_EXPANSE_SECTORS, ALL_VOID_SECTORS, SECTOR_WEEPING_STARS, SECTOR_BADLANDS, SECTOR_VALLEY_HALE)
	spawn_weight = 1
	spawn_cost = 2 // chonky ruin
	id = "quarantined_outpost"

	unit_test_groups = list(1)

/singleton/submap_archetype/quarantined_outpost
	map = "quarantined outpost"
	descriptor = "quarantined outpost."

// overmap visitable

/obj/effect/overmap/visitable/sector/quarantined_outpost
	name = "Degraded Distress Signal"
	desc = "\
		Scans reveal a facility carved inside a large asteroid, not registered in the current starmap. Systems indicate minimal power activity. \
		Handshake protocols are unresponsive. Failed to communicate with docking hangar subsystems. \
		Outpost transponders are connected to an auxiliary power source and are transmitting a corrupted distress signal, details unknown. \
		The facility has been under quarantine protocols for \[unknown\] amount of time. \
		Multiple unidentified life forms are detected within. \
		"

	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost2"
	color = "#D6D9DD"

	initial_generic_waypoints = list(
		// asteroid landing marks
		"nav_quarantined_outpost_asteroid_1a",
		"nav_quarantined_outpost_asteroid_1b",
		"nav_quarantined_outpost_asteroid_1c",
		"nav_quarantined_outpost_asteroid_1d",
		"nav_quarantined_outpost_asteroid_2a",
		"nav_quarantined_outpost_asteroid_2b",
		"nav_quarantined_outpost_asteroid_2c",
		"nav_quarantined_outpost_asteroid_2d",
		// space
		"nav_quarantined_outpost_space_1a",
		"nav_quarantined_outpost_space_1b",
		"nav_quarantined_outpost_space_1c",
		"nav_quarantined_outpost_space_1d",
		"nav_quarantined_outpost_space_2a",
		"nav_quarantined_outpost_space_2b",
		"nav_quarantined_outpost_space_2c",
		"nav_quarantined_outpost_space_2d"
	)
