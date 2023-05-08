/datum/map_template/ruin/away_site/freebooter_ship
	name = "Freebooter Ship"
	description = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance's fleets, and is typically reserved for more elite (or at least better equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."
	suffixes = list("ships/sol_freebooter/Freebooter_ship.dmm")
	sectors = list(SECTOR_BADLANDS)
	spawn_weight = 1
	ship_cost = 1
	id = "freebooter_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/Freebooter_shuttle)

/singleton/submap_archetype/freebooter_ship
	map = "Freebooter Ship"
	descriptor = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance's fleets, and is typically reserved for more elite (or at least better equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."

//areas
/area/ship/freebooter_ship
	name = "Freebooter Ship"
	requires_power = TRUE

/area/ship/freebooter_ship/bridge
	name = "Freebooter Ship Bridge"

/area/ship/freebooter_ship/hangar
	name = "Freebooter Ship Hangar"

/area/ship/freebooter_ship/starboardengine
	name = "Freebooter Ship Starboard Engine"

/area/ship/freebooter_ship/portengine
	name = "Freebooter Ship Port Engine"

/area/ship/freebooter_ship/synthroom
	name = "Freebooter Ship Synthetic Room"

/area/ship/freebooter_ship/dorms
	name = "Freebooter Ship Dorms"

/area/ship/freebooter_ship/brig
	name = "Freebooter Ship Brig"

/area/ship/freebooter_ship/starboardfoyer
	name = "Freebooter Ship Starboard Foyer"

/area/ship/freebooter_ship/francisca
	name = "Freebooter Ship Francisca Gunnery Compartment"

/area/ship/freebooter_ship/grauwolf
	name = "Freebooter Ship Grauwolf Gunnery Compartment"

/area/ship/freebooter_ship/bathroom
	name = "Freebooter Ship Bathroom"

/area/ship/freebooter_ship/captain
	name = "Freebooter Ship Captain's Office"

/area/ship/freebooter_ship/storage
	name = "Freebooter Ship Storage Compartment"

/area/ship/freebooter_ship/hangar
	name = "Freebooter Ship Hangar"

/area/ship/freebooter_ship/canteen
	name = "Freebooter Ship Canteen"

/area/ship/freebooter_ship/mechbay
	name = "Freebooter Ship Mechbay"

/area/ship/freebooter_ship/medbay
	name = "Freebooter Ship Medbay"

/area/ship/freebooter_ship/cryo
	name = "Freebooter Ship Cryogenics"

/area/ship/freebooter_ship/nuke
	name = "Freebooter Ship Reactor Compartment"

/area/ship/freebooter_ship/portfoyer
	name = "Freebooter Ship Port Foyer"

/area/shuttle/Freebooter_shuttle
	name = "Freebooter Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/freebooter_ship
	name = "Freebooter Ship"
	class = "ICV"
	desc = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance's fleets, and is typically reserved for more elite (or at least better equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."
	icon_state = "corvette"
	moving_state = "corvette_moving"
	colors = list("#9dc04c", "#52c24c")
	scanimage = "corvette.png"
	designer = "Hephaestus Industries"
	volume = "41 meters length, 43 meters beam/width, 19 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual extruding fore caliber ballistic armament, fore obscured flight craft bay"
	sizeclass = "Change This"
	shiptype = "Change This"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Freebooter Shuttle" = list("nav_hangar_freebooter")
	)

	initial_generic_waypoints = list(
		"nav_freebooter_ship_1",
		"nav_freebooter_ship_2"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/freebooter_ship/New()
	designation = "[pick("Asparuh", "Magyar", "Hussar", "Black Army", "Hunyadi", "Piast", "Hussite", "Tepes", "Komondor", "Turul", "Vistula", "Sikorski", "Mihai", "Blue Army", "Strzyga", "Leszy", "Danube", "Sokoly", "Patriotism", "Duty", "Loyalty", "Florian Geyer", "Pilsudski", "Chopin", "Levski", "Valkyrie", "Tresckow", "Olbricht", "Dubcek", "Kossuth", "Nagy", "Clausewitz", "Poniatowski", "Orzel", "Turul", "Skanderbeg", "Ordog", "Perun", "Poroniec", "Klobuk", "Cavalryman", "Szalai's Own", "Upior", "Szalai's Pride", "Kuvasz", "Fellegvar", "Nowa Bratislawa", "Zbior", "Stadter", "Homesteader", "Premyslid", "Bohemia", "Discipline", "Cavalryman", "Order", "Law", "Tenacity", "Diligence", "Valiant", "Konik", "Victory", "Triumph", "Vanguard", "Jager", "Grenadier", "Honor Guard", "Visegrad", "Nil", "Warsaw", "Budapest", "Prague", "Sofia", "Bucharest", "Home Army", "Kasimir", "Veles", "Blyskawica", "Kubus")]"
	..()

/obj/effect/overmap/visitable/ship/freebooter_ship/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "corvette")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/freebooter_ship/nav1
	name = "Freebooter Ship - Port Side"
	landmark_tag = "nav_freebooter_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/freebooter_ship/nav2
	name = "Freebooter Ship - Port Side"
	landmark_tag = "nav_freebooter_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/freebooter_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_freebooter_ship"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/Freebooter_shuttle
	name = "Freebooter Shuttle"
	class = "ICV"
	designation = "Vizsla"
	desc = "A modestly sized shuttle design used by the Solarian armed forces, the Destrier is well-armored but somewhat slow, and was explicitly designed to be as survivable as possible for operations during combat. Notably features a fast-deployment exosuit catapult."
	shuttle = "Freebooter Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#9dc04c", "#52c24c")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/Freebooter_shuttle
	name = "shuttle control console"
	shuttle_tag = "Freebooter Shuttle"
	req_access = list(access_sol_ships)

/datum/shuttle/autodock/overmap/Freebooter_shuttle
	name = "Freebooter Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/Freebooter_shuttle)
	current_location = "nav_hangar_freebooter"
	landmark_transition = "nav_transit_freebooter_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_freebooter"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/Freebooter_shuttle/hangar
	name = "Freebooter Shuttle Hangar"
	landmark_tag = "nav_hangar_freebooter"
	docking_controller = "Freebooter_shuttle_dock"
	base_area = /area/ship/freebooter_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/Freebooter_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_freebooter_shuttle"
	base_turf = /turf/space/transit/north
