/datum/map_template/ruin/away_site/unathi_pirate_izharshan
	name = "Izharshan Shuttle"
	id = "unathi_pirate"
	description = "A shuttle belonging to the Unahi pirates of Izharshan's Raiders."

	prefix = "ships/unathi_pirate/izharshan/"
	suffix = "unathi_pirate_izharshan.dmm"

	spawn_weight = 1
	ship_cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/unathi_pirate_izharshan)
	sectors = list(SECTOR_NRRAHRAHUL, SECTOR_BADLANDS, SECTOR_GAKAL, SECTOR_UUEOAESA)
	spawn_weight_sector_dependent = list(SECTOR_UUEOAESA = 0.5, SECTOR_NRRAHRAHUL = 0.5) //Rarer due to actual government/military presence

	unit_test_groups = list(1)

/singleton/submap_archetype/unathi_pirate_izharshan
	map = "Izharshan Shuttle"
	descriptor = "A shuttle belonging to the Unahi pirates of Izharshan's Raiders."

/area/shuttle/unathi_pirate_izharshan
	name = "Izharshan Freighter"
	requires_power = TRUE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

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
	/obj/item/spacecash/c1000 = 1,
	/obj/item/spacecash/c200 = 1,
	/obj/item/spacecash/c20 = 1
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
	restock_items = TRUE

//shuttle time :)

/obj/effect/overmap/visitable/ship/landable/unathi_pirate_izharshan
	name = "Izharshan freighter"
	class = "ISV"
	shuttle = "Izharshan Freighter"
	designation = "Anvil"
	desc = "Though the sensors identify the engine signature and overall rough profile of the signal as being from an older Hegemonic Brick-class civilian freight shuttle, many modifications are detected, such as possible anti-ship weaponry onboard."
	icon_state = "generic"
	moving_state = "generic_moving"
	colors = list("#95de9c")
	scanimage = "unathi_freighter1.png"
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 7500 //This truck is too damn big
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	comms_name = "modified"
	use_mapped_z_levels = TRUE
	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/landable/unathi_pirate_izharshan/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "unathi_freighter1")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/machinery/computer/shuttle_control/explore/unathi_pirate_izharshan
	name = "shuttle control console"
	shuttle_tag = "Izharshan Freighter"

/datum/shuttle/autodock/overmap/unathi_pirate_izharshan
	name = "Izharshan Freighter"
	move_time = 35
	range = 2
	fuel_consumption = 6
	shuttle_area = list(/area/shuttle/unathi_pirate_izharshan/operations, /area/shuttle/unathi_pirate_izharshan/dorms, /area/shuttle/unathi_pirate_izharshan/helm)
	current_location = "nav_izharshan_space"
	dock_target = "unathi_pirate_izharshan"
	landmark_transition = "nav_izharshan_transit"
	logging_home_tag = "nav_izharshan_space"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/ship/unathi_pirate_izharshan
	shuttle_name = "Izharshan Freighter"
	landmark_tag = "nav_izharshan_space"

/obj/effect/shuttle_landmark/izharshan_transit
	name = "In transit"
	landmark_tag = "nav_izharshan_transit"
	base_turf = /turf/space
