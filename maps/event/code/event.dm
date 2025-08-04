/datum/map/event
	name = "Event"
	full_name = "Event Map"
	description = "You are joining an event map."
	path = "event"

	force_spawnpoint = TRUE

	lobby_icon_image_paths = list(
								list('icons/misc/titlescreens/tajara/taj1.png', 'icons/misc/titlescreens/tajara/taj2.png', 'icons/misc/titlescreens/tajara/taj3.png', 'icons/misc/titlescreens/tajara/taj4.png', 'icons/misc/titlescreens/tajara/Ghostsofwar.png', 'icons/misc/titlescreens/tajara/crack.png', 'icons/misc/titlescreens/tajara/blind_eye.png', 'icons/misc/titlescreens/tajara/RoyalGrenadier.png', 'icons/misc/titlescreens/tajara/For_the_King.png'),
								list('icons/misc/titlescreens/synths/baseline.png', 'icons/misc/titlescreens/synths/bishop.png', 'icons/misc/titlescreens/synths/g2.png', 'icons/misc/titlescreens/synths/shell.png', 'icons/misc/titlescreens/synths/zenghu.png'),
								list('icons/misc/titlescreens/vaurca/cthur.png', 'icons/misc/titlescreens/vaurca/klax.png', 'icons/misc/titlescreens/vaurca/liidra.png', 'icons/misc/titlescreens/vaurca/zora.png'),
								list('icons/misc/titlescreens/space/odin.png', 'icons/misc/titlescreens/space/starmap.png', 'icons/misc/titlescreens/space/undocking.png', 'icons/misc/titlescreens/space/voyage.png')
								)

	lobby_transitions = 10 SECONDS

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
