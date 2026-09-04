// --------------------------------------------------- template

/datum/map_template/ruin/away_site/scc_scout_ship
	name = "Rotunnkc Compact Corvette"
	description = "A more refined variant of popular diona hulls such as the Sunspear which is often employed by the Rotunnkc Compact, this Variant known as the Starbident for it's jagged protrusions being dual and often is found in twins or triplets."

	prefix = "ships/hieropatrol/"
	suffix = "HIEROPATROL.dmm"

	sectors = list(ALL_CRESCENT_EXPANSE_SECTORS, SECTOR_ARUSHA) // Please expand when more closer to hierotheria sectors are added in order to make this ship more wide-reaching
	sectors_blacklist = list(LEMURIAN_SEA_SECTORS) // Hierotheria would never have any reason to go all the way over here
	spawn_weight = 3 // Hierotheria holds strong weight in these sectors due to being close to them, it makes sense they would be more likely to spawn, if their sectors are increased or lore developments change it, this can be lowered accordingly
	ship_cost = 1
	spawn_weight_sector_dependent = list(SECTOR_ARUSHA = 1, SECTOR_CRESCENT_EXPANSE_FAR	= 1) // Farther out, less presence here
	id = "scc_scout_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/scc_scout_shuttle)
	unit_test_groups = list(3)

// --------------------------------------------------- ship

/singleton/submap_archetype/hieropatrol
	map = "Rotunnkc Compact Corvette"
	descriptor = "A more refined variant of popular diona hulls such as the Sunspear which is often employed by the Rotunnkc Compact, this Variant known as the Starbident for it's jagged protrusions being dual and often is found in twins or triplets."

/obj/effect/overmap/visitable/ship/hieropatrol
	name = "Rotunnkc Compact Corvette"
	class = "RCV"
	desc = "A more refined variant of popular diona hulls such as the Sunspear which is often employed by the Rotunnkc Compact, this Variant known as the Starbident for it's jagged protrusions being dual and often is found in twins or triplets."

	// visual:
	icon_state = "starbicorn"
	moving_state = "starbicorn_moving"
	colors = list("#76af89", "#9af878", "#63db28", "#635a21", "#3dca0a", "#6c6340")

	// functional:
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	invisible_until_ghostrole_spawn = TRUE
	comms_support = TRUE

	// fluff:
	designer = "Commonwealth Naval Authority"
	volume = "84 meters length, 45 meters beam/width, 23 meters vertical height"
	drive = "CosmoForge Technologies Medium-Speed Warp Acceleration FTL Drive"
	propulsion = "Superheated Composite Gas Thrust"
	weapons = "Embedded flak battery and port-mounted Dual low-caliber rotary ballistic armaments"
	sizeclass = "Starbident Patrol Ship"
	shiptype = "Patrol Ship"


/obj/effect/overmap/visitable/ship/hieropatrol/New()
	designation = pick("Valliant Explorers Enforcing A Peace", "The Wave Apon A Shore", "Shells Sailing Against Hull", "", "Moisture Deficit", "Borealis", "Surface Tension", "Precipitation", "Oscillation", "Coalescence", "Double Rainbow", "Through a Cloud, Darkly", "Relative Humidity", "Evapotranspiration", "Alluvial Plain", "Dehydration", "Hydrophobia", "The Rain Formerly Known as Purple", "Lacrimosum", "Island of Ignorance", "Intertropical", "Once in a Lullaby", "A Boat Made from a Sheet of Newspaper", "Flood Control")
	..()

// --------------------------------------------------- shuttle

/obj/effect/overmap/visitable/ship/landable/hieropatrol_shuttle
	name = "Rotunnkc Compact Corvette Shuttle"
	class = "RCV"
	desc = "A tiny passenger ferry manufactured by Hephaestus Industries, the Charon-class is commonly used by the cheap, fronitersmen, and less-technologically endowned. With plenty of handrails and a cryogenic SMES for power, one can pack many people in this shuttle tightly. This one appears to be lightly crushed to fit some sort of docking port."
	shuttle = "Rotunnkc Compact Corvette Shuttle"

	// visual:
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list("#635a21", "#3dca0a", "#6c6340")

	// functional:
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 1500
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

	// fluff:
	designer = "Hephaestus Industries"
	volume = "12 meters length, 8 meters beam/width, 8 meters vertical height"
	sizeclass = "Charon Passenger Shuttle"
	shiptype = "Personal Ferry"

/obj/effect/overmap/visitable/ship/landable/hieropatrol_shuttle/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "canary")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/overmap/visitable/ship/landable/hieropatrol_shuttle/New()
	designation = pick("Adventurerous Order", "Canopydarter", "Starvine Consumer")
	..()

/obj/structure/machinery/computer/shuttle_control/explore/terminal/hieropatrol_shuttle
	shuttle_tag = /obj/effect/overmap/visitable/ship/landable/hieropatrol_shuttle

/datum/shuttle/autodock/overmap/hieropatrol_shuttle
	name = /obj/effect/overmap/visitable/ship/landable/hieropatrol_shuttle
	move_time = 20
	shuttle_area = list(/area/shuttle/hieropatrol)
	dock_target = "airlock_hieropatrol_shuttle"
	current_location = "nav_hieropatrol_shuttle_dock"
	landmark_transition = "nav_hieropatrol_shuttle_transit"
	range = 1
	fuel_consumption = 4
	logging_home_tag = "nav_hieropatrol_shuttle_dock"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/hieropatrol
	name = /obj/effect/overmap/visitable/ship/landable/hieropatrol_shuttle::shuttle
	shuttle_tag = /obj/effect/overmap/visitable/ship/landable/hieropatrol_shuttle::shuttle
	master_tag = "airlock_hieropatrol_shuttle"
	cycle_to_external_air = TRUE
