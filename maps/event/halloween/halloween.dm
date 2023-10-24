/datum/map/event/halloween
	name = "Skyscraper"
	full_name = "Xanu Skyscraper Rooftops"
	path = "event/halloween"
	lobby_icons = list('icons/misc/titlescreens/sccv_horizon/sccv_horizon.dmi')
	lobby_transitions = FALSE
	allowed_jobs = list(/datum/job/visitor)
	force_spawnpoint = TRUE

	station_levels = list(1)
	admin_levels = list()
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)

	station_name = "The Infinity Reach Towers Top Floor"
	station_short = "Infinity Reach"
	dock_name = "Top Floor"
	dock_short = "Rooftop"
	boss_name = "Central Command"
	boss_short = "CentCom"
	company_name = "Stellar Corporate Conglomerate"
	company_short = "SCC"

	use_overmap = FALSE

	allowed_spawns = list("Living Quarters Lift")
	spawn_types = list(/datum/spawnpoint/living_quarters_lift)
	default_spawn = "Living Quarters Lift"
