/datum/map_template/ruin/away_site/ancient_skrell_ship
	name = "Ancient Skrell Ship"
	description = "Ancient Skrell Ship."
	id = "ancient_skrell_ship"

	prefix = "away_site/ancient_skrell_ship/"
	suffix = "ancient_skrell_ship.dmm"

	traits = list(
		// Deck one
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Deck two
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	unit_test_groups = list(1)

/obj/effect/overmap/visitable/sector/ancient_skrell_ship
	name = "Ancient Skrell Ship"
	desc = "placeholder."
	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_ships.dmi'
	icon_state = "asteroid_cluster"
	color = "#a186bb"
	designer = "Unknown"
	volume = "placeholder."
	weapons = "Not apparent"

	initial_generic_waypoints = list(
	)

