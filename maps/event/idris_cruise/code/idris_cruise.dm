/datum/map/event/idris_cruise
	name = "Stargazer"
	full_name = "Idris Stargazer Cruise Vessel"
	path = "event/idris_cruise"
	lobby_icons = list('icons/misc/titlescreens/idris_cruise/idris_cruise.dmi')
	lobby_transitions = FALSE

	allowed_jobs = list(/datum/job/visitor, /datum/job/passenger)

	station_levels = list(1)
	admin_levels = list()
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)

	station_name = "Stargazer Class Cruise Liner ID-410"
	station_short = "Stargazer"
	dock_name = "conglomerate spaceport"
	boss_name = "Idris Incorporated"
	boss_short = "Idris"
	company_name = "Idris Incorporated"
	company_short = "Idris"

	use_overmap = FALSE