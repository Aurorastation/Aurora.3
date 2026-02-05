/datum/map_template/ruin/away_site/sadar_scout
	name = "Unified Sadar Fleet Scout"
	description = "The Boreas-class is a small and ancient class of expeditionary vessels dating back a couple hundreds years to when it was commissioned by the Solarian Department of Colonization for Colony Fleet SFE-528-RFS - better known now as the Scarab Fleet. Like most scarab ships, this one has been heavily modified with much of necessary equipment retrofitted and superfluous components stripped away."

	prefix = "ships/sadar_scout/"
	suffix = "sadar_scout.dmm"

	sectors = list(ALL_COALITION_SECTORS, ALL_CRESCENT_EXPANSE_SECTORS)
	sectors_blacklist = list(SECTOR_HANEUNIM, SECTOR_BURZSIA, SECTOR_XANU)
	spawn_weight = 1
	ship_cost = 1
	id = "sadar_scout"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/sadar_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/sadar_scout
	map = "Unified Sadar Fleet Scout"
	descriptor = "The Boreas-class is a small and ancient class of expeditionary vessels dating back a couple hundreds years to when it was commissioned by the Solarian Department of Colonization for Colony Fleet SFE-528-RFS - better known now as the Scarab Fleet. Like most scarab ships, this one has been heavily modified with much of necessary equipment retrofitted and superfluous components stripped away."

/obj/effect/overmap/visitable/ship/sadar_scout
	name = "Unified Sadar Fleet Scout"
	class = "ICV"
	desc = "The Boreas-class is a small and ancient class of expeditionary vessels dating back a couple hundreds years to when it was commissioned by the Solarian Department of Colonization for Colony Fleet SFE-528-RFS - better known now as the Scarab Fleet. Like most scarab ships, this one has been heavily modified with much of necessary equipment retrofitted and superfluous components stripped away."
	icon_state = "freighter"
	moving_state = "freighter_moving"
	colors = list("#8a0f8a", "#a201a2")
	scanimage = "ranger.png"
	designer = "Einstein Engines"
	volume = "62 meters length, 28 meters beam/width, 12 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Extruding starboard-mounted improvised medium caliber armament, port external flight craft bay"
	sizeclass = "Boreas-class Expeditionary Vessel"
	shiptype = "Long-term expeditionary utility"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Modified Salvage Skiff" = list("nav_hangar_sadar_scout")
	)

	initial_generic_waypoints = list(
		"nav_sadar_scout_1",
		"nav_sadar_scout_2",
		"nav_sadar_scout_3",
		"nav_sadar_scout_4",
		"nav_sadar_scout_dock_fore",
		"nav_sadar_scout_dock_fore_port",
		"nav_sadar_scout_dock_fore_starboard",
		"nav_sadar_scout_dock_aft_port",
		"nav_sadar_scout_dock_aft_starboard",
		"nav_sadar_scout_dock_port",
		"nav_sadar_scout_dock_starboard"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/sadar_scout/New()
	designation = "[pick("Released", "New Dawn", "Exodus", "Shiwuniket", "Nitaniket", "Legitimate Salvage", "Beloved Hakhma", "Fortuitous Omen", "Tujmansaal", "Hard Won Bliss", "Spare Wrench", "Dim Eyes", "Screw Gravity")]"
	..()

/obj/effect/overmap/visitable/ship/sadar_scout/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "ranger")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image


/obj/effect/shuttle_landmark/sadar_scout/nav1
	name = "Port Navpoint"
	landmark_tag = "nav_sadar_scout_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sadar_scout/nav2
	name = "Fore Navpoint"
	landmark_tag = "nav_sadar_scout_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sadar_scout/nav3
	name = "Starboard Navpoint"
	landmark_tag = "nav_sadar_scout_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sadar_scout/nav4
	name = "Aft Navpoint"
	landmark_tag = "nav_sadar_scout_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/sadar_scout/dock/fore
	name = "Fore Dock"
	landmark_tag = "nav_sadar_scout_dock_fore"
	docking_controller = "airlock_sadar_scout_dock_fore"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/sadar_scout/dock/fore_port
	name = "Solar Dock Fore - Portside"
	landmark_tag = "nav_sadar_scout_dock_fore_port"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/sadar_scout/dock/fore_starboard
	name = "Solar Dock Fore - Starboardside"
	landmark_tag = "nav_sadar_scout_dock_fore_starboard"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/sadar_scout/dock/aft_port
	name = "Solar Dock Aft - Portside"
	landmark_tag = "nav_sadar_scout_dock_aft_port"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/sadar_scout/dock/aft_starboard
	name = "Solar Dock Aft - Starboardside"
	landmark_tag = "nav_sadar_scout_dock_aft_starboard"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/sadar_scout/dock/port
	name = "Solar Dock Port"
	landmark_tag = "nav_sadar_scout_dock_port"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/sadar_scout/dock/starboard
	name = "Solar Dock Starboard"
	landmark_tag = "nav_sadar_scout_dock_starboard"
	base_turf = /turf/space
	base_area = /area/space

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/sadar_shuttle
	name = "Modified Salvage Skiff"
	class = "ICV"
	designation = "Trodder"
	desc = "An ancient design of salvage skiff, the Monax-class once was a common sight in industrial sectors a couple hundred years ago. This one has been heavily modified from the original design - most notably the gravity generator stripped away, and a rotary canon mounted where a remote manipulator system once should have been."
	shuttle = "Modified Salvage Skiff"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#8a0f8a", "#a201a2")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Einstein Engines"
	volume = "11 meters length, 8 meters beam/width, 4 meters vertical height"
	weapons = "Port-mounted extruding low-caliber rotary ballistic armament"
	sizeclass = "Monax-class Salvage Skiff"
	shiptype = "Salvage & Construction Utility"

/obj/machinery/computer/shuttle_control/explore/sadar_shuttle
	name = "shuttle control console"
	shuttle_tag = "Modified Salvage Skiff"
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_state = "computer"
	icon_screen = "helm"
	icon_keyboard = "security_key"
	icon_keyboard_emis = "security_key_mask"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/datum/shuttle/autodock/overmap/sadar_shuttle
	name = "Modified Salvage Skiff"
	move_time = 20
	shuttle_area = list(/area/shuttle/sadar_shuttle)
	current_location = "nav_hangar_sadar_scout"
	dock_target = "airlock_sadar_shuttle"
	landmark_transition = "nav_transit_sadar_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_sadar_scout"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/sadar_shuttle/hangar
	name = "Raiding Skiff Dock"
	landmark_tag = "nav_hangar_sadar_scout"
	docking_controller = "sadar_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/sadar_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_sadar_shuttle"
	base_turf = /turf/space/transit/north


// CUSTOM STUFF
// dimmed yellow lights
/obj/machinery/light/floor/decayed
	brightness_color = "#fabd6d"
	randomize_color = FALSE
	brightness_power = 0.3

/obj/machinery/light/colored/decayed/dimmed
	brightness_power = 0.2

// accessories
/obj/item/clothing/accessory/offworlder/bracer/grey
	color = "#5f5f5f"

/obj/item/clothing/accessory/offworlder/dark_red
	color = "#300000"

/obj/item/clothing/accessory/offworlder/bracer/neckbrace/dark_red
	color = "#300000"
