/datum/map_template/ruin/away_site/sandbox
	name = "LES YT-U 13029 'Sandbox'"
	description = "It has nice beaches!"
	prefix = "away_site/beach_episode"
	suffix = "beach_episode.dmm"
	id = "beach_episode"

	sectors = list(SECTOR_AL_MAQDISI)
	spawn_weight = TEMPLATE_FLAG_SPAWN_GUARANTEED
	spawn_cost = 1

	exoplanet_theme_base = /datum/exoplanet_theme/volcanic/tret

	unit_test_groups = list(3)


/obj/effect/overmap/visitable/sector/sandbox
	name = "LES YT-U 13029 'Sandbox'"
	desc = "A remote world within the political orbit of Assunzione, \
	home to a small population of travellers and backpackers. Known \
	for its natural beauty."
	alignment = "Republic of Assunzione"
	icon_state = "globe3"
	color = "#c2b280"
	initial_generic_waypoints = list(
		"sandbox_1",
		"sandbox_2"
	)
