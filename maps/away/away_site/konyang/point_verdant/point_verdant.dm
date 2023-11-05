/datum/map_template/ruin/away_site/point_verdant
	name = "Konyang - Point Verdant Spaceport"
	id = "point_verdant"
	description = "A landing zone designated by local authorities within an SCC-affiliated spaceport. Accommodations have been made to ensure full visitation of any open facilities present."
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("away_site/konyang/point_verdant/point_verdant-1.dmm","away_site/konyang/point_verdant/point_verdant-2.dmm","away_site/konyang/point_verdant/point_verdant-3.dmm")
	spawn_weight = 1
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

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
		"nav_point_verdant_waterdock_01",
		"nav_point_verdant_waterdock_02",
		"nav_point_verdant_waterdock_03",
		"nav_point_verdant_waterdock_04",
		"nav_point_verdant_waterdock_05",
		"nav_point_verdant_waterdock_06",
		"nav_point_verdant_waterdock_07",
		"nav_point_verdant_waterdock_08",
		"nav_point_verdant_waterdock_09",
		"nav_point_verdant_waterdock_10",
		"nav_point_verdant_waterdock_11",
		"nav_point_verdant_waterdock_12",
		"nav_point_verdant_waterdock_13",
		"nav_point_verdant_waterdock_14",
	)
	initial_restricted_waypoints = list(
		"Intrepid" = list("nav_point_verdant_spaceport_intrepid"),
		"Spark" = list("nav_point_verdant_spaceport_spark"),
		"Canary" = list("nav_point_verdant_spaceport_canary", "nav_point_verdant_corporate_canary"),
	)
