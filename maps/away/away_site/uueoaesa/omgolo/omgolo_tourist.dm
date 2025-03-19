/datum/map_template/ruin/away_site/omgolo_tourist
	name = "Omgolo Relaxation Platform"
	description = "A gas giant. Its planetary ring is home to several mining stations, hidden smuggler outposts, and tourist platforms."
	prefix = "away_site/uueoaesa/omgolo/"
	suffix = "omgolo_tourist.dmm"
	sectors = list(SECTOR_UUEOAESA)
	spawn_weight = 1
	spawn_cost = 2
	id = "omgolo_tourist"
	ban_ruins = list(/datum/map_template/ruin/away_site/omgolo_smuggler)
	unit_test_groups = list(2)

/singleton/submap_archetype/omgolo_tourist
	map = "Omgolo Relaxation Platform"
	descriptor = "A gas giant. Its planetary ring is home to several mining stations, hidden smuggler outposts, and tourist platforms."

/obj/effect/overmap/visitable/sector/omgolo_tourist
	name = "Omgolo"
	desc = "A gas giant. Its planetary ring is home to several mining stations, hidden smuggler outposts, and tourist platforms."
	icon_state = "globe3"
	color = "#cf5b02"
	initial_generic_waypoints = list(
		"nav_omgolo_tourist_fore",
		"nav_omgolo_tourist_aft",
		"nav_omgolo_tourist_port",
		"nav_omgolo_tourist_starboard"
	)

/obj/effect/overmap/visitable/sector/omgolo_tourist/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/planet.dmi', "")

	var/image/base = image('icons/skybox/planet.dmi', "base[pick(1,2,3)]")
	base.color = color
	skybox_image.overlays += base

	var/image/shadow = image('icons/skybox/planet.dmi', "shadow[pick(1,2,3)]")
	shadow.blend_mode = BLEND_MULTIPLY
	skybox_image.overlays += shadow

	var/image/rings = image('icons/skybox/planet_rings.dmi', "dense")
	rings.color = COLOR_ASTEROID_ROCK
	rings.pixel_x = -128
	rings.pixel_y = -128
	skybox_image.overlays += rings

	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	skybox_image.blend_mode = BLEND_OVERLAY
	return skybox_image

//Areas
/area/omgolo_tourist
	name = "Abandoned Tourism Platform"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/space
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/omgolo_tourist/hangar
	name = "Abandoned Tourism Platform - Hangar"
	icon_state = "exit"

/area/omgolo_tourist/dining
	name = "Abandoned Tourism Platform - Dining Lounge"
	icon_state = "cafeteria"

/area/omgolo_tourist/crew
	name = "Abandoned Tourism Platform - Habitaiton"
	icon_state = "crew_area"

/area/omgolo_tourist/kitchen
	name = "Abandoned Tourism Platform - Kitchen"
	icon_state = "kitchen"

/area/omgolo_tourist/freezer
	name = "Abandoned Tourism Platform - Freezer"
	icon_state = "kitchen"

/area/omgolo_tourist/room1
	name = "Abandoned Tourism Platform - Room #1"
	icon_state = "crew_quarters"

/area/omgolo_tourist/room2
	name = "Abandoned Tourism Platform - Room #2"
	icon_state = "crew_quarters"

/area/omgolo_tourist/room3
	name = "Abandoned Tourism Platform - Room #3"
	icon_state = "crew_quarters"

/area/omgolo_tourist/engineering
	name = "Abandoned Tourism Platform - Engineering"
	icon_state = "engineering"

/area/omgolo_tourist/atmos
	name = "Abandoned Tourism Platform - Atmospherics"
	icon_state = "atmos"

/area/omgolo_tourist/hallway
	name = "Abandoned Tourism Platform - Main Hall"
	icon_state = "hallC"

/area/omgolo_tourist/roomhallway
	name = "Abandoned Tourism Platform - Guest Rooms"
	icon_state = "hallS"


//Shuttle landmarks
/obj/effect/shuttle_landmark/omgolo_tourist/fore
	name = "Fore Docking Port"
	landmark_tag = "nav_omgolo_tourist_fore"
	docking_controller = "airlock_omgolo_tourist_fore"

/obj/effect/map_effect/marker/airlock/docking/omgolo_tourist/fore
	name = "Fore Docking Port"
	landmark_tag = "nav_omgolo_tourist_fore"
	master_tag = "airlock_omgolo_tourist_fore"

/obj/effect/shuttle_landmark/omgolo_tourist/aft
	name = "Aft Docking Port"
	landmark_tag = "nav_omgolo_tourist_aft"
	docking_controller = "airlock_omgolo_tourist_aft"

/obj/effect/map_effect/marker/airlock/docking/omgolo_tourist/aft
	name = "Aft Docking Port"
	landmark_tag = "nav_omgolo_tourist_aft"
	master_tag = "airlock_omgolo_tourist_aft"

/obj/effect/shuttle_landmark/omgolo_tourist/port
	name = "Port Docking Port"
	landmark_tag = "nav_omgolo_tourist_port"
	docking_controller = "airlock_omgolo_tourist_port"

/obj/effect/map_effect/marker/airlock/docking/omgolo_tourist/port
	name = "Port Docking Port"
	landmark_tag = "nav_omgolo_tourist_port"
	master_tag = "airlock_omgolo_tourist_port"

/obj/effect/shuttle_landmark/omgolo_tourist/starboard
	name = "Starboard Docking Port"
	landmark_tag = "nav_omgolo_tourist_starboard"
	docking_controller = "airlock_omgolo_tourist_starboard"

/obj/effect/map_effect/marker/airlock/docking/omgolo_tourist/starboard
	name = "Starboard Docking Port"
	landmark_tag = "nav_omgolo_tourist_starboard"
	master_tag = "airlock_omgolo_tourist_starboard"

//Items
/obj/item/paper/fluff/omgolo_tourist
	name = "Notice of Dismissal"
	info = "Due to insolvency of Merchants' Guild assets at this time, all employees of Relaxation Platform #71 are suspended without pay until platform operations can recommence. A transport shuttle will arrive within the next business day to transport all on-platform staff to Skalamar spaceport. The Guild will not cover further employee transport costs. Platform is to be placed in standby mode until we can return to normal operations, estimated by the end of the month.<br>\
	Message sent 07/27/2465, 17:41"
	language = LANGUAGE_UNATHI
