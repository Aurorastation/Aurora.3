/datum/map_template/ruin/away_site/casino
	name = "Casino"
	description = "A casino ship!"
	suffixes = list("ships/casino/casino.dmm")
	sectors = list(ALL_TAU_CETI_SECTORS, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL, SECTOR_UUEOAESA, ALL_COALITION_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "awaysite_casino"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/casino_cutter)

	unit_test_groups = list(2)

/singleton/submap_archetype/casino
	map = "Casino"
	descriptor = "A casino ship!"

//Ship
/obj/effect/overmap/visitable/ship/casino
	name = "passenger liner"
	class = "ICV"
	desc = "A spaceborne casino slash passenger liner of an uncertain design. It's hardly nimble, quite defenceless and is likely far from any safe transit routes. Sensors detect that it is undamaged and without any signs of activity within."
	icon_state = "generic"
	moving_state = "generic_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	volume = "57 meters length, 35 meters beam/width, 16 meters vertical height"
	sizeclass = "Passenger Liner"
	shiptype = "Long-distance freight and leisure transit"
	vessel_mass = 15000
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECOND
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list(
		"nav_casino_1",
		"nav_casino_2",
		"nav_casino_3",
		"nav_casino_4",
		"nav_casino_antag",
		"nav_casino_hangar",
	)
	initial_restricted_waypoints = list(
		"Casino Cutter" = list("nav_casino_hangar"),
	)

/obj/effect/overmap/visitable/ship/casino/New()
	designation = "[pick("Lady Luck","Gold Rush","Fortune's Favoured","Four Leaves", "Over Easy")]"
	..()

//Landmarks

/obj/effect/shuttle_landmark/nav_casino
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/nav_casino/nav1
	name = "Casino Ship Navpoint #1"
	landmark_tag = "nav_casino_1"

/obj/effect/shuttle_landmark/nav_casino/nav2
	name = "Casino Ship Navpoint #2"
	landmark_tag = "nav_casino_2"

/obj/effect/shuttle_landmark/nav_casino/nav3
	name = "Casino Ship Navpoint #3"
	landmark_tag = "nav_casino_3"

/obj/effect/shuttle_landmark/nav_casino/nav4
	name = "Casino Ship Navpoint #4"
	landmark_tag = "nav_casino_4"

/obj/effect/shuttle_landmark/nav_casino/nav5
	name = "Casino Ship Navpoint #5"
	landmark_tag = "nav_casino_antag"

/obj/effect/shuttle_landmark/nav_casino/nav6
	name = "Casino Ship Navpoint #6"
	landmark_tag = "nav_casino_6"

//A very small shuttle, it can't move independently on the overmap and can only land near where its mothership goes to. If we ever want that to change though, gave it the settings for it.
/obj/effect/overmap/visitable/ship/landable/casino_cutter
	name = "Casino Cutter"
	desc = "A generic small, boxy transport shuttle. It looks like a brick and it handles like one too."
	shuttle = "Casino Cutter"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	max_speed = 1/(3 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000 //Hard to move
	fore_dir = WEST
	vessel_size = SHIP_SIZE_TINY

/datum/shuttle/autodock/overmap/casino_cutter
	name = "Casino Cutter"
	warmup_time = 13
	move_time = 30
	shuttle_area = /area/shuttle/casino_cutter
	current_location = "nav_casino_hangar"
	landmark_transition = "nav_casino_transit"
	fuel_consumption = 2
	logging_home_tag = "nav_casino_hangar"
	range = 1
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/nav_casino/cutter_hangar
	name = "Casino Hangar"
	landmark_tag = "nav_casino_hangar"
	base_area = /area/casino/casino_hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/nav_casino/cutter_transit
	name = "In transit"
	landmark_tag = "nav_casino_transit"

/obj/machinery/computer/shuttle_control/explore/casino_cutter
	name = "cutter control console"
	shuttle_tag = "Casino Cutter"

/obj/structure/casino/bj_table
	name = "blackjack table"
	desc = "This is a blackjack table. "
	icon = 'maps/away/ships/casino/casino_sprites.dmi'
	icon_state = "bj_left"
	density = FALSE
	anchored = TRUE

/obj/structure/casino/bj_table/bj_right
	icon_state = "bj_right"

/obj/structure/casino/craps
	name = "craps table"
	desc = "Craps table: roll dice!"
	icon = 'maps/away/ships/casino/casino_sprites.dmi'
	icon_state = "craps_top"
	density = FALSE
	anchored = TRUE

/obj/structure/casino/craps/craps_down
	icon_state = "craps_down"

//========================used bullet casings=======================
/obj/item/ammo_casing/rifle/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)


/obj/item/ammo_casing/pistol/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/ammo_casing/pistol/magnum/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
