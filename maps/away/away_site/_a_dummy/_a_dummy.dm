
// ---- map template/archetype

/datum/map_template/ruin/away_site/dummy
	name = "dummy"
	description = "dummy."
	id = "dummy"
	prefix = "away_site/_a_dummy/"
	suffix = "_a_dummy.dmm"
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	unit_test_groups = list(3)

/singleton/submap_archetype/dummy
	map = "dummy"
	descriptor = "dummy."

// ---- sector

/obj/effect/overmap/visitable/sector/dummy
	name = "dummy"
	desc = "\
		dummy.\
		"
	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_ships.dmi'
	icon_state = "asteroid_cluster"
	color = "#bd8159"

	designer = "Unknown"
	volume = "82 meters length, 81 meters beam/width, 45 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "dummy"

	//initial_generic_waypoints = list()
