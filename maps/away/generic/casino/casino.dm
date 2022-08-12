/obj/effect/overmap/visitable/ship/casino
	name = "passenger liner"
	desc = "Sensors detect an undamaged vessel without any signs of activity."
	color = "#bd6100"
	vessel_mass = 5000
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECOND
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
	designation = "IPV [pick("Fortuna","Gold Rush","Ebisu","Lucky Paw","Four Leaves")], \a [name]"
	..()

/datum/map_template/ruin/away_site/casino
	name = "Casino"
	id = "awaysite_casino"
	description = "A casino ship!"
	sectors = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL)
	spawn_weight = 1
	spawn_cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/casino_cutter)

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

/datum/shuttle/autodock/overmap/casino_cutter
	name = "Casino Cutter"
	warmup_time = 13
	move_time = 40
	shuttle_area = /area/shuttle/casino_cutter
	current_location = "nav_casino_hangar"
	landmark_transition = "nav_casino_transit"
	fuel_consumption = 0.5//it's small
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
	icon = 'maps/away/generic/casino/casino_sprites.dmi'
	icon_state = "bj_left"
	density = FALSE
	anchored = TRUE

/obj/structure/casino/bj_table/bj_right
	icon_state = "bj_right"

/obj/structure/casino/craps
	name = "craps table"
	desc = "Craps table: roll dice!"
	icon = 'maps/away/generic/casino/casino_sprites.dmi'
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
