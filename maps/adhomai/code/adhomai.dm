/datum/map/adhomai
	name = "Adhomai"
	full_name = "Adhomai"
	path = "adhomai"

	lobby_screens = list("aurora_asteroid", "aurora_postcard")

	station_levels = list(2,3)
	admin_levels = list(1)
	contact_levels = list(2)
	player_levels = list(2,3)
	accessible_z_levels = list("8" = 2, "9" = 3)
	base_turf_by_z = list(
		"1" = /turf/space,
		"2" = /turf/simulated/floor/asteroid/basalt,
		"3" = /turf/simulated/floor/snow
	)

	station_name = "Adhomai"
	station_short = "Adhomai"
	dock_name = "New Kingdom of Adhomai"
	dock_short = "NKA"
	boss_name = "New Kingdom of Adhomai"
	boss_short = "NKA"
	company_name = "New Kingdom of Adhomai"
	company_short = "NKA"
	system_name = "S'rand'marr"

	command_spawn_enabled = FALSE

/datum/map/adhomai/generate_asteroid()
	// Create the chasms.
	new /datum/random_map/automata/cave_system/adhomai/under(null,0,0,2,255,255)
	new /datum/random_map/automata/cave_system/adhomai(null,0,0,3,255,255)

	new /datum/random_map/noise/ore(null, 0, 0, 2, 255, 255)
	new /datum/random_map/noise/ore(null, 0, 0, 2, 255, 255)
