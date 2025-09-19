/datum/map_template/ruin/away_site/ipc_refugee_ship
	name = "IPC Refugee Ship"
	description = "The Akers-class freighter is an ancient design, dating back nearly two hundred years. It was considered a reliable freighter for its time, but is completely obsolete by modern standards, making it a rare sight outside of ship graveyards. Scans indicate this vessel in particular to be exceptionally run down, bearing severe structural damage across the whole ship. Damage appears to be from a mix of both meteors and ballistic armaments. Despite this, power signatures seem to indicate the vessel is still somehow operable."

	prefix = "ships/konyang/ipc_refugee/"
	suffix = "ipc_refugee_ship.dmm"

	sectors = list(SECTOR_HANEUNIM, SECTOR_LIBERTYS_CRADLE, SECTOR_XANU)
	spawn_weight = 1
	ship_cost = 1
	id = "ipc_refugee_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ipc_refugee_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/ipc_refugee_ship
	map = "IPC Refugee Ship"
	descriptor = "The Akers-class freighter is an ancient design, dating back nearly two hundred years. It was considered a reliable freighter for its time, but is completely obsolete by modern standards, making it a rare sight outside of ship graveyards. Scans indicate this vessel in particular to be exceptionally run down, bearing severe structural damage across the whole ship. Damage appears to be from a mix of both meteors and ballistic armaments. Despite this, power signatures seem to indicate the vessel is still somehow operable."

/obj/effect/overmap/visitable/ship/ipc_refugee_ship
	name = "IPC Refugee Ship"
	class = "ICV"
	desc = "The Akers-class freighter is an ancient design, dating back nearly two hundred years. It was considered a reliable freighter for its time, but is completely obsolete by modern standards, making it a rare sight outside of ship graveyards. Scans indicate this vessel in particular to be exceptionally run down, bearing severe structural damage across the whole ship. Damage appears to be from a mix of both meteors and ballistic armaments. Despite this, power signatures seem to indicate the vessel is still somehow operable."
	icon_state = "freighter"
	moving_state = "freighter_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	scanimage = "tramp_freighter.png"
	designer = "ERROR"
	volume = "52 meters length, 28 meters beam/width, 17 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	sizeclass = "Akers-class Freighter"
	shiptype = "Light Cargo Freighter"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Decrepit Cargo Tug" = list("nav_hangar_ipc_refugee")
	)

	initial_generic_waypoints = list(
		"nav_ipc_refugee_ship_1",
		"nav_ipc_refugee_ship_2",
		"nav_ipc_refugee_ship_3",
		"nav_ipc_refugee_ship_4",
		"nav_ipc_refugee_ship_5",
		"nav_ipc_refugee_ship_6",
		"nav_refugee_dock_starboard",
		"nav_refugee_dock_port"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/ipc_refugee_ship/New()
	designation = "[pick("HELP", "PLS NO MORE PIRATES", "Need Fuel, Air, n' Repairs", "Spare Change?", "Fix Me", "Need Directions, Starmap Broken", "KONYANG HERE WE COME", "Can't Have Sh!t", "01010011 01001111 01010011", "How's My Flying", "Ignore The Bullet Holes", "(insert designation)", "Press Any Key to Start", "Don't Tell Mom I'm In Burzsia", "SNAFU", "FUBAR")]"
	..()

/obj/effect/overmap/visitable/ship/ipc_refugee_ship/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "tramp_freighter")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/ipc_refugee_ship/nav1
	name = "Port Navpoint"
	landmark_tag = "nav_ipc_refugee_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ipc_refugee_ship/nav2
	name = "Fore Navpoint"
	landmark_tag = "nav_ipc_refugee_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ipc_refugee_ship/nav3
	name = "Starboard Navpoint"
	landmark_tag = "nav_ipc_refugee_ship_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ipc_refugee_ship/nav4
	name = "Aft Navpoint"
	landmark_tag = "nav_ipc_refugee_ship_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ipc_refugee_ship/nav5
	name = "Far Port Navpoint"
	landmark_tag = "nav_ipc_refugee_ship_5"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ipc_refugee_ship/nav6
	name = "Far Starboard Navpoint"
	landmark_tag = "nav_ipc_refugee_ship_6"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ipc_refugee_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_ipc_refugee_ship"
	base_turf = /turf/space/transit/north

/obj/effect/shuttle_landmark/ipc_refugee_ship/starboard_dock
	name = "Decrepit Freighter Starboard Dock"
	landmark_tag = "nav_refugee_dock_starboard"
	docking_controller = "airlock_refugee_dock_starboard"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/ipc_refugee_ship/port_dock
	name = "Decrepit Freighter Port Dock"
	landmark_tag = "nav_refugee_dock_port"
	docking_controller = "airlock_refugee_dock_port"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/overmap/visitable/ship/landable/ipc_refugee_shuttle
	name = "Decrepit Cargo Tug"
	class = "ICV"
	designation = "Last Hope"
	desc = "The Stout-class is a small utility craft designed to latch to the cargo pods of the Akers-class freighter and pull them out to steer them into station dock, or vice versa. Like the freighter it belongs to, this cargo tug is an ancient design, dating back perhaps two hundred years. It's an inefficient, clunky, and obsolete design compared to modern equivalents, but it's still an operable craft."
	shuttle = "Decrepit Cargo Tug"
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "ERROR"
	volume = "10 meters length, 7 meters beam/width, 4 meters vertical height"
	sizeclass = "Stout-class Utility Craft"
	shiptype = "Cargo Tug"

