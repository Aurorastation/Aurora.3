/datum/map_template/ruin/away_site/ssmd_corvette
	name = "SSMD Corvette"
	description = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance’s fleets, and is typically reserved for more elite (or at least better-equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."
	suffix = "ships/sol_ssmd/ssmd_ship.dmm"
	sectors = list(SECTOR_BADLANDS)
	spawn_weight = 1
	spawn_cost = 1
	id = "ssmd_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ssmd_shuttle)

/decl/submap_archetype/ssmd_corvette
	map = "SSMD Corvette"
	descriptor = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance’s fleets, and is typically reserved for more elite (or at least better-equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."

//areas
/area/ship/ssmd_corvette
	name = "SSMD Corvette"
	requires_power = TRUE

/area/ship/ssmd_corvette/bridge
	name = "SSMD Corvette Bridge"

/area/ship/ssmd_corvette/hangar
	name = "SSMD Corvette Hangar"

/area/ship/ssmd_corvette/starboardengine
	name = "SSMD Corvette Starboard Engine"

/area/ship/ssmd_corvette/portengine
	name = "SSMD Corvette Port Engine"

/area/ship/ssmd_corvette/synthroom
	name = "SSMD Corvette Synthetic Room"

/area/ship/ssmd_corvette/dorms
	name = "SSMD Corvette Dorms"

/area/ship/ssmd_corvette/brig
	name = "SSMD Corvette Brig"

/area/ship/ssmd_corvette/starboardfoyer
	name = "SSMD Corvette Starboard Foyer"

/area/ship/ssmd_corvette/francisca
	name = "SSMD Corvette Francisca Gunnery Compartment"

/area/ship/ssmd_corvette/grauwolf
	name = "SSMD Corvette Grauwolf Gunnery Compartment"

/area/ship/ssmd_corvette/bathroom
	name = "SSMD Corvette Bathroom"

/area/ship/ssmd_corvette/captain
	name = "SSMD Corvette Captain's Office"

/area/ship/ssmd_corvette/storage
	name = "SSMD Corvette Storage Compartment"

/area/ship/ssmd_corvette/hangar
	name = "SSMD Corvette Hangar"

/area/ship/ssmd_corvette/canteen
	name = "SSMD Corvette Canteen"

/area/ship/ssmd_corvette/mechbay
	name = "SSMD Corvette Mechbay"

/area/ship/ssmd_corvette/medbay
	name = "SSMD Corvette Medbay"

/area/ship/ssmd_corvette/cryo
	name = "SSMD Corvette Cryogenics"

/area/ship/ssmd_corvette/nuke
	name = "SSMD Corvette Reactor Compartment"

/area/ship/ssmd_corvette/portfoyer
	name = "SSMD Corvette Port Foyer"

/area/shuttle/ssmd_shuttle
	name = "SSMD Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/ssmd_corvette
	name = "SSMD Corvette"
	class = "SSMDV"
	desc = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance’s fleets, and is typically reserved for more elite (or at least better-equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"SSMD Shuttle" = list("nav_hangar_ssmd")
	)

	initial_generic_waypoints = list(
		"nav_ssmd_corvette_1",
		"nav_ssmd_corvette_2"
	)

/obj/effect/overmap/visitable/ship/ssmd_corvette/New()
	designation = "[pick("Asparuh", "Magyar", "Hussar", "Black Army", "Hunyadi", "Piast", "Hussite", "Tepes", "Komondor", "Turul", "Vistula", "Sikorski", "Mihai", "Blue Army", "Strzyga", "Leszy", "Danube", "Sokoly", "Patriotism", "Duty", "Loyalty", "Florian Geyer", "Pilsudski", "Chopin", "Levski", "Valkyrie", "Tresckow", "Olbricht", "Dubcek", "Kossuth", "Nagy", "Clausewitz", "Poniatowski", "Orzel", "Turul", "Skanderbeg", "Ordog", "Perun", "Poroniec", "Klobuk", "Cavalryman", "Szalai's Own", "Upior", "Szalai's Pride", "Kuvasz", "Fellegvar", "Nowa Bratislawa", "Zbior", "Stadter", "Homesteader", "Premyslid", "Bohemia", "Discipline", "Cavalryman", "Order", "Law", "Tenacity", "Diligence", "Valiant", "Konik", "Victory", "Triumph", "Vanguard", "Jager", "Grenadier", "Honor Guard", "Visegrad", "Nil", "Warsaw", "Budapest", "Prague", "Sofia", "Bucharest", "Home Army", "Kasimir")]"
	..()

/obj/effect/shuttle_landmark/ssmd_corvette/nav1
	name = "SSMD Corvette - Port Side"
	landmark_tag = "nav_ssmd_corvette_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ssmd_corvette/nav2
	name = "SSMD Corvette - Port Side"
	landmark_tag = "nav_ssmd_corvette_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ssmd_corvette/transit
	name = "In transit"
	landmark_tag = "nav_transit_ssmd_corvette"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/ssmd_shuttle
	name = "SSMD Shuttle"
	class = "SSMDV"
	designation = "Vizsla"
	desc = "A modestly-sized shuttle design used by the Solarian armed forces, the Destrier is well-armored but somewhat slow, and was explicitly designed to be as survivable as possible for operations during combat. Notably features a fast-deployment exosuit catapult."
	shuttle = "SSMD Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/ssmd_shuttle
	name = "shuttle control console"
	shuttle_tag = "SSMD Shuttle"
	req_access = list(access_sol_ships)

/datum/shuttle/autodock/overmap/ssmd_shuttle
	name = "SSMD Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/ssmd_shuttle)
	current_location = "nav_hangar_ssmd"
	landmark_transition = "nav_transit_ssmd_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_ssmd"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/ssmd_shuttle/hangar
	name = "SSMD Shuttle Hangar"
	landmark_tag = "nav_hangar_ssmd"
	docking_controller = "ssmd_shuttle_dock"
	base_area = /area/ship/ssmd_corvette
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/ssmd_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_ssmd_shuttle"
	base_turf = /turf/space/transit/north
