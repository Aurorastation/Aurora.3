/datum/map_template/ruin/away_site/bastion_station
	name = "Bastion Station"
	description = "Bastion Defense Station."
	id = "bastion_station"

	prefix = "scenarios/bastion_station/"
	suffix = "bastion.dmm"

	spawn_cost = 1
	spawn_weight = 0 // so it does not spawn as ordinary away site
	sectors = list(ALL_POSSIBLE_SECTORS)
	unit_test_groups = list(1)

/singleton/submap_archetype/bastion_station
	map = "Bastion Defense Station"
	descriptor = "Bastion Defense Station."

/obj/effect/overmap/visitable/sector/bastion_station
	name = "Bastion Defense Station"
	desc = "\
		A Bastion military defense station, a design dating back to the Interstellar War. These stations typically served as Solarian outposts or as orbital defenses of minor colonies. \
		Shockingly, scans indicate that not only is this station still intact, it is online and there are life-forms aboard. \
		"
	static_vessel = TRUE
	generic_object = FALSE
	comms_support = TRUE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "battlestation"
	color = "#273375"
	designer = "Hephaestus Industries"
	volume = "120 meters length, 139 meters beam/width, 49 meters vertical height"
	weapons = "1 type 21 nadziak solarian coilgun, 1 goshawk heavy autocannon, and a combat hangar."
	sizeclass = "Defense Station"
// --- DONT FORGET TO CHANGE THESE BUTTERROBBER202!!!!!
	initial_generic_waypoints = list(
		// docks
		"nav_bastion_station_dock_south",
		"nav_bastion_station_dock_east",
		"nav_bastion_station_dock_west",
		"nav_bastion_station_dock_north",
		// space
		"nav_bastion_station_space_north_west",
		"nav_bastion_station_space_north_east",
		"nav_bastion_station_space_south_west",
		"nav_bastion_station_space_south_east",
	)
