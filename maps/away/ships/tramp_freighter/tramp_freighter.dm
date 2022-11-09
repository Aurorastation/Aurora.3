/datum/map_template/ruin/away_site/tramp_freighter
	name = "Tramp Freighter"
	description = "A freighter of mixed repute, the Catspaw-class is a rare independent design, and a favorite of small-scale freight businesses. It has a shielded cargo bay and an internal hangar, capable of accommodating a small shuttle. Its other features, however, are lacking - with cramped crew amenities and no defenses to speak of, the Catspaw is risky to operate in unpoliced space. This one's transponder identifies it as an independent vessel."
	suffix = "ships/tramp_freighter/tramp_freighter.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ)
	spawn_weight = 1
	spawn_cost = 1
	id = "tramp_freighter"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/freighter_shuttle)

/decl/submap_archetype/tramp_freighter
	map = "Tramp Freighter"
	descriptor = "A freighter of mixed repute, the Catspaw-class is a rare independent design, and a favorite of small-scale freight businesses. It has a shielded cargo bay and an internal hangar, capable of accommodating a small shuttle. Its other features, however, are lacking - with cramped crew amenities and no defenses to speak of, the Catspaw is risky to operate in unpoliced space. This one's transponder identifies it as an independent vessel."

//areas
/area/ship/tramp_freighter
	name = "Tramp Freighter"

/area/shuttle/freighter_shuttle
	name = "Freight Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/tramp_freighter
	name = "Tramp Freighter"
	class = "ICV"
	desc = "A freighter of mixed repute, the Catspaw-class is a rare independent design, and a favorite of small-scale freight businesses. It has a shielded cargo bay and an internal hangar, capable of accommodating a small shuttle. Its other features, however, are lacking - with cramped crew amenities and no defenses to speak of, the Catspaw is risky to operate in unpoliced space. This one's transponder identifies it as an independent vessel."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Freight Shuttle" = list("nav_hangar_tramp")
	)

	initial_generic_waypoints = list(
		"nav_tramp_freighter_1",
		"nav_tramp_freighter_2"
	)

/obj/effect/overmap/visitable/ship/tramp_freighter/New()
    designation = "[pick("Tuckerbag", "Do No Harm", "Volatile Cargo", "Stay Clear", "Entrepreneurial", "Good Things Only", "Worthless", "Skip This One", "Pay No Mind", "Customs-Cleared", "Friendly", "Reactor Leak", "Fool's Gold", "Cursed Cargo", "Guards Aboard")]"
    ..()

/obj/effect/shuttle_landmark/tramp_freighter/nav1
	name = "Tramp Freighter - Port Side"
	landmark_tag = "nav_tramp_freighter_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tramp_freighter/nav2
	name = "Tramp Freighter - Port Airlock"
	landmark_tag = "nav_tramp_freighter_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tramp_freighter/transit
	name = "In transit"
	landmark_tag = "nav_transit_tramp_freighter"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/freighter_shuttle
	name = "Freight Shuttle"
	class = "ICV"
	designation = "Dame"
	desc = "An inefficient design of ultra-light shuttle known as the Wisp-class. Its only redeeming features are the extreme cheapness of the design and the ease of finding replacement parts. Manufactured by Hephaestus. This one's transponder identifies it as belonging to an independent freighter."
	shuttle = "Freight Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/freighter_shuttle
	name = "shuttle control console"
	shuttle_tag = "Freight Shuttle"


/datum/shuttle/autodock/overmap/freighter_shuttle
	name = "Freight Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/freighter_shuttle)
	current_location = "nav_hangar_tramp"
	landmark_transition = "nav_transit_freighter_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tramp"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/freighter_shuttle/hangar
	name = "Freight Shuttle Hangar"
	landmark_tag = "nav_hangar_tramp"
	docking_controller = "freighter_shuttle_dock"
	base_area = /area/ship/tramp_freighter
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/freighter_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_freighter_shuttle"
	base_turf = /turf/space/transit/north