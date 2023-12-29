/datum/map_template/ruin/away_site/tirakqi_smuggler
	name = "Ti'Rakqi Smuggler"
	description = "Featuring a respectable cargo bay, light frame, and large thruster nacelles, the Xroquv-class is one of the fastest federation freighters of this size. This one in particular appears to be refitted with expanded thruster nacelles and minor structural modifications. This one's transponder identifies it as belonging to an independent freighter."
	suffixes = list("ships/tirakqi_smuggler/tirakqi_smuggler.dmm")
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	spawn_weight = 1
	ship_cost = 1
	id = "tirakqi_smuggler"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tirakqi_smuggler_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/tirakqi_smuggler
	map = "Ti'Rakqi Smuggler"
	descriptor = "Featuring a respectable cargo bay, light frame, and large thruster nacelles, the Xroquv-class is one of the fastest federation freighters of this size. This one in particular appears to be refitted with expanded thruster nacelles and minor structural modifications. This one's transponder identifies it as belonging to an independent freighter."

//ship stuff

/obj/effect/overmap/visitable/ship/tirakqi_smuggler
	name = "Ti'Rakqi Smuggler"
	desc = "Featuring a respectable cargo bay, light frame, and large thruster nacelles, the Xroquv-class is one of the fastest federation freighters of this size. This one in particular appears to be refitted with expanded thruster nacelles and minor structural modifications. This one's transponder identifies it as belonging to an independent freighter."
	icon_state = "tirakqi"
	moving_state = "tirakqi_moving"
	colors = list("#27e4ee", "#4febbf")
	scanimage = "skrell_freighter.png"
	designer = "Nralakk Federation"
	volume = "37 meters length, 61 meters beam/width, 19 meters vertical height"
	drive = "Mid-Speed Warp Acceleration FTL Drive"
	weapons = "No visible armament, aft external flight craft bay"
	sizeclass = "Xroquv-class Federation Freighter"
	shiptype = "Luxupi Freighter"
	class = "ISV"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Ti'Rakqi Shuttle" = list("nav_hangar_tirakqi_shuttle")
	)

	initial_generic_waypoints = list(
		"nav_tirakqi_smuggler_1",
		"nav_tirakqi_smuggler_2",
		"nav_tirakqi_smuggler_3",
		"nav_tirakqi_smuggler_4",
		"nav_tirakqi_smuggler_dock_starboard",
		"nav_tirakqi_smuggler_dock_port"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/tirakqi_smuggler/New()
	designation = "[pick("Bigger Squib", "Frightful Whaler", "Star Spanner", "Lu'Kaax", "Star Scamp", "Ocean Ink", "Yippi")]"
	..()

/obj/effect/overmap/visitable/ship/tirakqi_smuggler/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "skrell_freighter")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/tirakqi_smuggler/nav1
	name = "Starboard Navpoint"
	landmark_tag = "nav_tirakqi_smuggler_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tirakqi_smuggler/nav2
	name = "Port Navpoint"
	landmark_tag = "nav_tirakqi_smuggler_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tirakqi_smuggler/nav3
	name = "Fore Navpoint"
	landmark_tag = "nav_tirakqi_smuggler_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tirakqi_smuggler/nav4
	name = "Aft Navpoint"
	landmark_tag = "nav_tirakqi_smuggler_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tirakqi_smuggler/dock/starboard
	name = "Starboard Docking Port"
	landmark_tag = "nav_tirakqi_smuggler_dock_starboard"
	docking_controller = "airlock_tirakqi_smuggler_dock_starboard"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/tirakqi_smuggler/dock/port
	name = "Port Docking Port"
	landmark_tag = "nav_tirakqi_smuggler_dock_port"
	docking_controller = "airlock_tirakqi_smuggler_dock_port"
	base_turf = /turf/space
	base_area = /area/space

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/tirakqi_smuggler_shuttle
	name = "Ti'Rakqi Shuttle"
	class = "ISV"
	designation = "Ku'ku"
	desc = "Made to complement the Xroquv-class freighter, the Jloqup-class shuttle is a cargo transport designed to fit neatly into the aft shuttle bay of its parent ship. While faster than most shuttles of similar class, it finds a shortcoming in fuel efficiency, meaning it usually can't go far on its own. This one's transponder identifies it as belonging to an independent freighter."
	shuttle = "Ti'Rakqi Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#27e4ee", "#4febbf")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Nralakk Federation"
	volume = "18 meters length, 10 meters beam/width, 4 meters vertical height"
	sizeclass = "Jloqup-class Cargo Transport"
	shiptype = "All-environment cargo transport"

/obj/machinery/computer/shuttle_control/explore/tirakqi_smuggler_shuttle
	name = "shuttle control console"
	shuttle_tag = "Ti'Rakqi Shuttle"
	req_access = list(ACCESS_SKRELL)

/datum/shuttle/autodock/overmap/tirakqi_smuggler_shuttle
	name = "Ti'Rakqi Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tirakqi_smuggler_shuttle)
	current_location = "nav_hangar_tirakqi_shuttle"
	dock_target = "airlock_tirakqi_shuttle"
	landmark_transition = "nav_transit_tirakqi_smuggler_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tirakqi_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tirakqi_smuggler_shuttle/hangar
	name = "Ti'Rakqi Shuttle Hangar"
	landmark_tag = "nav_hangar_tirakqi_shuttle"
	docking_controller = "airlock_tirakqi_smuggler_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tirakqi_smuggler_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tirakqi_smuggler_shuttle"
	base_turf = /turf/space/transit/north




