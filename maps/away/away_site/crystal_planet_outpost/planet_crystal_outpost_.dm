/datum/map_template/ruin/away_site/crystal_planet_outpost
	name = "Crystal Planet Outpost"
	id = "crystal_planet_outpost"
	spawn_cost = 1
	spawn_weight = 1
	description = "An arctic planet and an alien underground surface."
	suffixes = list("away_site/crystal_planet_outpost/crystal_planet_outpost.dmm")
	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(SECTOR_BURZSIA, SECTOR_HANEUNIM) //it's a whole planet, shouldn't have it in predefined sectors
	unit_test_groups = list(1)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/crystal_planet_outpost
	map = "crystal_planet_outpost"
	descriptor = "An arctic planet and an alien underground surface."

/obj/effect/overmap/visitable/sector/crystal_planet_outpost
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

// /obj/effect/overmap/visitable/sector/crystal_planet_outpost/New(nloc, max_x, max_y)
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
