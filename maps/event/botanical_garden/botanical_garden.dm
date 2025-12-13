/datum/map/event/botanical_garden
	name = "Botanical Garden"
	full_name = "Phoenix Park Botanical Garden, Mendell City"
	path = "event/botanical_garden"
	lobby_icons = list('icons/misc/titlescreens/mendell/mendell_city.dmi')
	lobby_transitions = FALSE
	force_spawnpoint = TRUE

	allowed_jobs = list(/datum/job/visitor)

	admin_levels = list()
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)

	station_name = "Phoenix Park Botanical Garden"
	station_short = "Botanical Garden"
	dock_name = "conglomerate spaceport"
	boss_name = "Nanotrasen Incorporated"
	boss_short = "Nanotrasen"
	company_name = "Nanotrasen Incorporated"
	company_short = "Nanotrasen"

	use_overmap = FALSE

	allowed_spawns = list("Living Quarters Lift")
	spawn_types = list(/datum/spawnpoint/living_quarters_lift)
	default_spawn = "Living Quarters Lift"

	traits = list(
		//Z1
		list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = TRUE),
		//Z3
		list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)
