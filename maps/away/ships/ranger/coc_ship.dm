/datum/map_template/ruin/away_site/ranger_corvette
	name = "Ranger Corvette"
	description = "Serving as the very foundation of the SCC's (And more specifically, NanoTrasen's) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design's interdiction counterpart - the Hydrus-class shuttle. This one's transponder identifies it as a Tau Ceti Foreign Legion patrol vessel, and as a Decanus-class Clipper - the Ranger designation for this design."
	suffix = "ships/ranger_corvette.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	spawn_weight = 1
	spawn_cost = 1
	id = "ranger_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/Ranger_shuttle)

/decl/submap_archetype/ranger_corvette
	map = "Ranger Corvette"
	descriptor = "Serving as the very foundation of the SCC's (And more specifically, NanoTrasen's) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design's interdiction counterpart - the Hydrus-class shuttle. This one's transponder identifies it as a Tau Ceti Foreign Legion patrol vessel, and as a Decanus-class Clipper - the Ranger designation for this design."

//areas
/area/ship/ranger_corvette
	name = "Ranger Corvette"

/area/shuttle/Ranger_shuttle
	name = "Ranger Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/ranger_corvette
	name = "Ranger Corvette"
	class = "FPBS"
	desc = "Serving as the very foundation of the SCC's (And more specifically, NanoTrasen's) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design's interdiction counterpart - the Hydrus-class shuttle. This one's transponder identifies it as a Tau Ceti Foreign Legion patrol vessel, and as a Decanus-class Clipper - the Ranger designation for this design."
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
	designation = "[pick("Xanu Prime", "Vysoka", "Gadpathur", "Assunzione", "Konyang", "Himeo", "Burzsia", "Kamoga", "Jagalaw", "Dalakyhr", "Gurmori", "Ohdker", "Dainshu", "Boch-Zivir", "Kill Emperor Boleslaw", "Expletive Sol", "Letter of Marque", "Free Fisanduh", "Gaucho", "Treaty of Xansan", "Pirates Beware", "Moroz Here We Come!", "This Ship Kills Privateers", "Lower The Black Flag", "Frontier Spirit", "Freedom", "Independence", "Self-Determination", "Let's Have A Second Collapse", "Send More Solarians", "You Can Run But You Can't Hide", "Frontier Alliance", "Here's To You, Governor Hawkins", "Remember Jamestown", "Good Riddance to Kambiz Entezam", "We're Coming For You In Hell, Terrence Hopper", "Warpway Safari Company", "Badlands Gun Club", "Light's Edge Light Foot", "Now Entering Free Xanu", "Weeping Stars, Weep No More", "Rebel's Reach Outreach Program", "Rugged Individualism", "Don't Tread On Me", "Snake In The Grass", "Crosk Plains Yacht Club", "Ranger Ship")]"
	..()

/obj/effect/shuttle_landmark/ranger_corvette/nav1
	name = "Ranger Corvette - Port Side"
	landmark_tag = "nav_ranger_corvette_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ranger_corvette/nav2
	name = "Ranger Corvette - Port Airlock"
	landmark_tag = "nav_ranger_corvette_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ranger_corvette/transit
	name = "In transit"
	landmark_tag = "nav_transit_ranger_corvette"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/Ranger_shuttle
	name = "Ranger Shuttle"
	designation = "BLV"
	class = "Stake"
	desc = "A large and unusually-shaped shuttle, the Hydrus-class is deceptively fast and is designed to operate out of a Cetus-class corvette's rear hangar bay, interdicting targets that its mothership intercepts. This one's transponder identifies it as a Tau Ceti Foreign Legion shuttle, and as a Velite-class Interceptor - the Ranger designation for this design."
	shuttle = "Ranger Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/Ranger_shuttle
	name = "shuttle control console"
	shuttle_tag = "Ranger Shuttle"
	req_access = list(access_ranger_corvette)

/datum/shuttle/autodock/overmap/Ranger_shuttle
	name = "Ranger Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/Ranger_shuttle)
	current_location = "nav_hangar_Ranger"
	landmark_transition = "nav_transit_Ranger_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_Ranger"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/Ranger_shuttle/hangar
	name = "Ranger Shuttle Hangar"
	landmark_tag = "nav_hangar_Ranger"
	docking_controller = "Ranger_shuttle_dock"
	base_area = /area/ship/ranger_corvette
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/Ranger_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_Ranger_shuttle"
	base_turf = /turf/space/transit/north
