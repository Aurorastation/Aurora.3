/datum/map_template/ruin/away_site/cult_base
	name = "Cult Ship"
	description = "Cult Ship."
	id = "cult_base"
	suffixes = list("away_site/cult_base/cult_base.dmm")
	spawn_cost = 1
	spawn_weight = 0.5
	sectors = list(ALL_POSSIBLE_SECTORS)
	unit_test_groups = list(1)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/cult_base//Arbitrary duplicates of the above name/desc
	map = "Cult Ship"
	descriptor = "Cult Ship."

/obj/effect/overmap/visitable/sector/cult_base
	name = "Cult Ship"
	desc = "Industrial propellant depot of unknown designation or origin. Scanners detect it to be mostly cold, likely no movement or life inside, although appears to be pressurized."
	icon_state = "outpost"
	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost2"
	color = "#bbb186"
	designer = "Unknown"
	volume = "92 meters length, 99 meters beam/width, 27 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Industrial Station"

	initial_generic_waypoints = list(
		// docks
		"nav_cult_base_dock_north_east",
		"nav_cult_base_dock_north_west",
		"nav_cult_base_dock_west",
		"nav_cult_base_dock_east_north",
		"nav_cult_base_dock_east_south",
		"nav_cult_base_dock_south_east",
		"nav_cult_base_dock_south_mid",
		"nav_cult_base_dock_south_west",
		// catwalks
		"nav_cult_base_catwalk_north",
		"nav_cult_base_catwalk_west",
		"nav_cult_base_catwalk_south_1",
		"nav_cult_base_catwalk_south_2",
		"nav_cult_base_catwalk_south_3",
		"nav_cult_base_catwalk_south_4",
		// space
		"nav_cult_base_space_south_west",
		"nav_cult_base_space_south_east",
		"nav_cult_base_space_north_west",
		"nav_cult_base_space_north_east",
	)

