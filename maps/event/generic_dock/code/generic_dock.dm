/datum/map/event/odin_departure
	name = "GenericDock"
	full_name = "Generic Dock"
	path = "event/generic_dock"
	lobby_icons = list('icons/misc/titlescreens/aurora/nss_aurora.dmi', 'icons/misc/titlescreens/aurora/synthetics.dmi', 'icons/misc/titlescreens/aurora/tajara.dmi')
	lobby_transitions = 10 SECONDS

	allowed_jobs = list(/datum/job/visitor)

	admin_levels = list(1)
	contact_levels = list(1,2)
	player_levels = list(1,2)
	accessible_z_levels = list(1,2)
	restricted_levels = list(2)

	station_name = "NSS Event"
	station_short = "Event"
	dock_name = "NTCC Odin"
	dock_short = "Odin"
	boss_name = "Central Command"
	boss_short = "CentCom"
	company_name = "NanoTrasen"
	company_short = "NT"

	use_overmap = FALSE
