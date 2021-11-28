/datum/map/aurora
	name = "Aurora"
	full_name = "NSS Aurora"
	description = "You're aboard the <b>NSS Aurora</b>, a state-of-the-art station specializing in phoron research and acquisition. \
				   It is staffed by Nanotrasen personnel and contractors from competing megacorporations. \
				   Orbiting at the very edge of the Tau Ceti system, approximately 12 light-years away from Sol, \
				   it is under the joint administration of the Republic of Biesel and the trans-stellar corporate conglomerate NanoTrasen."
	path = "aurora"

	lobby_icons = list('icons/misc/titlescreens/aurora/nss_aurora.dmi', 'icons/misc/titlescreens/aurora/synthetics.dmi', 'icons/misc/titlescreens/aurora/tajara.dmi', 'icons/misc/titlescreens/aurora/Vaurca.dmi')
	lobby_transitions = 10 SECONDS

	station_levels = list(2, 3, 4, 5, 6, 7)
	admin_levels = list(1)
	contact_levels = list(3, 4, 5, 6, 7)
	player_levels = list(2, 3, 4, 5, 6, 7, 8)
	restricted_levels = list()
	accessible_z_levels = list("2" = 60, "6" = 20, "7" = 20)
	meteor_levels = list(6)
	base_turf_by_z = list(
		"1" = /turf/space,
		"2" = /turf/space,
		"3" = /turf/unsimulated/floor/asteroid/ash/rocky,
		"4" = /turf/unsimulated/floor/asteroid/ash/rocky,
		"5" = /turf/unsimulated/floor/asteroid/ash/rocky,
		"6" = /turf/unsimulated/floor/asteroid/ash,
		"7" = /turf/space,
		"8" = /turf/space
	)

	station_name = "NSS Aurora"
	station_short = "Aurora"
	dock_name = "NTCC Odin"
	dock_short = "Odin"
	boss_name = "Central Command"
	boss_short = "CentCom"
	company_name = "NanoTrasen"
	company_short = "NT"

	command_spawn_enabled = TRUE
	command_spawn_message = "Welcome to the Odin! Simply proceed down and to the right to board the shuttle to your workplace!"

	station_networks = list(
		NETWORK_CIVILIAN_MAIN,
		NETWORK_CIVILIAN_SURFACE,
		NETWORK_COMMAND,
		NETWORK_ENGINE,
		NETWORK_ENGINEERING,
		NETWORK_ENGINEERING_OUTPOST,
		NETWORK_STATION,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_RESEARCH_OUTPOST,
		NETWORK_ROBOTS,
		NETWORK_PRISON,
		NETWORK_SECURITY,
		NETWORK_SERVICE,
		NETWORK_SUPPLY
	)

	shuttle_docked_message = "The scheduled crew transfer shuttle to %dock% has docked with the station. It will depart in approximately %ETA%."
	shuttle_leaving_dock = "The crew transfer shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock%."
	shuttle_called_message = "A crew transfer to %dock% has been scheduled. The shuttle has been called. It will arrive in approximately %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The emergency shuttle has docked with the station. You have approximately %ETD% minutes to board the emergency shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive in approximately %ETA%."

	evac_controller_type = /datum/evacuation_controller/shuttle

	map_shuttles = list(
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod1,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod2,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod3,
		/datum/shuttle/autodock/ferry/emergency/aurora,
		/datum/shuttle/autodock/ferry/arrival/aurora,
		/datum/shuttle/autodock/ferry/supply/aurora,
		/datum/shuttle/autodock/ferry/merchant_aurora,
		/datum/shuttle/autodock/multi/admin,
		/datum/shuttle/autodock/ferry/autoreturn/ccia,
		/datum/shuttle/autodock/ferry/specops/ert_aurora,
		/datum/shuttle/autodock/multi/antag/skipjack_aurora,
		/datum/shuttle/autodock/multi/antag/burglar_aurora,
		/datum/shuttle/autodock/multi/antag/merc_aurora,
		/datum/shuttle/autodock/multi/legion,
		/datum/shuttle/autodock/multi/research_aurora,
		/datum/shuttle/autodock/multi/distress,
		/datum/shuttle/autodock/multi/merc_aurora_elite
	)

/datum/map/aurora/generate_asteroid()
	// Create the chasms.
	new /datum/random_map/automata/cave_system/chasms(null,0,0,3,255,255)
	new /datum/random_map/automata/cave_system(null,0,0,3,255,255)
	new /datum/random_map/automata/cave_system/chasms(null,0,0,4,255,255)
	new /datum/random_map/automata/cave_system(null,0,0,4,255,255)
	new /datum/random_map/automata/cave_system/chasms(null,0,0,5,255,255)
	new /datum/random_map/automata/cave_system/high_yield(null,0,0,5,255,255)
	new /datum/random_map/automata/cave_system/chasms/surface(null,0,0,6,255,255)

	// Create the deep mining ore distribution map.
	new /datum/random_map/noise/ore(null, 0, 0, 5, 64, 64)
	new /datum/random_map/noise/ore(null, 0, 0, 4, 64, 64)
	new /datum/random_map/noise/ore(null, 0, 0, 3, 64, 64)

/datum/map/aurora/finalize_load()
	// generate an empty space Z
	world.maxz++
