/datum/map/event/burzsia_station
	name = "HICS Etna"
	full_name = "HICS Etna"
	path = "event/burzsia_station"
	lobby_icons = list('icons/misc/titlescreens/sccv_horizon/sccv_horizon.dmi', 'icons/misc/titlescreens/aurora/synthetics.dmi', 'icons/misc/titlescreens/aurora/tajara.dmi', 'icons/misc/titlescreens/aurora/vaurca.dmi')
	lobby_transitions = FALSE

	allowed_jobs = list(/datum/job/visitor, /datum/job/xo, /datum/job/captain, /datum/job/chief_engineer, /datum/job/consular, /datum/job/cmo, /datum/job/hos, /datum/job/representative, /datum/job/operations_manager, /datum/job/rd)

	station_levels = list(1)
	admin_levels = list()
	contact_levels = list(1)
	player_levels = list(1)
	accessible_z_levels = list(1)
	sealed_levels = list(1)

	station_name = "HICS Etna"
	station_short = "HICS Etna"
	dock_name = "Burzsia I"
	boss_name = "Hephaestus Industries"
	boss_short = "Hephaestus"
	company_name = "Hephaestus Industries"
	company_short = "Hephaestus"
	station_type = "station"

	use_overmap = FALSE

	allowed_spawns = list("Cryogenic Storage")
	spawn_types = list(/datum/spawnpoint/cryo)
	default_spawn = "Cryogenic Storage"
