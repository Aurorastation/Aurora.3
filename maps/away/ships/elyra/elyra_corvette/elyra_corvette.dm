/datum/map_template/ruin/away_site/elyran_corvette
	name = "Elyran Corvette"
	description = "One of the first vessels from Elyra's recent military modernization efforts to enter active service, the Sahin-class has taken great strides in improved quality and survivability from previous designs and is on track to become the backbone of the Elyran Republic's border control efforts. Equipped and crewed to handle anti-piracy operations, border patrols, and even to assist with disaster relief, this vessel follows the Elyran Armed Force's doctrine of versatility and is capable of striking out on its own for weeks at a time without resupply if required."
	suffixes = list("ships/elyra/elyra_corvette/elyra_corvette.dmm")
	sectors = list(SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ)
	spawn_weight = 1
	ship_cost = 1
	id = "elyran_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/elyran_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/elyran_corvette
	map = "Elyran Corvette"
	descriptor = "One of the first vessels from Elyra's recent military modernization efforts to enter active service, the Sahin-class has taken great strides in improved quality and survivability from previous designs and is on track to become the backbone of the Elyran Republic's border control efforts. Equipped and crewed to handle anti-piracy operations, border patrols, and even to assist with disaster relief, this vessel follows the Elyran Armed Force's doctrine of versatility and is capable of striking out on its own for weeks at a time without resupply if required."

/obj/effect/overmap/visitable/ship/elyran_corvette
	name = "Elyran Corvette"
	class = "ENV"
	desc = "One of the first vessels from Elyra's recent military modernization efforts to enter active service, the Sahin-class has taken great strides in improved quality and survivability from previous designs and is on track to become the backbone of the Elyran Republic's border control efforts. Equipped and crewed to handle anti-piracy operations, border patrols, and even to assist with disaster relief, this vessel follows the Elyran Armed Force's doctrine of versatility and is capable of striking out on its own for weeks at a time without resupply if required."
	icon_state = "corvette"
	moving_state = "corvette_moving"
	colors = list("#ffae17", "#ffcd70")
	scanimage = "elyran_corvette.png"
	designer = "Jewel Aerospace, Republic of Elyra"
	volume = "52 meters length, 44 meters beam/width, 18 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual extruding fore-mounted medium caliber ballistic armament, fore obscured flight craft bay"
	sizeclass = "Sahin-class Corvette"
	shiptype = "Military patrol and combat utility"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Elyran Naval Shuttle" = list("nav_hangar_elyra")
	)

	initial_generic_waypoints = list(
		"nav_elyran_corvette_1",
		"nav_elyran_corvette_2",
		"nav_elyran_corvette_3",
		"nav_elyran_corvette_4",
		"nav_elyran_corvette_dock_port",
		"nav_elyran_corvette_dock_starboard"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/elyran_corvette/New()
	designation = "[pick("Republican", "Falcon", "Gelin", "Sphinx", "Takam", "Dandan", "Anqa", "Falak", "Uthra", "Djinn", "Roc", "Shadhavar", "Karkadann", "Sari", "Rushdie", "Al-Laylat", "Ataturk", "Republican Glory", "Pilgrimage")]"
	..()

/obj/effect/overmap/visitable/ship/elyran_corvette/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "elyran_corvette")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image


/obj/effect/shuttle_landmark/elyran_corvette/nav1
	name = "Port Navpoint"
	landmark_tag = "nav_elyran_corvette_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/elyran_corvette/nav2
	name = "Fore Navpoint"
	landmark_tag = "nav_elyran_corvette_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/elyran_corvette/nav3
	name = "Starboard Navpoint"
	landmark_tag = "nav_elyran_corvette_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/elyran_corvette/nav4
	name = "Aft Navpoint"
	landmark_tag = "nav_elyran_corvette_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/elyran_corvette/dock/port
	name = "Port Dock"
	landmark_tag = "nav_elyran_corvette_dock_port"
	docking_controller = "airlock_elyran_corvette_dock_port"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/elyran_corvette/dock/starboard
	name = "Starboard Dock"
	landmark_tag = "nav_elyran_corvette_dock_starboard"
	docking_controller = "airlock_elyran_corvette_dock_starboard"
	base_turf = /turf/space
	base_area = /area/space

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/elyran_shuttle
	name = "Elyran Naval Shuttle"
	class = "ENV"
	designation = "Himar"
	desc = "Making an efficient use of space to offer a compact yet capable transport craft for smaller vessels in the Elyran Navy, the Huriya-class is slated to replace the Elyran Navy's aging fleet of Dromedary-class light transport craft. However, due to its introduction being so recent, replacement parts are often in short supply when these crafts are damaged, proving maintenance to be more difficult and costly than its predecessor for now."
	shuttle = "Elyran Naval Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#ffae17", "#ffcd70")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Jewel Aerospace, Republic of Elyra"
	volume = "15 meters length, 7 meters beam/width, 4 meters vertical height"
	sizeclass = "Huriya-class Transport Craft"
	shiptype = "All-environment troop transport"

/obj/machinery/computer/shuttle_control/explore/elyran_shuttle
	name = "shuttle control console"
	shuttle_tag = "Elyran Naval Shuttle"
	req_access = list(ACCESS_ELYRAN_NAVAL_INFANTRY_SHIP)
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "helm"
	icon_keyboard = "security_key"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/datum/shuttle/autodock/overmap/elyran_shuttle
	name = "Elyran Naval Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/elyran_shuttle)
	current_location = "nav_hangar_elyra"
	dock_target = "airlock_elyran_shuttle"
	landmark_transition = "nav_transit_elyran_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_elyra"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/elyran_shuttle/hangar
	name = "Elyran Naval Shuttle Hangar"
	landmark_tag = "nav_hangar_elyra"
	docking_controller = "elyran_shuttle_dock"
	base_area = /area/ship/elyran_corvette/hangar
	base_turf = /turf/simulated/floor
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/elyran_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_elyran_shuttle"
	base_turf = /turf/space/transit/north

// custom stuff
// beret
/obj/item/clothing/head/beret/elyra
	name = "elyran navy beret"
	desc = "A navy blue beret bearing a golden hawk and star insignia resembling the Elyran flag. Issued to those in service of the Serene Republic of Elyra's Navy."
	icon_state = "beret_hos"
	item_state = "beret_hos"

// energy dagger
/obj/item/melee/energy/sword/knife/elyra
	name = "elyran energy dagger"
	desc = "A relatively inexpensive energy blade, branded at the hilt with the emblem of the Elyran Armed Forces."

/obj/item/melee/energy/sword/knife/elyra/activate(mob/living/user)
	..()
	icon_state = "edagger1"

// prayer rug
/obj/item/towel_flat/prayer
	name = "prayer rug"
	desc = "A simply decorated rug used in prayer."
	color = "#592720"