// ====\/==== CUSTOM STUFF ====\/====


// wall nav console
/obj/machinery/computer/ship/navigation/wall
	icon = 'icons/obj/modular_telescreen.dmi'
	icon_state = "telescreen"
	icon_screen = "command"
	density = FALSE

// doors
/obj/machinery/door/airlock/hatch/tirakqi
	door_color = "#704470"
	stripe_color = "#382972"
	req_access = list(ACCESS_SKRELL)

/obj/machinery/door/airlock/glass/tirakqi
	door_color = "#704470"
	stripe_color = "#382972"
	req_access = list(ACCESS_SKRELL)

/obj/machinery/door/airlock/tirakqi
	door_color = "#704470"
	stripe_color = "#382972"
	req_access = list(ACCESS_SKRELL)

/obj/machinery/door/airlock/multi_tile/glass/tirakqi
	door_color = "#704470"
	req_access = list(ACCESS_SKRELL)

// walls for shuttle
/turf/simulated/wall/shuttle/space_ship/tirakqi_shuttle/cockpit
	color = "#6e2c6e"

/turf/simulated/wall/shuttle/space_ship/tirakqi_shuttle/main
	color = "#4e4378"

/turf/simulated/wall/shuttle/space_ship/tirakqi_shuttle/main/fake
	can_open = TRUE
	color = "#5e4e9c"

// floor for cosmozoan cage
/turf/simulated/floor/holofloor/tirakqi_cosmocage
	icon = 'icons/turf/space.dmi'
	name = "\proper holospace"
	icon_state = "void"
	footstep_sound = null
	plane = PLANE_SPACE_BACKGROUND
	dynamic_lighting = 0

/turf/simulated/floor/holofloor/tirakqi_cosmocage/update_dirt()
	return	// Space doesn't become dirty

// clothing
/obj/item/clothing/under/skrell/wetsuit/tirakqi/teal
	color = "#5c9681"
	accent_color = "#1d6148"

/obj/item/clothing/under/skrell/wetsuit/tirakqi/blue
	color = "#60899e"
	accent_color = "#1f4e66"

/obj/item/clothing/under/skrell/wetsuit/tirakqi/pink
	color = "#945a8c"
	accent_color = "#66205d"

/obj/item/clothing/under/skrell/wetsuit/tirakqi/purple
	color = "#6a5f96"
	accent_color = "#2f2069"

/obj/item/clothing/under/skrell/wetsuit/tirakqi/star
	color = "#403148"
	accent_color = "#ffb500"

/obj/item/clothing/under/skrell/wetsuit/tirakqi/engineer
	color = "#4e555d"
	accent_color = "#cccc33"

/obj/item/clothing/head/skrell/skrell_bandana/tirakqi/teal
	color = "#c9ffec"

/obj/item/clothing/head/skrell/skrell_bandana/tirakqi/blue
	color = "#cceeff"

/obj/item/clothing/head/skrell/skrell_bandana/tirakqi/pink
	color = "#fad9f6"

/obj/item/clothing/head/skrell/skrell_bandana/tirakqi/purple
	color = "#c8bbfc"

/obj/item/clothing/head/skrell/skrell_bandana/tirakqi/captain
	color = "#604baa"

/obj/item/clothing/ears/skrell/workcap/tirakqi/cyan
	color = "#cef5f5"

/obj/item/clothing/ears/skrell/workcap/tirakqi/pink
	color = "#fad9f6"

/obj/item/clothing/ears/skrell/workcap/tirakqi/purple
	color = "#c8bbfc"

// paper
/obj/item/paper/tirakqi_smuggler
	name = "IMPORTANT!"
	desc = "A handwritten note."
	info = "\
		Okay, here's the deal. There's a few hidden compartments around the ship, that's where we hide all the actually important stuff if we get selected for inspection. <br>\
		<br>\
		All of these spots are hidden behind fake walls - they look like the real deal, but they have plenty of give if you just push a little. <br>\
		<br>\
		First, we have some phoron we picked up tucked away in a compartments behind the vacuum warning signs in each of the wing docking ports. <br>\
		<br>\
		Second, we have a little backup stash in medical, just behind the freezer. <br>\
		<br>\
		Third, there's a bunch of compartments in the shuttle, all marked by the no smoking signs. <br>\
		<br>\
		Fourth, the last and largest compartment is hidden behind a traverse flag in the portside shuttle dock arm, aft of the cargo bay. <br>\
		<br>\
		VERY IMPORTANT - If we do get boarded, burn this paper immediately, and stash all the important stuff in these caches. Better hope you remember all this. <br>\
		"

/obj/item/paper/tirakqi_smuggler/Initialize()
	. = ..()
	var/languagetext = "\[lang=k\]"
	languagetext += "[info]\[/lang\]"
	info = parsepencode(languagetext)
	icon_state = "paper_words"
