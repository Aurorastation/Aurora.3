/datum/map_template/ruin/away_site/tajaran_smuggler
	name = "Adhomian Freighter"
	description = "Built with reliability in mind, the Zhsram Freighter is one of the most common Adhomian designs. This vessel is cheap and has a sizeable cargo storage. It is frequently used by Tajaran traders and smugglers."
	suffixes = list("ships/tajara/taj_smuggler/tajaran_smuggler.dmm")
	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL, SECTOR_WEEPING_STARS)
	spawn_weight = 1
	ship_cost = 1
	id = "tajaran_smuggler"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tajaran_smuggler_shuttle, /datum/shuttle/autodock/overmap/tajaran_smuggler_cargo)

	unit_test_groups = list(3)

/singleton/submap_archetype/tajaran_smuggler
	map = "Adhomian Freighter"
	descriptor = "Built with reliability in mind, the Zhsram Freighter is one of the most common Adhomian designs. This vessel is cheap and has a sizeable cargo hold. It is commonly used by Tajaran traders and smugglers."

//ship stuff

/obj/effect/overmap/visitable/ship/tajaran_smuggler
	name = "Adhomian Freighter"
	class = "ACV"
	desc = "Built with reliability in mind, the Zhsram Freighter is one of the most common Adhomian designs. This vessel is cheap and has a sizeable cargo storage. It is frequently used by Tajaran traders and smugglers."
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	scanimage = "tramp_freighter.png"
	designer = "Independent/no designation"
	volume = "55 meters length, 25 meters beam/width, 18 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Not apparent, port obscured flight craft bay"
	sizeclass = "Zhsram Freighter"
	shiptype = "Long-term shipping utilities"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Adhomian Freight Shuttle" = list("nav_tajaran_smuggler_shuttle"),
		"Adhomian Freight Cargo" = list("nav_tajaran_smuggler_cargo")
	)

	initial_generic_waypoints = list(
		"nav_tajaran_smuggler_1",
		"nav_tajaran_smuggler_2"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/tajaran_smuggler/New()
	designation = "[pick("Brave Ha'rron", "Trickster Farwa", "Legal and Safe Cargo", "Adhomian Trader", "Minharrzka", "Rredouane's Chosen", "Adhomai's Pride")]"
	..()

/obj/effect/shuttle_landmark/tajaran_smuggler/nav1
	name = "Adhomian Freighter - Port Side"
	landmark_tag = "nav_tajaran_smuggler_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tajaran_smuggler/nav2
	name = "Adhomian Freighter - Port Airlock"
	landmark_tag = "nav_tajaran_smuggler_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tajaran_smuggler/transit
	name = "In transit"
	landmark_tag = "nav_transit_tajaran_smuggler"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/tajaran_smuggler_shuttle
	name = "Adhomian Freight Shuttle"
	class = "IFR"
	designation = "Rafama"
	desc = "An inefficient and rustic looking shuttle. This one's transponder identifies it as belonging to an independent freighter."
	shuttle = "Adhomian Freight Shuttle"
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/tajaran_smuggler_shuttle
	name = "shuttle control console"
	shuttle_tag = "Adhomian Freight Shuttle"


/datum/shuttle/autodock/overmap/tajaran_smuggler_shuttle
	name = "Adhomian Freight Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tajaran_smuggler)
	dock_target = "tajaran_smuggler_shuttle"
	current_location = "nav_tajaran_smuggler_shuttle"
	landmark_transition = "nav_transit_tajaran_smuggler_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_tajaran_smuggler_shuttle"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/tajaran_smuggler_shuttle
	name = "Tajaran Smuggler Shuttle"
	shuttle_tag = "Tajaran Smuggler Shuttle"
	master_tag = "tajaran_smuggler_shuttle"

//cargo hold - the smuggler can just send its cargo hold into space

/obj/effect/overmap/visitable/ship/landable/tajaran_smuggler_cargo
	name = "Cargo Hold"
	class = "ACV"
	designation = "Cargo Hold"
	desc = "A floating cargo container."
	shuttle = "Adhomian Freight Cargo"
	colors = list("#c3c7eb", "#a0a8ec")
	icon_state = "pod"
	moving_state = "pod_moving"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/tajaran_smuggler_cargo
	name = "cargo ejection control console"
	shuttle_tag = "Adhomian Freight Cargo"
