/datum/map_template/ruin/away_site/saniorios_outpost
	name = "Sani'Orios"
	description = "A gas giant composed of ammonia. Its planetary ring is home to several spaceship wrecks and hidden smuggler bases."
	prefix = "away_site/tajara/saniorios_outpost/"
	suffix = "saniorios_outpost.dmm"
	sectors = list(SECTOR_SRANDMARR)
	spawn_weight = 1
	spawn_cost = 2
	id = "saniorios_outpost"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/saniorios_outpost)
	unit_test_groups = list(1)

/singleton/submap_archetype/saniorios_outpost
	map = "Sani'Orios"
	descriptor = "A gas giant composed of ammonia. Its planetary ring is home to several spaceship wrecks and hidden smuggler bases."

/obj/effect/overmap/visitable/sector/saniorios_outpost
	name = "Sani'Orios"
	desc = "A gas giant composed of ammonia. Its planetary ring is home to several spaceship wrecks and hidden smuggler bases."
	icon_state = "globe3"
	color = COLOR_DARK_BLUE_GRAY

	initial_generic_waypoints = list(
		"nav_hsaniorios_outpost_1",
		"nav_hsaniorios_outpost_2",
		"nav_hsaniorios_outpost_3"
	)
	initial_restricted_waypoints = list(
		"Unmarked Adhomian Shuttle" = list("nav_hangar_saniorios_outpost")
	)

	comms_support = TRUE
	comms_name = "dpra asteroid outpost"

/obj/effect/overmap/visitable/sector/saniorios_outpost/get_skybox_representation()
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

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/saniorios_outpost
	name = "Unmarked Adhomian Shuttle"
	class = "Unmarked"
	designation = "Civilian Shuttle"
	desc = "A shuttle without any kind of identification."
	shuttle = "Unmarked Adhomian Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#CD4A4C")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/saniorios_outpost
	name = "shuttle control console"
	shuttle_tag = "Unmarked Adhomian Shuttle"

/datum/shuttle/autodock/overmap/saniorios_outpost
	name = "Unmarked Adhomian Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/saniorios_outpost)
	current_location = "nav_hangar_saniorios_outpost"
	landmark_transition = "nav_transit_saniorios_outpost"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_saniorios_outpost"
	dock_target = "saniorios_outpost"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/saniorios_outpost
	name = "Unmarked Adhomian Shuttle"
	shuttle_tag = "Unmarked Adhomian Shuttle"
	master_tag = "saniorios_outpost"
