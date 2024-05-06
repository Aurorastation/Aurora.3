/datum/map_template/ruin/away_site/tret_industrial_complex
	name = "Tret Industrial Complex"
	description = "An industrial complex on Tret. Wow."
	prefix = "away_site/uueoaesa/tret/"
	suffixes = list("tret_industrial_complex.dmm")
	sectors = list(SECTOR_UUEOAESA, ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "tret_industrial_complex"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tret_industrial)
	theme = /datum/exoplanet_theme/volcanic
	unit_test_groups = list(3)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/tret_industrial_complex
	map = "Tret Industrial Complex"
	descriptor = "An industrial complex on Tret. Wow."

/obj/effect/overmap/visitable/sector/tret_industrial_complex
	name = "Tret"
	desc = "A large and inhospitable planet, now covered in mines, forges and factories - the new homeworld of the K'lax Hive."
	icon_state = "globe3"
	color = "#d69200"
	initial_generic_waypoints = list("tret_industrial_dock")
	initial_restricted_waypoints = list(
		"Tret Mining Shuttle" = list("tret_industrial_navhangar")
	)

/turf/simulated/floor/exoplanet/basalt/tret //this isn't a real planet, so the atmos has to be done manually. Doesn't matter that much what it is bc bugs
	initial_gas = list("sulfur dioxide" = MOLES_O2STANDARD)

/turf/simulated/lava/tret
	initial_gas = list("sulfur dioxide" = MOLES_O2STANDARD)
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"

/turf/simulated/floor/plating/tret
	name = "plating"
	initial_gas = list("sulfur dioxide" = MOLES_O2STANDARD)

//Shuttle stuff
/obj/effect/overmap/visitable/ship/landable/tret_industrial
	name = "Tret Mining Shuttle"
	class = "IHCV" //Izweski Hegemony Civilian Vessel
	desc = "Commonly used by the Miners’ Guild, Glizkin-class shuttles are short-range mining vessels, designed for persistent mining of celestial bodies. \
	They are viewed by their crews as small, yet reliable and enduring - much like the Tza Prairie folk hero for which they are named. They are usually found attached to larger stations or mining vessels."
	designation = "Xk'tiik"
	shuttle = "Tret Mining Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	color = "#b07810"
	designer = "Hegeranzi Starworks"
	volume = "18 meters length, 15 meters beam/width, 7 meters vertical height"
	sizeclass = "Short-range crew transport and mineral extraction pod"
	shiptype = "Short-term industrial prospecting, raw goods transport"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/tret_industrial
	name = "shuttle control console"
	shuttle_tag = "Tret Mining Shuttle"

/datum/shuttle/autodock/overmap/tret_industrial
	name = "Tret Mining Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tret_industrial)
	current_location = "tret_industrial_navhangar"
	landmark_transition = "tret_industrial_navtransit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "tret_industrial_navhangar"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tret_industrial
	base_area = /area/exoplanet/lava/tret
	base_turf = /turf/simulated/floor/plating/tret

/obj/effect/shuttle_landmark/tret_industrial/hangar
	name = "Tret Industrial Complex - Landing Pad 1"
	landmark_tag = "tret_industrial_navhangar"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
	docking_controller = "airlock_tret_dock1"

/obj/effect/shuttle_landmark/tret_industrial/transit
	name = "In transit"
	landmark_tag = "tret_industrial_navtransit"
	base_turf = /turf/space/transit/north
	base_area = /area/space

/obj/effect/shuttle_landmark/tret_industrial/dock
	name = "Tret Industrial Complex - Landing Pad"
	landmark_tag = "tret_industrial_dock"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
