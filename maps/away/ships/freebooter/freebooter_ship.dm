/datum/map_template/ruin/away_site/freebooter_ship
	name = "Freebooter Ship"
	description = "One of the most common sights in the Orion Spur, even outside of human space, is the Hephaestus-produced Ox-class freighter. Designed to haul significant amounts of cargo on well-charted routes between civilized systems, the Ox-class is the backbone of many interstellar markets outside of the United Syndicates of Himeo. Repurposed Ox-class freighters are often used by pirates throughout the Spur thanks to their large size and ease of maintenance – and modification."
	suffixes = list("ships/freebooter/freebooter_ship.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_NEW_ANKARA, SECTOR_BADLANDS, SECTOR_AEMAQ, SECTOR_SRANDMARR, ALL_COALITION_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "freebooter_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/freebooter_shuttle)

	unit_test_groups = list(2)

/singleton/submap_archetype/freebooter_ship
	map = "Freebooter Ship"
	descriptor = "One of the most common sights in the Orion Spur, even outside of human space, is the Hephaestus-produced Ox-class freighter. Designed to haul significant amounts of cargo on well-charted routes between civilized systems, the Ox-class is the backbone of many interstellar markets outside of the United Syndicates of Himeo. Repurposed Ox-class freighters are often used by pirates throughout the Spur thanks to their large size and ease of maintenance – and modification."

//areas
/area/ship/freebooter_ship
	name = "Freebooter Ship"
	requires_power = TRUE

/area/ship/freebooter_ship/foyer
	name = "Freebooter Foyer"

/area/ship/freebooter_ship/gunnery
	name = "Freebooter Gunnery"

/area/ship/freebooter_ship/ammo
	name = "Freebooter Ammunition Storage"

/area/ship/freebooter_ship/gunneryentrance
	name = "Freebooter Ship Gunnery Entrance"

/area/ship/freebooter_ship/bridge
	name = "Freebooter Bridge"

/area/ship/freebooter_ship/forehallway
	name = "Freebooter Fore Hallway"

/area/ship/freebooter_ship/forehallwayport
	name = "Freebooter Fore Hallway Port"

/area/ship/freebooter_ship/closet
	name = "Freebooter Multi-Purpose Closet"

/area/ship/freebooter_ship/cryo
	name = "Freebooter Cryogenics Storage"

/area/ship/freebooter_ship/dorms
	name = "Freebooter Dormitories"

/area/ship/freebooter_ship/lockers
	name = "Freebooter Locker Rooms"

/area/ship/freebooter_ship/head
	name = "Freebooter Head"

/area/ship/freebooter_ship/medical
	name = "Freebooter Medical Bay"

/area/ship/freebooter_ship/pod1
	name = "Freebooter Pod One"

/area/ship/freebooter_ship/pod2
	name = "Freebooter Pod Two"

/area/ship/freebooter_ship/pod3
	name = "Freebooter Pod Three"

/area/ship/freebooter_ship/pod4
	name = "Freebooter Pod Four"

/area/ship/freebooter_ship/pod5
	name = "Freebooter Pod Five"

/area/ship/freebooter_ship/pod6
	name = "Freebooter Pod Six"

/area/ship/freebooter_ship/pod7
	name = "Freebooter Pod Seven"

/area/ship/freebooter_ship/pod8
	name = "Freebooter Pod Eight"

/area/ship/freebooter_ship/thruster1
	name = "Freebooter Starboard Thruster"

/area/ship/freebooter_ship/thruster2
	name = "Freebooter Port Thruster"

/area/ship/freebooter_ship/engineering
	name = "Freebooter Engineering"


/area/ship/freebooter_ship/exterior
	name = "Freebooter Ship Exterior"
	requires_power = FALSE

/area/shuttle/freebooter_shuttle
	name = "Freebooter Shuttle"
	icon_state = "shuttle2"
	requires_power = TRUE

//ship stuff

