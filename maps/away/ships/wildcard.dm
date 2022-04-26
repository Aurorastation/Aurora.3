/datum/map_template/ruin/away_site/freebooter_ship
	name = "Tramp Freighter"
	description = "A freighter of negative repute, the Catspaw-class is a rare independent design, and a favorite of freebooters, illegal miners, and smugglers. It has a shielded cargo bay and an internal hangar, capable of accommodating a small shuttle. Its other features, however, are lacking - with cramped crew amenities and no defenses to speak of, the Catspaw might be used to break the law, but it needs lawmen around to keep it out of trouble. This one’s transponder identifies it as an independent vessel."
	suffix = "ships/freebooter_ship.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 1
	id = "freebooter_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/freebooter_ship, /datum/shuttle/autodock/overmap/freebooter_shuttle)

/obj/effect/overmap/visitable/sector/freebooter_ship
	name = "faint ship activity"
	desc = "A sector with faint hints of previous ship presence."
	in_space = 1

/decl/submap_archetype/freebooter_ship
	map = "Tramp Freighter"
	descriptor = "A freighter of negative repute, the Catspaw-class is a rare independent design, and a favorite of freebooters, illegal miners, and smugglers. It has a shielded cargo bay and an internal hangar, capable of accommodating a small shuttle. Its other features, however, are lacking - with cramped crew amenities and no defenses to speak of, the Catspaw might be used to break the law, but it needs lawmen around to keep it out of trouble. This one’s transponder identifies it as an independent vessel."

//areas

/area/shuttle/freebooter_ship
	name = "Tramp Freighter"
	icon_state = "shuttle"

/area/shuttle/freebooter_shuttle
	name = "Freight Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/landable/freebooter_ship
	name = "Tramp Freighter"
	desc = "A freighter of negative repute, the Catspaw-class is a rare independent design, and a favorite of freebooters, illegal miners, and smugglers. It has a shielded cargo bay and an internal hangar, capable of accommodating a small shuttle. Its other features, however, are lacking - with cramped crew amenities and no defenses to speak of, the Catspaw might be used to break the law, but it needs lawmen around to keep it out of trouble. This one’s transponder identifies it as an independent vessel."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Tramp Freighter"
	initial_restricted_waypoints = list(
		"Freight Shuttle" = list("nav_hangar_freebooter")
	)

	initial_generic_waypoints = list(
		"nav_freebooter_ship_1"
	)

/obj/effect/overmap/visitable/ship/landable/freebooter_ship/New()
    name = "ICV [pick("Tuckerbag", "Do No Harm", "Volatile Cargo", "Law-Abider", "Stay Clear", "Entrepreneurial", "Good Things Only", "Worthless", "Skip This One", "Pay No Mind", "Customs-Cleared", "Friendly", "Reactor Leak")]"
    ..()

/obj/effect/shuttle_landmark/freebooter_ship/nav1
	name = "Tramp Freighter #1"
	landmark_tag = "nav_freebooter_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/datum/shuttle/autodock/overmap/freebooter_ship
	name = "Tramp Freighter"
	warmup_time = 5
	range = 1
	current_location = "nav_freebooter_ship_start"
	shuttle_area = list(/area/shuttle/freebooter_ship)
	knockdown = FALSE

	fuel_consumption = 4
	logging_home_tag = "nav_freebooter_ship_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/freebooter_ship/start
	name = "Uncharted Space"
	landmark_tag = "nav_freebooter_ship_start"

/obj/effect/shuttle_landmark/freebooter_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_freebooter_ship"
	base_turf = /turf/space/transit/south

/obj/machinery/computer/shuttle_control/explore/freebooter_ship
	name = "ship control console"
	shuttle_tag = "Tramp Freighter"
	req_access = list(access_freebooter_ship)

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/freebooter_shuttle
	name = "Freight Shuttle"
	desc = "An inefficient design of ultra-light shuttle known as the Wisp-class. Its only redeeming features are the extreme cheapness of the design and the ease of finding replacement parts. Manufactured by Hephaestus. This one’s transponder identifies it as belonging to an independent freighter."
	shuttle = "Freight Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/freebooter_shuttle
	name = "shuttle control console"
	shuttle_tag = "Freight Shuttle"
	req_access = list(access_freebooter_ship)

/datum/shuttle/autodock/overmap/freebooter_shuttle
	name = "Freight Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/freebooter_shuttle)
	current_location = "nav_hangar_freebooter"
	landmark_transition = "nav_transit_freebooter_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_freebooter"
	defer_initialisation = TRUE
	mothershuttle = "Tramp Freighter"

/obj/effect/shuttle_landmark/freebooter_shuttle/hangar
	name = "Freight Shuttle Hangar"
	landmark_tag = "nav_hangar_freebooter"
	docking_controller = "freebooter_shuttle_dock"
	base_area = /area/shuttle/freebooter_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/freebooter_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_freebooter_shuttle"
	base_turf = /turf/space/transit/south
