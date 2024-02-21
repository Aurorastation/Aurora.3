/datum/map_template/ruin/away_site/yacht
	name = "Yacht"
	id = "awaysite_yacht"
	description = "Tiny movable ship with spiders."
	suffixes = list("ships/yacht/yacht.dmm")
	spawn_cost = 0.5
	spawn_weight = 0.5
	sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL, SECTOR_UUEOAESA)

	unit_test_groups = list(3)

/obj/effect/overmap/visitable/ship/yacht
	name = "private yacht"
	desc = "Sensor array is detecting a private pleasure yacht with unknown lifeforms dectected within. The design appears to be from the Idris Incorporated 'Starfarer' line."
	class = "IPV"
	icon_state = "generic"
	moving_state = "generic_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	designer = "Idris Incorporated"
	volume = "27 meters length, 19 meters beam/width, 11 meters vertical height"
	sizeclass = "Starfarer-line Pleasure Yacht"
	shiptype = "Private passenger utility, long-distance travel case"
	vessel_mass = 3000
	max_speed = 1/(2 SECONDS)
	initial_generic_waypoints = list(
		"nav_yacht_1",
		"nav_yacht_2",
		"nav_yacht_3",
		"nav_yacht_antag"
	)

/obj/effect/overmap/visitable/ship/yacht/New()
	designation = "[pick("Razorshark", "Torch", "Lighting", "Pequod", "Anansi")]"
	..()

/obj/effect/shuttle_landmark/nav_yacht/nav1
	name = "Small Yacht Navpoint #1"
	landmark_tag = "nav_yacht_1"

/obj/effect/shuttle_landmark/nav_yacht/nav2
	name = "Small Yacht Navpoint #2"
	landmark_tag = "nav_yacht_2"

/obj/effect/shuttle_landmark/nav_yacht/nav3
	name = "Small Yacht Navpoint #3"
	landmark_tag = "nav_yacht_3"

/obj/effect/shuttle_landmark/nav_yacht/nav4
	name = "Small Yacht Navpoint #4"
	landmark_tag = "nav_yacht_antag"
