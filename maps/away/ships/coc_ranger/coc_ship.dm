/datum/map_template/ruin/away_site/ranger_corvette
	name = "Ranger Gunboat"
	description = "The Xansan-class is not, in fact, a distinct design in of itself. It is instead Xanu Prime’s variant of the Lagos-class gunboat, a Solarian light attack ship design. While the Lagos-class has been out of service with the Alliance’s navy for centuries, the blueprints were captured during the Interstellar war by Xanu Prime militiamen from a regional naval shipyard during the opening stages of the conflict, and were immediately used to construct ships of the class for use by Xanu Prime’s burgeoning military.  While the Xansan-class has been retired from Xanu service, the leftover ships were donated en masse to the Frontier Marshal Bureau, and the Rangers make use of the craft to this day, in spite of their advanced age."
	suffix = "ships/coc_ranger/coc_ship.dmm"
	sectors = list(SECTOR_BADLANDS)
	spawn_weight = 1
	spawn_cost = 1
	id = "ranger_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ranger_shuttle)

/decl/submap_archetype/ranger_corvette
	map = "Ranger Gunboat"
	descriptor = "The Xansan-class is not, in fact, a distinct design in of itself. It is instead Xanu Prime’s variant of the Lagos-class gunboat, a Solarian light attack ship design. While the Lagos-class has been out of service with the Alliance’s navy for centuries, the blueprints were captured during the Interstellar war by Xanu Prime militiamen from a regional naval shipyard during the opening stages of the conflict, and were immediately used to construct ships of the class for use by Xanu Prime’s burgeoning military.  While the Xansan-class has been retired from Xanu service, the leftover ships were donated en masse to the Frontier Marshal Bureau, and the Rangers make use of the craft to this day, in spite of their advanced age."

//areas
/area/ship/ranger_corvette
	name = "Ranger Gunboat"

/area/ship/ranger_corvette/bridge
	name = "Ranger Gunboat Bridge"

/area/ship/ranger_corvette/janitor
	name = "Ranger Gunboat Custodial Closet"

/area/ship/ranger_corvette/crew
	name = "Ranger Gunboat Crew Quarters"

/area/ship/ranger_corvette/leader
	name = "Ranger Gunboat Leader's Quarters"

/area/ship/ranger_corvette/foyer
	name = "Ranger Gunboat Foyer"

/area/ship/ranger_corvette/telecomms
	name = "Ranger Gunboat Telecomms"

/area/ship/ranger_corvette/brig
	name = "Ranger Gunboat Brig"

/area/ship/ranger_corvette/medbay
	name = "Ranger Gunboat Medbay"

/area/ship/ranger_corvette/munitions
	name = "Ranger Gunboat Munition Storage"

/area/ship/ranger_corvette/gunnery
	name = "Ranger Gunboat Gunnery Room"

/area/ship/ranger_corvette/bathroom
	name = "Ranger Gunboat Bathroom"

/area/ship/ranger_corvette/cryo
	name = "Ranger Gunboat Cryogenics"

/area/ship/ranger_corvette/engine1
	name = "Ranger Gunboat Engine One"

/area/ship/ranger_corvette/engine2
	name = "Ranger Gunboat Engine Two"

/area/ship/ranger_corvette/voidsuits
	name = "Ranger Gunboat Suit Storage"

/area/ship/ranger_corvette/atmospherics
	name = "Ranger Gunboat Atmospherics"

/area/ship/ranger_corvette/canteen
	name = "Ranger Gunboat Canteen"

/area/shuttle/ranger_shuttle
	name = "Ranger Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/ranger_corvette
	name = "Ranger Gunboat"
	class = "FPBS"
	desc = "The Xansan-class is not, in fact, a distinct design in of itself. It is instead Xanu Prime’s variant of the Lagos-class gunboat, a Solarian light attack ship design. While the Lagos-class has been out of service with the Alliance’s navy for centuries, the blueprints were captured during the Interstellar war by Xanu Prime militiamen from a regional naval shipyard during the opening stages of the conflict, and were immediately used to construct ships of the class for use by Xanu Prime’s burgeoning military.  While the Xansan-class has been retired from Xanu service, the leftover ships were donated en masse to the Frontier Marshal Bureau, and the Rangers make use of the craft to this day, in spite of their advanced age."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Ranger Shuttle" = list("nav_hangar_Ranger")
	)

	initial_generic_waypoints = list(
		"nav_ranger_corvette_1",
		"nav_ranger_corvette_2"
	)

/obj/effect/overmap/visitable/ship/ranger_corvette/New()
	designation = "[pick("Argia sa Mar", "Kuenoi", "Xansan", "Greentree", "Rautakaivos Kaupunki", "Dorshafen", "Inverkeithing", "Uusi Viipuri", "Horner Station", "Commander Ashia Patvardhan", "Sevaschaiv", "Rahe", "Czsari", "Suwon", "Kamoga", "Jagalaw", "Dalakyhr", "Gurmori", "Ohdker", "Dainshu", "Boch-Zivir", "Kill Emperor Boleslaw", "Expletive Sol", "Letter of Marque", "Free Fisanduh", "Gaucho", "Treaty of Xansan", "Pirates Beware", "Moroz Here We Come!", "This Ship Kills Privateers", "Lower The Black Flag", "Frontier Spirit", "Freedom", "Independence", "Self-Determination", "Let's Have A Second Collapse", "Send More Solarians", "You Can Run But You Can't Hide", "Frontier Alliance", "Here's To You, Governor Hawkins", "Remember Jamestown", "Good Riddance to Kambiz Entezam", "We're Coming For You In Hell, Terrence Hopper", "Warpway Safari Company", "Badlands Gun Club", "Light's Edge Light Foot", "Now Entering Free Xanu", "Weeping Stars, Weep No More", "Rebel's Reach Outreach Program", "Rugged Individualism", "Don't Tread On Me", "Snake In The Grass", "Konyang Yacht Club", "Ranger Ship")]"
	..()

/obj/effect/shuttle_landmark/ranger_corvette/nav1
	name = "Ranger Gunboat - Port Side"
	landmark_tag = "nav_ranger_corvette_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ranger_corvette/nav2
	name = "Ranger Gunboat - Dock Airlock"
	landmark_tag = "nav_ranger_corvette_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ranger_corvette/transit
	name = "In transit"
	landmark_tag = "nav_transit_ranger_corvette"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/ranger_shuttle
	name = "Ranger Shuttle"
	class = "FPBS"
	designation = "Pony"
	desc = "An inefficient design of ultra-light shuttle. Its only redeeming features are the extreme cheapness of the design and the ease of finding replacement parts. Manufactured by Hephaestus."
	shuttle = "Ranger Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/ranger_shuttle
	name = "shuttle control console"
	shuttle_tag = "Ranger Shuttle"

/datum/shuttle/autodock/overmap/ranger_shuttle
	name = "Ranger Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/ranger_shuttle)
	current_location = "nav_hangar_ranger"
	landmark_transition = "nav_transit_ranger_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_ranger"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/ranger_shuttle/hangar
	name = "Ranger Shuttle Hangar"
	landmark_tag = "nav_hangar_ranger"
	docking_controller = "ranger_shuttle_dock"
	base_area = /area/ship/ranger_corvette
	base_turf = /turf/space/dynamic
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/ranger_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_ranger_shuttle"
	base_turf = /turf/space/transit/north