/obj/effect/overmap/visitable/ship/freebooter_ship
	name = "Freebooter Ship"
	class = "ICV"
	desc = "One of the most common sights in the Orion Spur, even outside of human space, is the Hephaestus-produced Ox-class freighter. Designed to haul significant amounts of cargo on well-charted routes between civilized systems, the Ox-class is the backbone of many interstellar markets outside of the United Syndicates of Himeo. Repurposed Ox-class freighters are often used by pirates throughout the Spur thanks to their large size and ease of maintenance – and modification."
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	scanimage = "tramp_freighter.png"
	designer = "Hephaestus Industries"
	volume = "41 meters length, 43 meters beam/width, 19 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Duel improvised weapon arrays, port landing pad"
	sizeclass = "Ox-class Modular Freighter"
	shiptype = "Multi-purpose freight"
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
	designation = "[pick("Peaceful", "Charming", "Jackal", "Friendly", "Boar", "One and Done", "Nothing Suspicious", "Death Valley", "Scan Again", "Pickpocket", "Dashing Rogue", "Port Authority", "Customs Patrol Ship", "Pay Transit Tolls Here", "Immigration Inspector", "For Hire", "Ex-Military", "Eat Shit", "Fuck Off", "Big Brother", "Wrong Turn", "Claim Jumper", "Davy Jones", "Thenardier", "Killer Queen", "Gunpowder", "Dynamite", "Phoron Collection Service", "We Never Liked Working Anyway", "The Orphanage", "Undertaker", "Flip and Burn", "Emphasis on Independent", "Widowmaker", "Irregular", "Ned Kelly", "Pay Your Union Dues Here", "We Support You!", "Jean Valjean", "Not Pirates", "Let's Be Friends!", "Alms For The Poor", "REAL KILLERS", "A Single Grain Of Sand", "What's It Matter To You?", "IFF Broken", "Or Something", "Nitroglycerin", "The Ghost of Christmas Present", "God's With Us So You Better Back Off Pal", "Faster Than You", "our shift key is broken", "It Is What It Is", "Bases Loaded", "We Support Law Enforcement", "Cash-Rich, Credit-Poor", "Cunning", "We Never Liked Beauchamp Anyway", "Civilian Ship", "We Didn't Start The Fire, Honest!", "Arson", "Jaywalking", "Bail Bondsmen", "Bail Jumper", "On Parole", "Don't Tell My Probation Officer", "Quit Your Bitching", "And The Then Or Thank You", "Sensor Glitch", "Not My Problem", "Mind Your Business", "Private Vessel Of The Dread Pirate King With His Entire Fleet And Crew In Tow So Back Off", "Daisy", "Sally", "Jane", "Pretty Little Thing", "We Like To Party", "No Squares Here")]"
	..()

/obj/effect/overmap/visitable/ship/freebooter_ship/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "tramp_freighter")
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
/obj/effect/overmap/visitable/ship/landable/freebooter_shuttle
	name = "Freebooter Shuttle"
	class = "ICV"
	designation = "Sheep's Clothing"
	desc = "The Plough-class tender is an utterly unremarkable engineering vessel, manufactured by Hephaestus and commonly seen attached to Ox-class ships. Scarcely capable of much except short-distance cargo hauling and loading."
	shuttle = "Freebooter Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#9dc04c", "#52c24c")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/freebooter_shuttle
	name = "shuttle control console"
	shuttle_tag = "Freebooter Shuttle"

/datum/shuttle/autodock/overmap/freebooter_shuttle
	name = "Freebooter Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/freebooter_shuttle)
	current_location = "nav_hangar_freebooter"
	landmark_transition = "nav_transit_freebooter_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_freebooter"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/freebooter_shuttle/hangar
	name = "Freebooter Shuttle Hangar"
	landmark_tag = "nav_hangar_freebooter"
	docking_controller = "freebooter_shuttle_dock"
	base_area = /area/ship/freebooter_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/freebooter_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_freebooter_shuttle"
	base_turf = /turf/space/transit/north
