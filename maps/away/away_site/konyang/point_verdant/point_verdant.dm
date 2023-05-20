/datum/map_template/ruin/away_site/point_verdant
	name = "Konyang - Point Verdant Spaceport"
	id = "point_verdant"
	description = "WIP"
	sectors = list(SECTOR_TAU_CETI)
	suffixes = list("away_site/konyang/point_verdant/point_verdant.dmm")
	spawn_weight = 1
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/point_verdant
	map = "point_verdant"
	descriptor = "WIP"

/obj/effect/overmap/visitable/sector/point_verdant
	name = "Konyang - Point Verdant Spaceport"
	desc = "WIP for point verdant landing site."
	icon_state = "object"

	initial_generic_waypoints = list(
		"nav_point_verdant_1",
		"nav_point_verdant_2"
	)

/obj/effect/shuttle_landmark/point_verdant/nav1
	name = "Point Verdant Navpoint #1"
	landmark_tag = "nav_point_verdant_1"

/obj/effect/shuttle_landmark/point_verdant/nav2
	name = "Point Verdant Navpoint #2"
	landmark_tag = "nav_point_verdant_2"
