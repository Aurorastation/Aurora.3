
// map_template and archetype

/datum/map_template/ruin/away_site/quarantined_outpost
	name = "quarantined outpost"
	description = "quarantined outpost."

	prefix = "away_site/quarantined_outpost/"
	suffix = "quarantined_outpost.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED // delete this
	//sectors_blacklist = list(SECTOR_BURZSIA, SECTOR_HANEUNIM)
	spawn_weight = 1
	spawn_cost = 1
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
		Caution is advised.\
		"
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost2"
	color = "#D6D9DD"

	initial_generic_waypoints = list(
		// asteroid landing marks
		"nav_quarantined_outpost_asteroid_south_1",
		"nav_quarantined_outpost_asteroid_east_1",
		"nav_quarantined_outpost_asteroid_west_1",
		"nav_quarantined_outpost_asteroid_south_2",
		"nav_quarantined_outpost_asteroid_east_2",
		"nav_quarantined_outpost_asteroid_west_2",
		// space
		"nav_quarantined_outpost_space_south_1",
		"nav_quarantined_outpost_space_south_2",
		"nav_quarantined_outpost_space_north_1",
		"nav_quarantined_outpost_space_north_2",
		"nav_quarantined_outpost_space_east_1",
		"nav_quarantined_outpost_space_east_2",
		"nav_quarantined_outpost_space_west_1",
		"nav_quarantined_outpost_space_west_2"
	)
