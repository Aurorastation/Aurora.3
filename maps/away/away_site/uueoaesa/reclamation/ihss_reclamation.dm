/datum/map_template/ruin/away_site/ihss_reclamation
	name = "IHSS Reclamation"
	description = "The very first space station constructed by the Unathi, and nearly a century old, the IHSS Reclamation has been extensively refurbished to provide a monitoring and research station for ecological restoration efforts on the Moghresian Wasteland."
	prefix = "away_site/uueoaesa/reclamation/"
	suffix = "ihss_reclamation.dmm"
	sectors = list(SECTOR_UUEOAESA)
	spawn_weight = 1
	spawn_cost = 1
	id = "ihss_reclamation"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ihss_reclamation_shuttle)
	unit_test_groups = list(1)

/singleton/submap_archetype/ihss_reclamation
	map = "IHSS Reclamation"
	descriptor = "The very first space station constructed by the Unathi, and nearly a century old, the IHSS Reclamation has been extensively refurbished to provide a monitoring and research station for ecological restoration efforts on the Moghresian Wasteland."

/obj/effect/overmap/visitable/ship/stationary/ihss_reclamation
	name = "IHSS Reclamation"
	desc = "The very first space station constructed by the Unathi, and nearly a century old, the IHSS Reclamation has been extensively refurbished to provide a monitoring and research station for ecological restoration efforts on the Moghresian Wasteland."
	class = "IHSS"
	designation = "Reclamation"
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "battlestation"
	color = "#f05c3e"
	static_vessel = TRUE
	generic_object = FALSE
	designer = "Hephaestus Industries, Izweski Hegemonic Naval Guilds"
	sizeclass = "Ecological monitoring and analysis station"
	initial_generic_waypoints = list(
		"nav_ihss_reclamation_1",
		"nav_ihss_reclamation_2",
		"nav_ihss_reclamation_3",
		"nav_ihss_reclamation_4",
		"nav_ihss_reclamation_dock1",
		"nav_ihss_reclamation_dock2",
		"nav_ihss_reclamation_dock3",
		"nav_ihss_reclamation_dock4"
	)
	initial_restricted_waypoints = list(
		"IHSS Reclamation Shuttle" = list("nav_ihss_reclamation_shuttle")
	)
	comms_support = TRUE
	comms_name = "IHSS Reclamation"

/obj/effect/shuttle_landmark/nav_ihss_reclamation
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/nav_ihss_reclamation/nav1
	name = "Fore"
	landmark_tag = "nav_ihss_reclamation_1"

/obj/effect/shuttle_landmark/nav_ihss_reclamation/nav2
	name = " Aft"
	landmark_tag = "nav_ihss_reclamation_2"

/obj/effect/shuttle_landmark/nav_ihss_reclamation/nav3
	name = "Port"
	landmark_tag = "nav_ihss_reclamation_3"

/obj/effect/shuttle_landmark/nav_ihss_reclamation/nav4
	name = "Starboard"
	landmark_tag = "nav_ihss_reclamation_4"

/obj/effect/shuttle_landmark/nav_ihss_reclamation/dock1
	name = "Docking Port #1"
	landmark_tag = "nav_ihss_reclamation_dock1"
	docking_controller = "airlock_reclamation_dock1"

/obj/effect/shuttle_landmark/nav_ihss_reclamation/dock2
	name = "Docking Port #2"
	landmark_tag = "nav_ihss_reclamation_dock2"
	docking_controller = "airlock_reclamation_dock2"

/obj/effect/shuttle_landmark/nav_ihss_reclamation/dock3
	name = "Docking Port #3"
	landmark_tag = "nav_ihss_reclamation_dock3"
	docking_controller = "airlock_reclamation_dock3"

/obj/effect/shuttle_landmark/nav_ihss_reclamation/dock4
	name = "Docking Port #4"
	landmark_tag = "nav_ihss_reclamation_dock4"
	docking_controller = "airlock_reclamation_dock4"

//Shuttle

/obj/effect/overmap/visitable/ship/landable/ihss_reclamation_shuttle
	name = "IHSS Reclamation Shuttle"
	class = "HMV"
	designation = "Simi's Staff"
	desc = "A small transport shuttle often used by the Izweski Navy."
	shuttle = "IHSS Reclamation Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designer = "Hegeranzi Starworks"
	weapons = "Single fore-mounted ballistic weapon."
	colors = list("#e38222", "#f0ba3e")
	max_speed = 1/(1 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/ihss_reclamation
	name = "shuttle control console"
	shuttle_tag = "IHSS Reclamation Shuttle"

/datum/shuttle/autodock/overmap/ihss_reclamation_shuttle
	name = "IHSS Reclamation Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/ihss_reclamation)
	current_location = "nav_ihss_reclamation_shuttle"
	landmark_transition = "nav_transit_ihss_reclamation"
	dock_target = "airlock_reclamation_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_ihss_reclamation_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/ihss_reclamation_shuttle
	name = "IHSS Reclamation - Shuttle Hangar"
	landmark_tag = "nav_ihss_reclamation_shuttle"
	base_area = /area/ihss_reclamation/hangar1
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
	docking_controller = "reclamation_hangar"

/obj/effect/shuttle_landmark/ihss_reclamation_transit
	name = "In transit"
	landmark_tag = "nav_transit_ihss_reclamation"
	base_turf = /turf/space/transit/north

/obj/item/paper/fluff/ihss_reclamation_cell
	name = "Rules of Observation"
	info = "<center>IHSS Reclamation<br>Hazardous Specimen Containment Rules of Observation</center><hr>\
	I thought this crew could be trusted to not do the obvious, but I have witnessed firsthand that this was a <u>foolish</u> hope of mine. \
	If you wish to not end up like others, you are to at least try to understand the following before entering:<br>\
	<ol><li>Approach the cell slowly.</li><li>Do not touch or <u>shake</u> the fence.</li>\
	<li>Do not knock on the glass.</li><li>Do not put their appendages or tail through the fence holes.</li>\
	<li>Have means of escape prepared in event of containment failure.</li>\
	<li>Check cell exterior periodically, if damage to cell is seen, engage the lockdown <b>immediately</b>.</li>\
	<li>Do not unbolt or especially <i>open</i> the cell door unless you know what you are doing.</li>\
	<li>The Skrazi is not to be used against any 'hostiles'. Stop asking.</li>\
	<li>Put only food items in the delivery chute.</li>\
	<li>Do not fall into the delivery chute. Rescue attempts are <u>not</u> to be made before the Skrazi is sedated.</li>\
	<li>The cell is to be cleaned weekly. <b><u>Do not forget to sedate the Skrazi before entering the cell.</u></b></li>\
	<li><b>Do not taunt the Skrazi.</b>.</li></ol>"
	language = LANGUAGE_UNATHI
