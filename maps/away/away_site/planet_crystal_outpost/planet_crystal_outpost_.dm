/datum/map_template/ruin/away_site/planet_crystal_outpost
	name = "Crystal Planet Outpost"
	id = "planet_crystal_outpost"
	spawn_cost = 1
	spawn_weight = 1
	description = "An arctic planet and an alien underground surface."
	suffixes = list("away_site/planet_crystal_outpost/planet_crystal_outpost.dmm")
	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(SECTOR_BURZSIA, SECTOR_HANEUNIM) //it's a whole planet, shouldn't have it in predefined sectors
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	unit_test_groups = list(1)

/singleton/submap_archetype/planet_crystal_outpost
	map = "planet_crystal_outpost"
	descriptor = "An arctic planet and an alien underground surface."

/obj/effect/overmap/visitable/sector/planet_crystal_outpost
	name = "crystal planetoid"
	desc = "\
		Sensor array detects an arctic planet with a small vessel on the planet's surface. \
		Scans further indicate strange energy emissions from below the planet's surface.\
		"
	in_space = FALSE
	icon_state = "globe2"
	initial_generic_waypoints = list(
		// "nav_blueriv_1",
		// "nav_blueriv_2",
		// "nav_blueriv_3",
		// "nav_blueriv_4"
	)

// /obj/effect/overmap/visitable/sector/planet_crystal_outpost/New(nloc, max_x, max_y)
// 	name = "[generate_planet_name()], \a [name]"
// 	..()

// /obj/effect/shuttle_landmark/nav_blueriv/nav1
// 	name = "Arctic Planet Landing Point #1"
// 	landmark_tag = "nav_blueriv_1"
// 	base_area = /area/bluespaceriver/ground

// /obj/effect/shuttle_landmark/nav_blueriv/nav2
// 	name = "Arctic Planet Landing Point #2"
// 	landmark_tag = "nav_blueriv_2"
// 	base_area = /area/bluespaceriver/ground

// /obj/effect/shuttle_landmark/nav_blueriv/nav3
// 	name = "Arctic Planet Landing Point #3"
// 	landmark_tag = "nav_blueriv_3"
// 	base_area = /area/bluespaceriver/ground

// /obj/effect/shuttle_landmark/nav_blueriv/nav4
// 	name = "Arctic Planet Navpoint #4"
// 	landmark_tag = "nav_blueriv_4"
// 	base_area = /area/bluespaceriver/ground

