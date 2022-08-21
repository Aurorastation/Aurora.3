datum/map_template/ruin/away_site/tajaran_smuggler
	name = "Adhomian Freighter"
	description = "Built with reliability in mind, the Zhsram Freighter is one of the most common Adhomian designs. This vessel is cheap and has a sizeable cargo storage. It is frequently used by Tajaran traders and smugglers."
	suffix = "ships/tajaran_smuggler.dmm"
	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL)
	spawn_weight = 1
	spawn_cost = 1
	id = "tajaran_smuggler"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tajaran_smuggler_shuttle)

/decl/submap_archetype/tajaran_smuggler
	map = "Adhomian Freighter"
	descriptor = "Built with reliability in mind, the Zhsram Freighter is one of the most common Adhomian designs. This vessel is cheap and has a sizeable cargo hold. It is commonly used by Tajaran traders and smugglers."

//areas
/area/ship/tajaran_smuggler
	name = "Adhomian Freighter"

/area/shuttle/tajaran_smuggler
	name = "Adhomian Freight Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/tajaran_smuggler
	name = "Adhomian Freighter"
	class = "ACV"
	desc = "Built with reliability in mind, the Zhsram Freighter is one of the most common Adhomian designs. This vessel is cheap and has a sizeable cargo storage. It is frequently used by Tajaran traders and smugglers."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Freight Shuttle" = list("nav_tajaran_smuggler_shuttle")
	)

	initial_generic_waypoints = list(
		"nav_tajaran_smuggler_1",
		"nav_tajaran_smuggler_2"
	)

/obj/effect/overmap/visitable/ship/tajaran_smuggler/New()
    designation = "[pick("Tuckerbag", "Do No Harm", "Volatile Cargo", "Stay Clear", "Entrepreneurial", "Good Things Only", "Worthless", "Skip This One", "Pay No Mind", "Customs-Cleared", "Friendly", "Reactor Leak", "Fool's Gold", "Cursed Cargo", "Guards Aboard")]"
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
	base_turf = /turf/space/transit/south

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/tajaran_smuggler_shuttle
	name = "Adhomian Freight Shuttle"
	desc = "An inefficient and rustic looking shuttle. This one's transponder identifies it as belonging to an independent freighter."
	shuttle = "Adhomian Freight Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/tajaran_smuggler_shuttle
	name = "shuttle control console"
	shuttle_tag = "Adhomian Freight Shuttle"


/datum/shuttle/autodock/overmap/tajaran_smuggler_shuttle
	name = "Freight Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tajaran_smuggler)
	current_location = "nav_tajaran_smuggler_shuttle"
	landmark_transition = "nav_transit_tajaran_smuggler_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_tajaran_smuggler_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tajaran_smuggler_shuttle/hangar
	name = "Freight Shuttle Hangar"
	landmark_tag = "nav_tajaran_smuggler_shuttle"
	docking_controller = "tajaran_smuggler_shuttle_dock"
	base_area = /area/ship/tajaran_smuggler
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tajaran_smuggler_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tajaran_smuggler_shuttle"
	base_turf = /turf/space/transit/south