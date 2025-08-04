
// --------------------------------------------------- template

/datum/map_template/ruin/away_site/tret_industrial_complex
	name = "Tret Industrial Complex"
	description = "An industrial complex on Tret."
	prefix = "away_site/uueoaesa/tret/"
	suffix = "tret_industrial_complex.dmm"
	id = "tret_industrial_complex"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tret_industrial)

	sectors = list(SECTOR_UUEOAESA)
	spawn_weight = 1
	spawn_cost = 1

	exoplanet_theme_base = /datum/exoplanet_theme/volcanic/tret
	exoplanet_themes = list(
		/turf/unsimulated/marker/blue = /datum/exoplanet_theme/volcanic/tret,
		/turf/unsimulated/marker/red  = /datum/exoplanet_theme/volcanic/tret/mountain
	)

	unit_test_groups = list(3)

/singleton/submap_archetype/tret_industrial_complex
	map = "Tret Industrial Complex"
	descriptor = "An industrial complex on Tret."

/obj/abstract/weather_marker/tret
	weather_type = /singleton/state/weather/ash/lava_planet

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/tret_industrial_complex
	name = "Tret"
	desc = "A large and inhospitable planet, now covered in mines, forges and factories - the new homeworld of the K'lax Hive."
	alignment = "Izweski Hegemony"
	icon_state = "globe3"
	color = "#d69200"
	initial_generic_waypoints = list(
		"nav_tret_industrial_dock_outpost_1",
		"nav_tret_industrial_dock_outpost_2",
		"nav_tret_industrial_dock_outpost_3",
		"nav_tret_industrial_dock_outpost_4",
		"nav_tret_industrial_dock_outpost_5",
		"nav_tret_industrial_surface_outpost_1",
		"nav_tret_industrial_surface_outpost_2",
		"nav_tret_industrial_surface_outpost_3",
		"nav_tret_industrial_surface_outpost_4",
		"nav_tret_industrial_surface_outpost_5",
		"nav_tret_industrial_surface_far_1",
		"nav_tret_industrial_surface_far_2",
		"nav_tret_industrial_surface_far_3",
		"nav_tret_industrial_surface_far_4",
	)

/obj/effect/overmap/visitable/sector/tret_industrial_complex/generate_ground_survey_result()
	..()
	ground_survey_result += "<br>Aphanitic and phaneritic rocks on the surface, rich in magnesium, iron, carbon"
	ground_survey_result += "<br>Trace elements of phoron detected in local atmosphere"
	ground_survey_result += "<br>Rich mineral deposits detected in basalt rock"
	ground_survey_result += "<br>Lava lakes and rivers present on the surface, rich in silicates"
	ground_survey_result += "<br>Lava tubes present in the subsurface"
	ground_survey_result += "<br>K'ois spores detected in local soil, sample destruction recommended"
	ground_survey_result += "<br>High geothermal activity observed in the planetary core"
	ground_survey_result += "<br>High seismic activity, long-term observation recommended to determine risk of earthquakes"

// --------------------------------------------------- shuttle

/obj/effect/overmap/visitable/ship/landable/tret_industrial
	name = "Tret Mining Shuttle"
	class = "IHCV" //Izweski Hegemony Civilian Vessel
	desc = "\
		Commonly used by the Miners' Guild, Glizkin-class shuttles are short-range mining vessels, designed for persistent mining of celestial bodies. \
		They are viewed by their crews as small, yet reliable and enduring - much like the Tza Prairie folk hero for which they are named. \
		They are usually found attached to larger stations, outposts, or mining vessels.\
		"
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
	vessel_mass = 3000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/tret_industrial/New()
	designation = pick("Xk'tiik", "Kl'axkia", "Xahth", "Aaxkia'tiik", "Lak'tixa", "Laxka")
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/tret_industrial
	name = "shuttle control console"
	shuttle_tag = "Tret Mining Shuttle"

/datum/shuttle/autodock/overmap/tret_industrial
	name = "Tret Mining Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tret_industrial/main, /area/shuttle/tret_industrial/propulsion)
	dock_target = "airlock_tret_industrial_shuttle"
	current_location = "nav_tret_industrial_dock_outpost_1"
	logging_home_tag = "nav_tret_industrial_dock_outpost_1"
	landmark_transition = "nav_tret_industrial_shuttle_transit"
	range = 1
	fuel_consumption = 2
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/tret_industrial_shuttle
	name = "Tret Mining Shuttle"
	shuttle_tag = "Tret Mining Shuttle"
	master_tag = "airlock_tret_industrial_shuttle"
	req_one_access = null
	req_access = null
	cycle_to_external_air = TRUE
