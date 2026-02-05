
// ------------------ map/template stuff

/datum/map_template/ruin/away_site/freebooter_ship
	name = "Freebooter Ship"
	description = "One of the most common sights in the Orion Spur, even outside of human space, is the Hephaestus-produced Ox-class freighter. Designed to haul significant amounts of cargo on well-charted routes between civilized systems, the Ox-class is the backbone of many interstellar markets outside of the United Syndicates of Himeo. Repurposed Ox-class freighters are often used by pirates throughout the Spur thanks to their large size and ease of maintenance – and modification."

	prefix = "ships/freebooter/freebooter_ship/"
	suffix = "freebooter_ship_.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 0.5 // halved from 1 as this is a variation
	ship_cost = 1
	id = "freebooter_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/freebooter_shuttle)
	ban_ruins = list(/datum/map_template/ruin/away_site/freebooter_salvager)

	unit_test_groups = list(2)

/singleton/submap_archetype/freebooter_ship
	map = "Freebooter Ship"
	descriptor = "One of the most common sights in the Orion Spur, even outside of human space, is the Hephaestus-produced Ox-class freighter. Designed to haul significant amounts of cargo on well-charted routes between civilized systems, the Ox-class is the backbone of many interstellar markets outside of the United Syndicates of Himeo. Repurposed Ox-class freighters are often used by pirates throughout the Spur thanks to their large size and ease of maintenance – and modification."

// ------------------ mapmanip stuff

/obj/effect/map_effect/marker/mapmanip/submap/extract/freebooter_ship/pod_starboard
	name = "Freebooter Ship, Pod, Starboard"

/obj/effect/map_effect/marker/mapmanip/submap/insert/freebooter_ship/pod_starboard
	name = "Freebooter Ship, Pod, Starboard"

/obj/effect/map_effect/marker/mapmanip/submap/extract/freebooter_ship/pod_port
	name = "Freebooter Ship, Pod, Port"

/obj/effect/map_effect/marker/mapmanip/submap/insert/freebooter_ship/pod_port
	name = "Freebooter Ship, Pod, Port"

// ------------------ ship stuff

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

	/// List of possible designations, used by both freebooter variations.
	var/list/designations = list("Peaceful", "Charming", "Jackal", "Friendly", "Boar", "One and Done", "Nothing Suspicious", "Death Valley", "Scan Again", "Pickpocket", "Dashing Rogue", "Port Authority", "Customs Patrol Ship", "Pay Transit Tolls Here", "Immigration Inspector", "For Hire", "Ex-Military", "Eat Shit", "Fuck Off", "Big Brother", "Wrong Turn", "Claim Jumper", "Davy Jones", "Thenardier", "Killer Queen", "Gunpowder", "Dynamite", "Phoron Collection Service", "We Never Liked Working Anyway", "The Orphanage", "Undertaker", "Flip and Burn", "Emphasis on Independent", "Widowmaker", "Irregular", "Ned Kelly", "Pay Your Union Dues Here", "We Support You!", "Jean Valjean", "Not Pirates", "Let's Be Friends!", "Alms For The Poor", "REAL KILLERS", "A Single Grain Of Sand", "What's It Matter To You?", "IFF Broken", "Or Something", "Nitroglycerin", "The Ghost of Christmas Present", "God's With Us So You Better Back Off Pal", "Faster Than You", "our shift key is broken", "It Is What It Is", "Bases Loaded", "We Support Law Enforcement", "Cash-Rich, Credit-Poor", "Cunning", "We Never Liked Beauchamp Anyway", "Civilian Ship", "We Didn't Start The Fire, Honest!", "Arson", "Jaywalking", "Bail Bondsmen", "Bail Jumper", "On Parole", "Don't Tell My Probation Officer", "Quit Your Bitching", "And The Then Or Thank You", "Sensor Glitch", "Not My Problem", "Mind Your Business", "Private Vessel Of The Dread Pirate King With His Entire Fleet And Crew In Tow So Back Off", "Daisy", "Sally", "Jane", "Pretty Little Thing", "We Like To Party", "No Squares Here")

/obj/effect/overmap/visitable/ship/freebooter_ship/New()
	designation = pick(designations)
	..()

/obj/effect/overmap/visitable/ship/freebooter_ship/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "tramp_freighter")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

// ------------------ shuttle stuff

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

/obj/item/paper/fluff/freeboter_ship/captain_note
	name = "old captain's note"
	info = "Don't forget - all of the crew's clothing is now in the cargo pod!"
