/datum/map_template/ruin/away_site/unathi_pirate_izharshan
	name = "empty sector"
	id = "unathi_pirate"
	description = "An empty sector."
	suffix = "away_site/unathi_pirate/unathi_pirate_izharshan.dmm"
	spawn_weight = 1
	spawn_cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/unathi_pirate_izharshan)
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ)
	//sectors = list(SECTOR_NRRAHRAHUL, SECTOR_BADLANDS, SECTOR_GAKAL, SECTOR_UUEOAESA)

/decl/submap_archetype/unathi_pirate_izharshan
	map = "empty sector"
	descriptor = "An empty sector."

/obj/effect/overmap/visitable/sector/unathi_pirate_izharshan
	name = "empty sector"
	desc = "An empty sector."
	icon_state = null //this away site only exists so the shuttle can spawn and doesn't need to be seen. Invisible var causes issues when used for this purpose.
	initial_restricted_waypoints = list(
		"Izharshan Freighter" = list("nav_start_unathi_pirate_izharshan")
	)

/area/shuttle/unathi_pirate_izharshan
	name = "Izharshan Freighter"
	requires_power = TRUE

/area/shuttle/unathi_pirate_izharshan/operations
	name = "Izharshan Freighter Operations"
	icon_state = "engineering_workshop"

/area/shuttle/unathi_pirate_izharshan/helm
	name = "Izharshan Freighter Helm"
	icon_state = "bridge"

/area/shuttle/unathi_pirate_izharshan/dorms
	name = "Izharshan Freighter Dorms"
	icon_state = "Sleep"

/obj/item/storage/secure/safe/unathi_pirate_izharshan
	starts_with = list(
	/obj/item/ship_ammunition/bruiser/he = 1,
	/obj/item/clothing/accessory/badge/passport/dominia = 1,
	/obj/item/clothing/accessory/badge/passport/coc = 1,
	/obj/item/spacecash/bundle{worth = 5000} = 1
	)

/obj/machinery/vending/boozeomat/unathi_pirate
	products = list(
		/obj/item/reagent_containers/food/drinks/shaker = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 4,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/pint = 4,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/mug = 4,
		/obj/item/reagent_containers/food/drinks/ice = 2,
		/obj/item/reagent_containers/food/drinks/carton/orangejuice = 2,
		/obj/item/reagent_containers/food/drinks/carton/lemonjuice = 2,
		/obj/item/reagent_containers/food/drinks/carton/limejuice = 2,
		/obj/item/reagent_containers/food/drinks/bottle/grenadine = 2,
		/obj/item/reagent_containers/food/drinks/bottle/pulque = 2,
		/obj/item/reagent_containers/food/condiment/small/packet/capsaicin = 4,
		/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind = 2,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 2,
		/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice = 10,
		/obj/item/reagent_containers/food/drinks/cans/threetowns = 10,
		/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine = 10)
	req_access = list(210)
	restock_items = 1

//shuttle time :)

/obj/effect/overmap/visitable/ship/landable/unathi_pirate_izharshan
	name = "Izharshan freighter"
	class = "ISV"
	shuttle = "Izharshan Freighter"
	designation = "Anvil"
	desc = "Though the sensors identify the engine signature and overall rough profile of the signal as being from an older Hegemonic Brick-class civilian freight shuttle, many modifications are detected, such as possible anti-ship weaponry onboard."
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 7500 //This truck is too damn big
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH

/obj/machinery/computer/shuttle_control/explore/unathi_pirate_izharshan
	name = "shuttle control console"
	shuttle_tag = "Izharshan Freighter"

/datum/shuttle/autodock/overmap/unathi_pirate_izharshan
	name = "Izharshan Freighter"
	move_time = 35
	range = 2
	fuel_consumption = 5
	shuttle_area = list(/area/shuttle/unathi_pirate_izharshan/operations, /area/shuttle/unathi_pirate_izharshan/dorms, /area/shuttle/unathi_pirate_izharshan/helm)
	current_location = "nav_start_unathi_pirate_izharshan"
	dock_target = "unathi_pirate_izharshan"
	landmark_transition = "nav_transit_unathi_pirate_izharshan"
	logging_home_tag = "nav_start_unathi_pirate_izharshan"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/unathi_pirate_izharshan/start
	name = "Empty Space"
	landmark_tag = "nav_start_unathi_pirate_izharshan"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/unathi_pirate_izharshan/transit
	name = "In transit"
	landmark_tag = "nav_transit_unathi_pirate_izharshan"
	base_turf = /turf/space