/obj/machinery/computer/shuttle_control/explore/ipc_refugee_shuttle
	name = "shuttle control console"
	shuttle_tag = "Decrepit Cargo Tug"

/datum/shuttle/autodock/overmap/ipc_refugee_shuttle
	name = "Decrepit Cargo Tug"
	move_time = 40
	shuttle_area = list(/area/shuttle/ipc_refugee_shuttle)
	current_location = "nav_hangar_ipc_refugee"
	dock_target = "ipc_refugee_shuttle"
	landmark_transition = "nav_transit_ipc_refugee_shuttle"
	range = 1
	fuel_consumption = 4 // very old, so not as efficient as other shuttles
	logging_home_tag = "nav_hangar_ipc_refugee"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/ipc_refugee_shuttle/hangar
	name = "Cargo Tug Dock"
	landmark_tag = "nav_hangar_ipc_refugee"
	docking_controller = "ipc_refugee_ship_aft_airlock"
	base_area = /area/ship/ipc_refugee
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/ipc_refugee_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_ipc_refugee_shuttle"
	base_turf = /turf/space/transit/north



// custom stuff
/obj/structure/closet/crate/trashcart/shark
	name = "DO NOT OPEN!!!"
	desc = "A large, heavy, metal trashcart with wheels. This one looks particularly beat up, and seems to rattle on occassion...?"

/obj/structure/closet/crate/trashcart/shark/fill()
	new /mob/living/simple_animal/hostile/carp/shark(src)


/obj/item/paper/ipc_refugee_ship
	name = "/obj/item/paper/ipc_refugee_ship/ parent object"
	desc = DESC_PARENT

/obj/item/paper/ipc_refugee_ship/weapons
	name = "NEED BETTER WEAPONS"
	desc = "A crinkly handwritten note."
	info = "\
		JIM YOU SUCK AT SALVAGE <br>\
		<br>\
		I'm not great with guns but I could swear one of these is a fucking pest gun, NOT a laser carbine like you said. <br>\
		<br>\
		When I said we need to find real weapons, I MEANT SOMETHING THAT COULD KILL THE NEXT PIRATES THAT SCREW WITH US, ASSHOLE!!! <br>\
		<br>\
		I accidentally fired the pistol and almost blinded myself... <br>\
		NORMAL BULLETS DON'T DO THAT, JIM! <br>\
		<br>\
		At least the shotgun has the real deal. Right? <br>\
		RIGHT, JIM? <br>\
		"

/obj/item/paper/ipc_refugee_ship/reactor
	name = "READ ME"
	desc = "A handwritten note."
	info = "\
		Okay, so as you know, those damn pirates blew a nice new hole in our ship, and blew all our fucking coolant out into the void along with it. <br>\
		So please please pleaaase with a cherry on top do not set it much higher than around two? or so? <br>\
		AND DEFINITELY DO NOT SET IT TO SIX OR HIGHER FOR THE LOVE OF ALL THAT IS GOOD <br>\
		<br>\
		If you leave this bad boy on six, it WILL blow a hole clean through the ship in a matter of minutes, destroy all our hopes and dreams, and worst of all, finish those asshole's job for them. <br>\
		SO DON'T PUT IT TO SIX OR HIGHER!!! <br>\
		Just take it nice and easy. <br>\
		<br>\
		Oh, also the tritium is just on the table over there. What's left, anyway. <br>\
		<br>\
		"

/obj/item/paper/ipc_refugee_ship/wishlist
	name = "DEAR GOD OR RICH PEOPLE"
	desc = "A crinkly handwritten note."
	info = "\
		WISHLIST <br>\
		<br>\
		- FUEL <br>\
		- RGB GAMEHELM SETUP <br>\
		- MORE FUEL <br>\
		- AIR <br>\
		- A LOT OF AIR <br>\
		- SERIOUSLY A LOOOOT OF AIR <br>\
		- FOOD? MAYBE <br>\
		- OVERLOADERS <br>\
		- HIGH CAPACITY POWER CELLS <br>\
		- BETTER SUIT COOLERS <br>\
		- FUCKING EVERYTHING <br>\
		<br>\
		respectfully, the crew <br>\
		"

/obj/item/paper/ipc_refugee_ship/comms
	name = "COMMUNICATIONS"
	desc = "A handwritten note."
	info = "\
		So... yeah. Telecomms got hit. <br>\
		Just the break we needed, right? <br>\
		<br>\
		All we got left are these dinky shortwaves, so just remember, 146.3 is the hailing frequency. <br>\
		<br>\
		Also remember, these shortwaves only pick up whatever frequency it's set to. Keep track of that. <br>\
		"

/obj/item/paper/ipc_refugee_ship/overloaders
	name = "OVERLOADERS!"
	desc = "A handwritten note."
	info = "\
		YEAH THAT'S RIGHT, OVERLOADERS! <br>\
		<br>\
		You guys don't know how lucky this was, I was just picking through some trash on the last stop we made, and there was this crate with a canvas thrown over it just filled with the things! <br>\
		<br>\
		Sure, they're not labeled, but I'm at least 70% they're perfectly fine, and those are some pretty good odds when we're talking free overloaders! <br>\
		"
