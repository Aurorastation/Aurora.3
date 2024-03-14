/datum/map_template/ruin/away_site/hiskyn
	name = "Hiskyn Revanchists Ship"
	description = "Ship with pirate lizards."
	suffixes = list("ships/unathi_pirate/hiskyn/unathi_pirate_hiskyn.dmm")
	sectors = list(SECTOR_BADLANDS, SECTOR_GAKAL)
	spawn_weight = 1
	ship_cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/hiskyn_shuttle)
	id = "hiskyn_revanchists"

	unit_test_groups = list(2)

/singleton/submap_archetype/hiskyn
	map = "Hiskyn Revanchists Ship"
	descriptor = "Ship with pirate lizards."

//Overmap object
/obj/effect/overmap/visitable/ship/hiskyn
	name = "Hiskyn Revanchist Ship"
	desc = "An Obrirava-class tanker, commonly used for transport of Helium-3 and other valuable gases by the Empire of Dominia. This one appears to have been heavily modified, with most of its fuel tanks seemingly removed and replaced based on initial scans."
	class = "ICV"
	icon_state = "freighter"
	moving_state = "freighter_moving"
	colors = list("#9c0101")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	designer = "Zhurong Naval Arsenal, Empire of Dominia"
	volume = "65 meters length, 25 meters beam/width, 18 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual wingtip-mounted heavy ballistic, starboard obscured flight craft bay"
	sizeclass = "Modified Obrirava-class tanker"
	shiptype = "Unknown"
	initial_restricted_waypoints = list(
		"Hiskyn Revanchist Shuttle" = list("nav_dock_hiskyn")
	)
	initial_generic_waypoints = list(
		"nav_hiskyn_fore",
		"nav_hiskyn_port",
		"nav_hiskyn_starboard",
		"nav_hiskyn_aft",
		"nav_hiskyn_fore_port",
		"nav_hiskyn_aft_starboard",
		"nav_hiskyn_fore_starboard",
		"nav_hiskyn_aft_port"
	)
	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/hiskyn/New()
	designation = "[pick("Red-Taloned Vengeance", "Fer'is' Fury", "Storms of Ha'zana", "Knees Unbent", "Seryo's Honor", "Traveller Returning", "Roaring Skrazi", "Heartseeker", "Winds of Travakh", "Charging Eskazal", "No Surrender", "Red Reprisal", "Retribution Incarnadine", "Betrayer's Bane", "Eye for an Eye", "Vengeful Dagger")]"
	..()

//Navpoints
/obj/effect/shuttle_landmark/hiskyn/fore
	name = "Fore"
	landmark_tag = "nav_hiskyn_fore"

/obj/effect/shuttle_landmark/hiskyn/port
	name = "Port"
	landmark_tag = "nav_hiskyn_port"

/obj/effect/shuttle_landmark/hiskyn/starboard
	name = "Starboard"
	landmark_tag = "nav_hiskyn_starboard"

/obj/effect/shuttle_landmark/hiskyn/aft
	name = "Aft"
	landmark_tag = "nav_hiskyn_aft"

/obj/effect/shuttle_landmark/hiskyn/dock/fore_port
	name = "Fore Port Dock"
	landmark_tag = "nav_hiskyn_fore_port"

/obj/effect/shuttle_landmark/hiskyn/dock/aft_starboard
	name = "Aft Starboard Dock"
	landmark_tag = "nav_hiskyn_aft_starboard"

/obj/effect/shuttle_landmark/hiskyn/dock/fore_starboard
	name = "Fore Starboard Dock"
	landmark_tag = "nav_hiskyn_fore_starboard"

/obj/effect/shuttle_landmark/hiskyn/dock/aft_port
	name = "Aft Port Dock"
	landmark_tag = "nav_hiskyn_aft_port"

//Shuttle stuff

/obj/effect/overmap/visitable/ship/landable/hiskyn_shuttle
	name = "Hiskyn Revanchist Shuttle"
	class = "ICV"
	designation = "Stalker"
	desc = "A heavily modified Yupmi-class transport shuttle, a common cargo transport in the Dominian Imperial Fleet."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#9c0101")
	shuttle = "Hiskyn Revanchist Shuttle"
	sizeclass = "Yupmi-class shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/hiskyn_shuttle
	name = "shuttle control console"
	shuttle_tag = "Hiskyn Revanchist Shuttle"
	req_access = list(ACCESS_UNATHI_PIRATE)

/datum/shuttle/autodock/overmap/hiskyn_shuttle
	name = "Hiskyn Revanchist Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/hiskyn_revanchists)
	current_location = "nav_dock_hiskyn"
	landmark_transition = "nav_transit_hiskyn"
	dock_target = "airlock_hiskyn_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_dock_hiskyn"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/hiskyn_shuttle/dock
	name = "Primary Docking Port"
	landmark_tag = "nav_dock_hiskyn"
	docking_controller = "hiskyn_shuttle_dock"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/hiskyn_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_hiskyn"
	base_turf = /turf/space/transit/north

/obj/item/clothing/under/unathi/hiskyn
	color = "#231f1c"
	accent_color = "#710a0a"

/obj/item/clothing/suit/storage/toggle/asymmetriccoat/hiskyn
	color = "#231f1c"

/obj/item/paper/fluff/hiskyn
	name = "KEEP OUT!"
	info = "How many times I gotta warn you tailwags about going through a man's stash! Next time I'm putting a landmine in this damned thing!"

/obj/item/paper/fluff/hiskyn/Initialize()
	. = ..()
	var/languagetext = "\[lang=o\]"
	languagetext += "[info]\[/lang\]"
	info = parsepencode(languagetext)
	icon_state = "paper_words"
