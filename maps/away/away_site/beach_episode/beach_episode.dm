/datum/map_template/ruin/away_site/sandbox
	name = "LES YT-U 13029 'Sandbox'"
	description = "It has nice beaches!"

	prefix = "away_site/beach_episode/"
	suffix = "beach_episode.dmm"
	id = "sandbox"

	traits = list(
		//Z1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	exoplanet_atmospheres = list(/datum/gas_mixture/earth_hot)
	exoplanet_lightlevel = list(2, 3, 6)
	exoplanet_lightcolor = list("#fafaa4") // light white-yellowish

	unit_test_groups = list(3)

/singleton/submap_archetype/sandbox
	map = "LES YT-U 13029 'Sandbox'"
	descriptor = "It has nice beaches!"

/obj/effect/overmap/visitable/sector/sandbox
	name = "LES YT-U 13029 'Sandbox'"
	desc = "A remote world within the political orbit of Assunzione, \
	home to a small population of travellers and backpackers. Known \
	for its natural beauty. Data courtesy of the local Coalition \
	authorities informs the reader that this planet wholly lacks a \
	fully fledged power grid, and that any visitors should bring their \
	own generators if they wish for mains electricity during their visit."
	alignment = "Republic of Assunzione"
	icon_state = "globe3"
	color = "#c2b280"
	place_near_main = list(3,3)
