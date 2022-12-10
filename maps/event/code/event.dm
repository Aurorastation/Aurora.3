/datum/map/event
	name = "Event"
	full_name = "Event Map"
	description = "You are joining an event map."
	path = "event"

	force_spawnpoint = TRUE

	lobby_icons = list('icons/misc/titlescreens/aurora/nss_aurora.dmi', 'icons/misc/titlescreens/aurora/synthetics.dmi', 'icons/misc/titlescreens/aurora/tajara.dmi')
	lobby_transitions = 10 SECONDS

	station_levels = list(1)
	contact_levels = list(1)
	player_levels = list(1)
	base_turf_by_z = list(
		"1" = /turf/simulated/floor/grass
	)

	station_name = "NSS Event"
	station_short = "Event"
	dock_name = "NTCC Odin"
	dock_short = "Odin"
	boss_name = "Central Command"
	boss_short = "CentCom"
	company_name = "NanoTrasen"
	company_short = "NT"

	shuttle_call_restarts = TRUE
	shuttle_called_message = "OOC NOTE: The round will restart in ten minutes, unless the crew transfer is recalled."
	shuttle_recall_message = "OOC NOTE: The round will no longer restart."