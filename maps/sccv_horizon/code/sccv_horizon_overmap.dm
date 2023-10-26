/obj/effect/overmap/visitable/ship/sccv_horizon
	class = "SCCV"
	designation = "Horizon"
	desc = "A line without compare, the Venator-series consists of one vessel so far: the SCCV Horizon, the lead ship of its class. Designed to be an entirely self-sufficient general-purpose surveying ship and to carry multiple replacement crews simultaneously, the Venator is equipped with both a bluespace and a warp drive and two different engines. Defying typical cruiser dimensions, the Venator is home to a sizable residential deck below the operations deck of the ship, where the crew is housed. It also features weapon hardpoints in its prominent wing nacelles. This one's transponder identifies it, obviously, as the SCCV Horizon."
	icon_state = "venator"
	moving_state = "venator_moving"
	colors = list("#cfd4ff", "#78adf8")
	fore_dir = SOUTH
	vessel_mass = 70000
	burn_delay = 2 SECONDS
	base = TRUE

	scanimage = "horizon.png"
	designer = "Stellar Corporate Conglomerate, Vickers Shipwright Dock - Valkyrie"
	volume = "97 meters length, 161 meters beam/width, 48 meters vertical height"
	drive = "First-Gen Warp Capable, Hybrid Phoron Bluespace Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "Two extruding naval ballistic weapon mounts, unidentifiable spinal artillery mount"
	sizeclass = "Venator Class Cruiser"
	shiptype = "Prototype exploration and survey vessel"

	initial_restricted_waypoints = list(
		"Spark" = list("nav_hangar_mining"), 	//can't have random shuttles popping inside the ship
		"Intrepid" = list("nav_hangar_intrepid"),
		"Canary" = list("nav_hangar_canary")
	)

	initial_generic_waypoints = list(
		"nav_hangar_horizon_1",
		"nav_hangar_horizon_2",
		"nav_dock_horizon_1",
		"nav_dock_horizon_2",
		"nav_dock_horizon_3",
		"nav_dock_horizon_4",
		"nav_dock_horizon_5",
		"deck_one_fore_of_horizon",
		"deck_one_starboard_side",
		"deck_one_port_side",
		"deck_one_aft_of_horizon",
		"deck_one_near_starboard_propulsion",
		"deck_one_near_port_propulsion",
		"deck_two_fore_of_horizon",
		"deck_two_starboard_fore",
		"deck_two_port_fore",
		"deck_two_aft_of_horizon",
		"deck_two_port_aft",
		"deck_two_starboard_aft",
		"deck_three_fore_of_horizon",
		"deck_three_fore_starboard_of_horizon",
		"deck_three_port_fore_of_horizon",
		"deck_three_aft_of_horizon",
		"deck_three_port_aft_of_horizon"
	)

	tracked_dock_tags = list(
		"nav_hangar_mining",
		"nav_hangar_intrepid",
		"nav_hangar_canary",
		"nav_cargo_shuttle_dock",
		"nav_hangar_horizon_1",
		"nav_burglar_hangar",
		"nav_hangar_horizon_2",
		"nav_distress_blue",
		"nav_merchant_dock",
		"nav_ccia_dock",
		"nav_merc_dock",
		"nav_dock_horizon_1",
		"nav_dock_horizon_2",
		"nav_dock_horizon_3",
		"nav_dock_horizon_4",
		"nav_dock_horizon_5",
		"nav_ert_dock"
	)

/obj/effect/overmap/visitable/ship/sccv_horizon/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "horizon")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/overmap/visitable/ship/landable/intrepid
	name = "Intrepid"
	class = "SCCV"
	designation = "Intrepid"
	desc = "A standard-sized exploration shuttle manufactured by Hephaestus, the Pathfinder-class is commonly used by the corporations of the SCC. Featuring well-rounded facilities and equipment, the Pathfinder is excellent, albeit pricey, platform. This one's transponder identifies it as the SCCV Intrepid."
	shuttle = "Intrepid"
	icon_state = "intrepid"
	moving_state = "intrepid_moving"
	colors = list("#cfd4ff", "#78adf8")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "intrepid.png"
	designer = "Hephaestus Industries"
	volume = "21 meters length, 16 meters beam/width, 6 meters vertical height"
	sizeclass = "Pathfinder Exploration Shuttle"
	shiptype = "Field expeditions and private research uses"

/obj/effect/overmap/visitable/ship/landable/intrepid/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "intrepid")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/machinery/computer/shuttle_control/explore/intrepid
	name = "\improper Intrepid control console"
	shuttle_tag = "Intrepid"
	req_access = list(access_intrepid)
	density = 0
	icon = 'icons/obj/cockpit_console.dmi'
	icon_state = "right"
	icon_screen = "blue"
	icon_keyboard = null
	circuit = null

/obj/effect/overmap/visitable/ship/landable/mining_shuttle
	name = "Spark"
	class = "SCCV"
	designation = "Spark"
	desc = "A common, modestly-sized short-range shuttle manufactured by Hephaestus. Most frequently used as a mining platform, the Pickaxe-class is entirely reliant on a reasonably-sized mothership for anything but short-term functionality. This one's transponder identifies it as belonging to the Stellar Corporate Conglomerate."
	shuttle = "Spark"
	icon_state = "spark"
	moving_state = "spark_moving"
	colors = list("#cfd4ff", "#78adf8")
	scanimage = "spark.png"
	designer = "Hephaestus Industries"
	volume = "11 meters length, 9 meters beam/width, 4 meters vertical height"
	sizeclass = "Pickaxe-Class Mining Shuttle"
	shiptype = "Field survey and specialized prospecting"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/mining_shuttle/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "spark")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/machinery/computer/shuttle_control/explore/mining_shuttle
	name = "\improper Spark control console"
	shuttle_tag = "Spark"
	req_access = list(access_mining)
	density = 0
	icon = 'icons/obj/cockpit_console.dmi'
	icon_state = "right"
	icon_screen = "blue"
	icon_keyboard = null
	circuit = null

/obj/effect/overmap/visitable/ship/landable/canary
	name = "Canary"
	class = "SCCV"
	designation = "Canary"
	desc = "A high-speed scouting craft akin to a less-maneuverable aerospace fighter. The Jester-type was originally an interceptor platform produced to populate the hangars of corporate defense vessels. While outdated, the solid design has found much appeal in long-term voyages due to minimal maintenance and compact size. This one has obvious thruster upgrades from similar obsolete counterparts."
	shuttle = "Canary"
	icon_state = "canary"
	moving_state = "canary_moving"
	colors = list("#cfd4ff", "#78adf8")
	scanimage = "canary.png"
	designer = "Hephaestus Industries, NanoTrasen"
	volume = "14 meters length, 7 meters beam/width, 5 meters vertical height"
	weapons = "Extruding fore-mounted low-caliber ballistic rotary armament"
	sizeclass = "Jester-type Scout Skiff"
	shiptype = "Exploratory survey and scouting, high-speed target interception"
	max_speed = 2/(1 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 2500
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/canary/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "canary")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/machinery/computer/shuttle_control/explore/canary
	name = "\improper Canary control console"
	shuttle_tag = "Canary"
	req_access = list(access_intrepid)
	density = 0
	icon = 'icons/obj/cockpit_console.dmi'
	icon_state = "right"
	icon_screen = "blue"
	icon_keyboard = null
	circuit = null

