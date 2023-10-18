/datum/map_template/ruin/away_site/point_verdant
	name = "Konyang - Point Verdant Spaceport"
	id = "point_verdant"
	description = "A landing zone designated by local authorities within an SCC-affiliated spaceport. Accommodations have been made to ensure full visitation of any open facilities present."
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("away_site/konyang/point_verdant/point_verdant-1.dmm","away_site/konyang/point_verdant/point_verdant-2.dmm","away_site/konyang/point_verdant/point_verdant-3.dmm")
	spawn_weight = 1
	spawn_cost = 1

	unit_test_groups = list(2)

/singleton/submap_archetype/point_verdant
	map = "point_verdant"
	descriptor = "A landing zone within Point Verdant city limits."

/obj/effect/overmap/visitable/sector/point_verdant
	name = "Konyang - Point Verdant Spaceport"
	desc = "A landing zone designated by local authorities within an SCC-affiliated spaceport. Accommodations have been made to ensure full visitation of any open facilities present."
	icon_state = "poi"
	scanimage = "konyang_point_verdant.png"
	place_near_main = list(0,0)
	landing_site = TRUE
	alignment = "Coalition of Colonies"
	requires_contact = FALSE
	instant_contact = TRUE

	initial_generic_waypoints = list(
		"nav_point_verdant_1",
		"nav_point_verdant_2",
		"nav_point_verdant_3",
		"nav_point_verdant_4"
	)

/obj/effect/shuttle_landmark/point_verdant/nav1
	name = "Point Verdant Navpoint #1"
	landmark_tag = "nav_point_verdant_1"

/obj/effect/shuttle_landmark/point_verdant/nav2
	name = "Point Verdant Navpoint #2"
	landmark_tag = "nav_point_verdant_2"

/obj/effect/shuttle_landmark/point_verdant/nav3
	name = "Point Verdant Spaceport Pad A"
	landmark_tag = "nav_point_verdant_3"

/obj/effect/shuttle_landmark/point_verdant/nav4
	name = "Point Verdant Spaceport Pad B"
	landmark_tag = "nav_point_verdant_4"
