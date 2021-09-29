/datum/map/event/rooftop
	name = "Rooftop"
	full_name = "Mendell City Rooftop"
	path = "event/rooftop"
	lobby_icons = list('icons/misc/titlescreens/mendell/mendell_city.dmi')
	lobby_transitions = FALSE

	allowed_jobs = list(/datum/job/visitor)

	station_levels = list(1)
	admin_levels = list()
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)

	station_name = "The Montparnasse"
	station_short = "Montparnasse"
	dock_name = "conglomerate spaceport"
	boss_name = "Idris Incorporated"
	boss_short = "Idris"
	company_name = "Idris Incorporated"
	company_short = "Idris"

	use_overmap = FALSE

	map_shuttles = list(
		/datum/shuttle/autodock/ferry/city
	)